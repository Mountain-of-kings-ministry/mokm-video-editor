#ifndef FFMPEG_MEDIA_PROBE_H
#define FFMPEG_MEDIA_PROBE_H

#include <QString>
#include <QObject>

struct MediaProbeResult {
    QString filename;
    QString filePath;
    QString duration;       // "00:00:23:14" (timecode format)
    double durationSeconds = 0.0;
    QString resolution;     // "1920x1080"
    int width = 0;
    int height = 0;
    QString frameRate;      // "23.976 fps"
    double fps = 0.0;
    QString codec;          // "H.265"
    QString codecLongName;  // "H.265 / HEVC"
    QString pixelFormat;    // "yuv420p10le"
    int bitDepth = 8;
    QString audioCodec;
    int audioChannels = 0;
    int audioSampleRate = 0;
    bool hasVideo = false;
    bool hasAudio = false;
    bool isImageSequence = false;
    QString mediaType;      // "Video", "Audio", "Image"
};

class FFmpegMediaProbe : public QObject {
    Q_OBJECT
public:
    explicit FFmpegMediaProbe(QObject *parent = nullptr);

    static MediaProbeResult probeFile(const QString &filePath);

private:
    static QString secondsToTimecode(double seconds, double fps);
    static double avRationalToDouble(void *rational); // AVRational*
};

#endif // FFMPEG_MEDIA_PROBE_H

