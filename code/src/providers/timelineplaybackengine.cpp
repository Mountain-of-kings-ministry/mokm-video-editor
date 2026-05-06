#include "timelineplaybackengine.h"
#include "trackmodel.h"
#include "timelineplayer.h"
#include <QMediaPlayer>
#include <QAudioOutput>

TimelinePlaybackEngine::TimelinePlaybackEngine(QObject *parent)
    : QObject{parent},
      m_trackModel(nullptr),
      m_timelinePlayer(nullptr),
      m_videoPlayer(new QMediaPlayer(this)),
      m_audioPlayer(new QMediaPlayer(this)),
      m_audioOutput(new QAudioOutput(this)),
      m_currentVideoTrackIndex(-1),
      m_currentVideoClipIndex(-1),
      m_currentAudioTrackIndex(-1),
      m_currentAudioClipIndex(-1),
      m_currentFrame(0),
      m_isSeeking(false)
{
    m_audioPlayer->setAudioOutput(m_audioOutput);
    m_audioOutput->setVolume(1.0);

    connect(m_videoPlayer, &QMediaPlayer::mediaStatusChanged,
            this, &TimelinePlaybackEngine::onVideoMediaStatusChanged);
    connect(m_audioPlayer, &QMediaPlayer::mediaStatusChanged,
            this, &TimelinePlaybackEngine::onAudioMediaStatusChanged);
}

void TimelinePlaybackEngine::setTrackModel(TrackModel *model)
{
    m_trackModel = model;
    connect(model, &TrackModel::clipsChanged, this, &TimelinePlaybackEngine::onTrackModelChanged);
    connect(model, &TrackModel::totalDurationFramesChanged,
            this, &TimelinePlaybackEngine::onTotalDurationChanged);
    onTotalDurationChanged();
}

void TimelinePlaybackEngine::setTimelinePlayer(TimelinePlayer *player)
{
    m_timelinePlayer = player;
    connect(player, &TimelinePlayer::positionChanged,
            this, &TimelinePlaybackEngine::onPositionChanged);
}

QUrl TimelinePlaybackEngine::currentSource() const
{
    return m_currentSource;
}

int TimelinePlaybackEngine::currentPosition() const
{
    return m_currentFrame;
}

void TimelinePlaybackEngine::play()
{
    if (!m_trackModel || !m_timelinePlayer)
        return;

    updateCurrentClip();

    if (m_currentVideoTrackIndex >= 0 && m_currentVideoClipIndex >= 0) {
        if (m_videoPlayer->source() != QUrl()) {
            m_videoPlayer->play();
        }
    }

    if (m_currentAudioTrackIndex >= 0 && m_currentAudioClipIndex >= 0) {
        if (m_audioPlayer->source() != QUrl()) {
            m_audioPlayer->play();
        }
    }
}

void TimelinePlaybackEngine::pause()
{
    m_videoPlayer->pause();
    m_audioPlayer->pause();
}

void TimelinePlaybackEngine::stop()
{
    m_videoPlayer->stop();
    m_audioPlayer->stop();
    m_currentVideoTrackIndex = -1;
    m_currentVideoClipIndex = -1;
    m_currentAudioTrackIndex = -1;
    m_currentAudioClipIndex = -1;
    m_currentSource = QUrl();
    emit currentSourceChanged();
}

void TimelinePlaybackEngine::seek(int frame)
{
    m_isSeeking = true;
    m_currentFrame = frame;

    int videoTrackIdx = -1, videoClipIdx = -1;
    int audioTrackIdx = -1, audioClipIdx = -1;
    findClipsAtFrame(frame, videoTrackIdx, videoClipIdx, audioTrackIdx, audioClipIdx);

    if (videoTrackIdx >= 0 && videoClipIdx >= 0) {
        switchToVideoClip(videoTrackIdx, videoClipIdx);
    } else {
        m_videoPlayer->stop();
        m_currentVideoTrackIndex = -1;
        m_currentVideoClipIndex = -1;
        m_currentSource = QUrl();
        emit currentSourceChanged();
    }

    if (audioTrackIdx >= 0 && audioClipIdx >= 0) {
        switchToAudioClip(audioTrackIdx, audioClipIdx);
    } else {
        m_audioPlayer->stop();
        m_currentAudioTrackIndex = -1;
        m_currentAudioClipIndex = -1;
    }

    m_isSeeking = false;
}

void TimelinePlaybackEngine::onTimelineTick()
{
    updateCurrentClip();
}

void TimelinePlaybackEngine::onPositionChanged()
{
    if (!m_timelinePlayer)
        return;

    int frame = m_timelinePlayer->position();
    if (frame == m_currentFrame)
        return;

    m_currentFrame = frame;
    updateCurrentClip();
}

void TimelinePlaybackEngine::onTrackModelChanged()
{
    updateCurrentClip();
}

void TimelinePlaybackEngine::onTotalDurationChanged()
{
    if (m_trackModel && m_timelinePlayer) {
        m_timelinePlayer->setDuration(m_trackModel->totalDurationFrames());
    }
}

