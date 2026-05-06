#ifndef TIMELINEPLAYBACKENGINE_H
#define TIMELINEPLAYBACKENGINE_H

#include <QObject>
#include <QUrl>

class QMediaPlayer;
class QAudioOutput;
class TimelinePlayer;
class TrackModel;

class TimelinePlaybackEngine : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QUrl currentSource READ currentSource NOTIFY currentSourceChanged)
    Q_PROPERTY(int currentPosition READ currentPosition NOTIFY currentPositionChanged)

public:
    explicit TimelinePlaybackEngine(QObject *parent = nullptr);

    void setTrackModel(TrackModel *model);
    void setTimelinePlayer(TimelinePlayer *player);

    QUrl currentSource() const;
    int currentPosition() const;

public slots:
    void play();
    void pause();
    void stop();
    void seek(int frame);

signals:
    void currentSourceChanged();
    void currentPositionChanged();
    void engineError(const QString &error);

private slots:
    void onTimelineTick();
    void onPositionChanged();
    void onTrackModelChanged();
    void onTotalDurationChanged();
    void onVideoMediaStatusChanged();
    void onAudioMediaStatusChanged();

private:
    void updateCurrentClip();
    void switchToVideoClip(int trackIndex, int clipIndex);
    void switchToAudioClip(int trackIndex, int clipIndex);
    void findClipsAtFrame(int frame, int &videoTrackIdx, int &videoClipIdx, int &audioTrackIdx, int &audioClipIdx) const;

    TrackModel *m_trackModel;
    TimelinePlayer *m_timelinePlayer;
    QMediaPlayer *m_videoPlayer;
    QMediaPlayer *m_audioPlayer;
    QAudioOutput *m_audioOutput;

    QUrl m_currentSource;
    int m_currentVideoTrackIndex;
    int m_currentVideoClipIndex;
    int m_currentAudioTrackIndex;
    int m_currentAudioClipIndex;
    int m_currentFrame;
    bool m_isSeeking;
};

#endif
