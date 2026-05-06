#ifndef FFMPEGPROBE_H
#define FFMPEGPROBE_H

#include <QProcess>
#include <QString>

struct MediaInfo {
    double duration;
    int width;
    int height;
    QString videoCodec;
    QString audioCodec;
    bool hasVideo;
    bool hasAudio;
    bool isValid;
};

class FFmpegProbe : public QObject
{
    Q_OBJECT

public:
    explicit FFmpegProbe(QObject *parent = nullptr);

    void setFFprobePath(const QString &path);
    void setFFmpegPath(const QString &path);

    MediaInfo probe(const QString &filePath);
    static QString findFFprobe();
    static QString findFFmpeg();

signals:
    void probeComplete(const QString &filePath, MediaInfo info);

private:
    MediaInfo parseOutput(const QString &output);

    QString m_ffprobePath;
    QString m_ffmpegPath;
};

#endif
