#ifndef FFMPEGCOMPOSITIONENGINE_H
#define FFMPEGCOMPOSITIONENGINE_H

#include <QObject>
#include <QImage>
#include <QProcess>
#include <QMutex>
#include <QMap>

class TimelinePlayer;
class TrackModel;
class FFmpegProbe;

struct ClipDecodeResult {
    QImage frame;
    int clipTrackIndex;
    int clipIndex;
    int frameNumber;
};

class FFmpegCompositionEngine : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QImage currentFrame READ currentFrame NOTIFY currentFrameChanged)
    Q_PROPERTY(bool isReady READ isReady NOTIFY isReadyChanged)

public:
    explicit FFmpegCompositionEngine(QObject *parent = nullptr);

    void setTrackModel(TrackModel *model);
    void setTimelinePlayer(TimelinePlayer *player);
    void setFFmpegPath(const QString &path);

    QImage currentFrame() const;
    bool isReady() const;

public slots:
    void play();
    void pause();
    void stop();
    void seek(int frame);
    void renderFrame(int frame);

signals:
    void currentFrameChanged();
    void isReadyChanged();
    void frameDecoded(int frame);
    void decodeError(const QString &error);

private:
    QImage decodeVideoFrame(const QString &filePath, double timestamp);
    QImage decodeImageFrame(const QString &filePath);
    void compositeFrame(int frame);

    TrackModel *m_trackModel;
    TimelinePlayer *m_timelinePlayer;
    FFmpegProbe *m_probe;
    QString m_ffmpegPath;

    QImage m_currentFrame;
    QMutex m_frameMutex;
    bool m_isReady;

    QMap<QString, QImage> m_imageCache;
    QMap<QString, QMap<int, QImage>> m_videoFrameCache;
};

#endif
