#include "trackmodel.h"
#include <QColor>
#include <QFileInfo>
#include <QMediaPlayer>

static const QStringList VIDEO_EXTENSIONS = {"mp4", "avi", "mkv", "mov", "wmv", "flv", "webm", "m4v", "mpg", "mpeg"};
static const QStringList AUDIO_EXTENSIONS = {"mp3", "wav", "aac", "flac", "ogg", "wma", "m4a", "aiff"};
static const QStringList IMAGE_EXTENSIONS = {"png", "jpg", "jpeg", "gif", "bmp", "svg", "webp", "tiff"};

TrackModel::TrackModel(QObject *parent)
    : QAbstractListModel{parent},
      m_videoTrackCount(0),
      m_audioTrackCount(0),
      m_totalDurationFrames(0),
      m_fps(24.0),
      m_probePlayer(new QMediaPlayer(this)),
      m_probeTrackIndex(-1)
{
    connect(m_probePlayer, &QMediaPlayer::durationChanged, this, &TrackModel::onDurationReady);

    addVideoTrack();
    addVideoTrack();
    addAudioTrack();
    addAudioTrack();
}

int TrackModel::msToFrames(int ms) const
{
    if (m_fps <= 0) return 120;
    return static_cast<int>((static_cast<double>(ms) / 1000.0) * m_fps);
}

double TrackModel::fps() const
{
    return m_fps;
}

void TrackModel::setFps(double fps)
{
    m_fps = fps > 0 ? fps : 24.0;
    emit fpsChanged();
}

void TrackModel::onDurationReady(qint64 duration)
{
    if (duration <= 0 || m_probeFilePath.isEmpty())
        return;

    int durationFrames = msToFrames(static_cast<int>(duration));
    if (durationFrames <= 0)
        durationFrames = 120;

    m_probePlayer->stop();

    for (int i = 0; i < m_tracks.size(); i++) {
        for (int j = 0; j < m_tracks[i].clips.size(); j++) {
            if (m_tracks[i].clips[j].filePath == m_probeFilePath) {
                m_tracks[i].clips[j].durationFrames = durationFrames;
                QModelIndex modelIndex = this->index(i);
                emit dataChanged(modelIndex, modelIndex, {TrackTotalDurationRole});
                emit clipsChanged(i);
                recalculateTotalDuration();
                break;
            }
        }
    }

    emit durationProbed(m_probeFilePath, durationFrames);

    m_probeFilePath.clear();
    m_probeTrackIndex = -1;
}

int TrackModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return m_tracks.size();
}

QVariant TrackModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_tracks.size())
        return QVariant();

    const TrackEntry &track = m_tracks.at(index.row());

    switch (role) {
    case TrackNameRole:
        return track.trackName;
    case TrackTypeRole:
        return track.trackType;
    case TrackColorRole:
        return track.trackColor;
    case TrackLockedRole:
        return track.locked;
    case TrackVisibleRole:
        return track.visible;
    case TrackMediaCountRole:
        return track.clips.size();
    case TrackTotalDurationRole:
        return getTrackEndFrame(index.row());
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> TrackModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TrackNameRole] = "trackName";
    roles[TrackTypeRole] = "trackType";
    roles[TrackColorRole] = "trackColor";
    roles[TrackLockedRole] = "trackLocked";
    roles[TrackVisibleRole] = "trackVisible";
    roles[TrackMediaCountRole] = "trackMediaCount";
    roles[TrackTotalDurationRole] = "trackTotalDuration";
    return roles;
}

int TrackModel::trackCount() const
{
    return m_tracks.size();
}

int TrackModel::totalDurationFrames() const
{
    return m_totalDurationFrames;
}

QStringList TrackModel::getTrackIndicesByType(const QString &type) const
{
    QStringList indices;
    for (int i = 0; i < m_tracks.size(); i++) {
        if (m_tracks.at(i).trackType == type) {
            indices.append(QString::number(i));
        }
    }
    return indices;
}

bool TrackModel::isFileCompatibleWithTrack(const QString &filePath, int trackIndex) const
{
    if (trackIndex < 0 || trackIndex >= m_tracks.size())
        return false;

    QString fileType = detectFileType(filePath);
    QString trackType = m_tracks.at(trackIndex).trackType;

    if (fileType == "video")
        return trackType == "video";
    if (fileType == "audio")
        return trackType == "audio";
    if (fileType == "image")
        return trackType == "video";

    return false;
}