void TimelinePlaybackEngine::onVideoMediaStatusChanged()
{
    QMediaPlayer::MediaStatus status = m_videoPlayer->mediaStatus();
    if (status == QMediaPlayer::LoadedMedia || status == QMediaPlayer::BufferedMedia) {
        if (m_timelinePlayer && m_timelinePlayer->isPlaying()) {
            m_videoPlayer->play();
        }
    }
}

void TimelinePlaybackEngine::onAudioMediaStatusChanged()
{
    QMediaPlayer::MediaStatus status = m_audioPlayer->mediaStatus();
    if (status == QMediaPlayer::LoadedMedia || status == QMediaPlayer::BufferedMedia) {
        if (m_timelinePlayer && m_timelinePlayer->isPlaying()) {
            m_audioPlayer->play();
        }
    }
}

void TimelinePlaybackEngine::updateCurrentClip()
{
    if (!m_trackModel || !m_timelinePlayer)
        return;

    int frame = m_timelinePlayer->position();
    int videoTrackIdx = -1, videoClipIdx = -1;
    int audioTrackIdx = -1, audioClipIdx = -1;
    findClipsAtFrame(frame, videoTrackIdx, videoClipIdx, audioTrackIdx, audioClipIdx);

    if (videoTrackIdx >= 0 && videoClipIdx >= 0) {
        if (videoTrackIdx != m_currentVideoTrackIndex || videoClipIdx != m_currentVideoClipIndex) {
            switchToVideoClip(videoTrackIdx, videoClipIdx);
        }
    } else {
        if (m_currentVideoTrackIndex >= 0) {
            m_videoPlayer->stop();
            m_currentVideoTrackIndex = -1;
            m_currentVideoClipIndex = -1;
            m_currentSource = QUrl();
            emit currentSourceChanged();
        }
    }

    if (audioTrackIdx >= 0 && audioClipIdx >= 0) {
        if (audioTrackIdx != m_currentAudioTrackIndex || audioClipIdx != m_currentAudioClipIndex) {
            switchToAudioClip(audioTrackIdx, audioClipIdx);
        }
    } else {
        if (m_currentAudioTrackIndex >= 0) {
            m_audioPlayer->stop();
            m_currentAudioTrackIndex = -1;
            m_currentAudioClipIndex = -1;
        }
    }
}

void TimelinePlaybackEngine::switchToVideoClip(int trackIndex, int clipIndex)
{
    if (!m_trackModel)
        return;

    QString filePath = m_trackModel->getClipFilePath(trackIndex, clipIndex);
    int clipStart = m_trackModel->getClipStartFrame(trackIndex, clipIndex);
    int localMs = (m_currentFrame - clipStart) * (1000 / 24);

    m_currentVideoTrackIndex = trackIndex;
    m_currentVideoClipIndex = clipIndex;

    QUrl newSource = QUrl::fromLocalFile(filePath);

    if (m_videoPlayer->source() != newSource) {
        m_videoPlayer->stop();
        m_currentSource = newSource;
        emit currentSourceChanged();
        m_videoPlayer->setSource(newSource);
    }

    m_videoPlayer->setPosition(localMs);

    if (m_timelinePlayer && m_timelinePlayer->isPlaying()) {
        m_videoPlayer->play();
    }
}

void TimelinePlaybackEngine::switchToAudioClip(int trackIndex, int clipIndex)
{
    if (!m_trackModel)
        return;

    QString filePath = m_trackModel->getClipFilePath(trackIndex, clipIndex);
    int clipStart = m_trackModel->getClipStartFrame(trackIndex, clipIndex);
    int localMs = (m_currentFrame - clipStart) * (1000 / 24);

    m_currentAudioTrackIndex = trackIndex;
    m_currentAudioClipIndex = clipIndex;

    QUrl newSource = QUrl::fromLocalFile(filePath);

    if (m_audioPlayer->source() != newSource) {
        m_audioPlayer->stop();
        m_audioPlayer->setSource(newSource);
    }

    m_audioPlayer->setPosition(localMs);

    if (m_timelinePlayer && m_timelinePlayer->isPlaying()) {
        m_audioPlayer->play();
    }
}

void TimelinePlaybackEngine::findClipsAtFrame(int frame, int &videoTrackIdx, int &videoClipIdx, int &audioTrackIdx, int &audioClipIdx) const
{
    if (!m_trackModel)
        return;

    for (int ti = 0; ti < m_trackModel->trackCount(); ti++) {
        QString trackType = m_trackModel->getTrackTypeAt(ti);

        for (int ci = 0; ci < m_trackModel->getClipCount(ti); ci++) {
            int start = m_trackModel->getClipStartFrame(ti, ci);
            int duration = m_trackModel->getClipDurationFrames(ti, ci);
            int end = start + duration;

            if (frame >= start && frame < end) {
                QString fileType = m_trackModel->getClipFileType(ti, ci);

                if (trackType == "video" && (fileType == "video" || fileType == "image")) {
                    if (videoTrackIdx < 0) {
                        videoTrackIdx = ti;
                        videoClipIdx = ci;
                    }
                }

                if (trackType == "audio" && fileType == "audio") {
                    if (audioTrackIdx < 0) {
                        audioTrackIdx = ti;
                        audioClipIdx = ci;
                    }
                }
            }
        }
    }
}
