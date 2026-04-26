#ifndef FFMPEG_THUMBNAILER_H
#define FFMPEG_THUMBNAILER_H

#include <QImage>
#include <QString>
#include <QObject>

class FFmpegThumbnailer : public QObject {
    Q_OBJECT
public:
    explicit FFmpegThumbnailer(QObject *parent = nullptr);

    // Extract a thumbnail at a specific time (in seconds). Returns null image on failure.
    static QImage extractThumbnail(const QString &filePath, double timeSeconds = 0.0, int targetWidth = 320);

    // Extract thumbnail for image files (just decode and scale)
    static QImage extractImageThumbnail(const QString &filePath, int targetWidth = 320);
};

#endif // FFMPEG_THUMBNAILER_H