QString TrackModel::detectFileType(const QString &filePath) const
{
    QString ext = QFileInfo(filePath).suffix().toLower();
    if (VIDEO_EXTENSIONS.contains(ext))
        return "video";
    if (AUDIO_EXTENSIONS.contains(ext))
        return "audio";
    if (IMAGE_EXTENSIONS.contains(ext))
        return "image";
    return "unknown";
}

int TrackModel::getClipCount(int trackIndex) const
{
    if (trackIndex < 0 || trackIndex >= m_tracks.size())
        return 0;
    return m_tracks.at(trackIndex).clips.size();
}

QString TrackModel::getClipFilePath(int trackIndex, int clipIndex) const
{
    if (trackIndex < 0 || trackIndex >= m_tracks.size())
        return QString();
    const auto &track = m_tracks.at(trackIndex);
    if (clipIndex < 0 || clipIndex >= track.clips.size())
        return QString();
    return track.clips.at(clipIndex).filePath;
}

QString TrackModel::getClipFileName(int trackIndex, int clipIndex) const
{
    if (trackIndex < 0 || trackIndex >= m_tracks.size())
        return QString();
    const auto &track = m_tracks.at(trackIndex);
    if (clipIndex < 0 || clipIndex >= track.clips.size())
        return QString();
    return track.clips.at(clipIndex).fileName;
}

QString TrackModel::getClipFileType(int trackIndex, int clipIndex) const
{
    if (trackIndex < 0 || trackIndex >= m_tracks.size())
        return QString();
    const auto &track = m_tracks.at(trackIndex);
    if (clipIndex < 0 || clipIndex >= track.clips.size())
        return QString();
    return track.clips.at(clipIndex).fileType;
}

int TrackModel::getClipStartFrame(int trackIndex, int clipIndex) const
{
    if (trackIndex < 0 || trackIndex >= m_tracks.size())
        return 0;
    const auto &track = m_tracks.at(trackIndex);
    if (clipIndex < 0 || clipIndex >= track.clips.size())
        return 0;
    return track.clips.at(clipIndex).startFrame;
}

int TrackModel::getClipDurationFrames(int trackIndex, int clipIndex) const
{
    if (trackIndex < 0 || trackIndex >= m_tracks.size())
        return 0;
    const auto &track = m_tracks.at(trackIndex);
    if (clipIndex < 0 || clipIndex >= track.clips.size())
        return 0;
    return track.clips.at(clipIndex).durationFrames;
}

int TrackModel::getTrackEndFrame(int trackIndex) const
{
    if (trackIndex < 0 || trackIndex >= m_tracks.size())
        return 0;
    const auto &track = m_tracks.at(trackIndex);
    if (track.clips.isEmpty())
        return 0;
    int maxEnd = 0;
    for (const auto &clip : track.clips) {
        int end = clip.startFrame + clip.durationFrames;
        if (end > maxEnd)
            maxEnd = end;
    }
    return maxEnd;
}

void TrackModel::importMedia(const QString &filePath, int trackIndex)
{
    if (trackIndex < 0 || trackIndex >= m_tracks.size())
        return;
    if (!isFileCompatibleWithTrack(filePath, trackIndex))
        return;

    QFileInfo fileInfo(filePath);
    if (!fileInfo.exists())
        return;

    int startFrame = getTrackEndFrame(trackIndex);
    QString fileType = detectFileType(filePath);
    int defaultDurationFrames = 120;
    if (fileType == "image")
        defaultDurationFrames = msToFrames(5000);

    ClipEntry clip;
    clip.filePath = fileInfo.absoluteFilePath();
    clip.fileName = fileInfo.fileName();
    clip.fileType = fileType;
    clip.startFrame = startFrame;
    clip.durationFrames = defaultDurationFrames;

    TrackEntry &track = m_tracks[trackIndex];
    track.clips.append(clip);

    QModelIndex modelIndex = this->index(trackIndex);
    emit dataChanged(modelIndex, modelIndex, {TrackMediaCountRole, TrackTotalDurationRole});
    emit mediaImportedToTrack(filePath, track.trackName);
    emit clipsChanged(trackIndex);

    recalculateTotalDuration();

    if (fileType == "video" || fileType == "audio") {
        m_probeFilePath = clip.filePath;
        m_probeTrackIndex = trackIndex;
        m_probePlayer->setSource(QUrl::fromLocalFile(clip.filePath));
    }
}

void TrackModel::importMediaWithDuration(const QString &filePath, int trackIndex, int durationMs)
{
    int frames = msToFrames(durationMs);
    if (frames > 0)
        setClipDuration(filePath, frames);
}

void TrackModel::setClipDuration(const QString &filePath, int durationFrames)
{
    for (int i = 0; i < m_tracks.size(); i++) {
        for (int j = 0; j < m_tracks[i].clips.size(); j++) {
            if (m_tracks[i].clips[j].filePath == filePath) {
                m_tracks[i].clips[j].durationFrames = durationFrames;
                QModelIndex modelIndex = this->index(i);
                emit dataChanged(modelIndex, modelIndex, {TrackTotalDurationRole});
                emit clipsChanged(i);
                recalculateTotalDuration();
                return;
            }
        }
    }
}

void TrackModel::recalculateTotalDuration()
{
    int maxFrame = 0;
    for (int i = 0; i < m_tracks.size(); i++) {
        int end = getTrackEndFrame(i);
        if (end > maxFrame)
            maxFrame = end;
    }
    if (m_totalDurationFrames != maxFrame) {
        m_totalDurationFrames = maxFrame;
        emit totalDurationFramesChanged();
    }
}

void TrackModel::addTrack(const QString &name, const QString &type)
{
    beginInsertRows(QModelIndex(), m_tracks.size(), m_tracks.size());
    TrackEntry entry;
    entry.trackName = name;
    entry.trackType = type;
    entry.trackColor = defaultTrackColor(type, m_tracks.size()).name();
    entry.locked = false;
    entry.visible = true;
    m_tracks.append(entry);
    endInsertRows();
    emit trackCountChanged();
    emit trackAdded(name, type);
}

void TrackModel::addVideoTrack()
{
    m_videoTrackCount++;
    addTrack(autoGenerateTrackName("video"), "video");
}

void TrackModel::addAudioTrack()
{
    m_audioTrackCount++;
    addTrack(autoGenerateTrackName("audio"), "audio");
}

void TrackModel::removeTrack(int index)
{
    if (index < 0 || index >= m_tracks.size())
        return;

    beginRemoveRows(QModelIndex(), index, index);
    m_tracks.removeAt(index);
    endRemoveRows();
    emit trackCountChanged();
}

void TrackModel::toggleLock(int index)
{
    if (index < 0 || index >= m_tracks.size())
        return;

    m_tracks[index].locked = !m_tracks[index].locked;
    QModelIndex modelIndex = this->index(index);
    emit dataChanged(modelIndex, modelIndex, {TrackLockedRole});
}

void TrackModel::toggleVisible(int index)
{
    if (index < 0 || index >= m_tracks.size())
        return;

    m_tracks[index].visible = !m_tracks[index].visible;
    QModelIndex modelIndex = this->index(index);
    emit dataChanged(modelIndex, modelIndex, {TrackVisibleRole});
}

void TrackModel::importMediaToTrack(const QString &filePath, int trackIndex)
{
    if (trackIndex < 0 || trackIndex >= m_tracks.size())
        return;

    if (!isFileCompatibleWithTrack(filePath, trackIndex)) {
        qWarning() << "File incompatible with track:" << filePath << "track" << trackIndex;
        return;
    }

    importMedia(filePath, trackIndex);
}

QString TrackModel::getTrackNameAt(int index) const
{
    if (index >= 0 && index < m_tracks.size())
        return m_tracks.at(index).trackName;
    return QString();
}

QString TrackModel::getTrackTypeAt(int index) const
{
    if (index >= 0 && index < m_tracks.size())
        return m_tracks.at(index).trackType;
    return QString();
}

void TrackModel::clearTracks()
{
    beginResetModel();
    m_tracks.clear();
    m_videoTrackCount = 0;
    m_audioTrackCount = 0;
    m_totalDurationFrames = 0;
    endResetModel();
    emit trackCountChanged();
}

QString TrackModel::autoGenerateTrackName(const QString &type) const
{
    if (type == "video")
        return "V" + QString::number(m_videoTrackCount);
    else
        return "A" + QString::number(m_audioTrackCount);
}

QColor TrackModel::defaultTrackColor(const QString &type, int index) const
{
    if (type == "video") {
        static const QStringList videoColors = {"#3b82f6", "#8b5cf6", "#06b6d4", "#f59e0b"};
        return QColor(videoColors[index % videoColors.size()]);
    } else {
        static const QStringList audioColors = {"#22c55e", "#14b8a6", "#ec4899", "#f97316"};
        return QColor(audioColors[index % audioColors.size()]);
    }
}
