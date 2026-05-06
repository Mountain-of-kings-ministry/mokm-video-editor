#include "ffmpegcompositionengine.h"
#include "ffmpegprobe.h"
#include "trackmodel.h"
#include "timelineplayer.h"
#include <QProcess>
#include <QDebug>
#include <QPainter>
#include <QImage>
#include <QStandardPaths>

FFmpegCompositionEngine::FFmpegCompositionEngine(QObject *parent)
    : QObject{parent},
      m_trackModel(nullptr),
      m_timelinePlayer(nullptr),
      m_probe(new FFmpegProbe(this)),
      m_isReady(false)
{
    m_ffmpegPath = FFmpegProbe::findFFmpeg();
    m_currentFrame = QImage(1280, 720, QImage::Format_ARGB32);
    m_currentFrame.fill(Qt::black);
}

void FFmpegCompositionEngine::setTrackModel(TrackModel *model)
{
    m_trackModel = model;
    connect(model, &TrackModel::clipsChanged, this, [this]() {
        m_imageCache.clear();
        m_videoFrameCache.clear();
    });
}

void FFmpegCompositionEngine::setTimelinePlayer(TimelinePlayer *player)
{
    m_timelinePlayer = player;
    connect(player, &TimelinePlayer::positionChanged, this, [this]() {
        if (m_timelinePlayer->isPlaying()) {
            renderFrame(m_timelinePlayer->position());
        }
    });
}

void FFmpegCompositionEngine::setFFmpegPath(const QString &path)
{
    m_ffmpegPath = path;
    m_probe->setFFmpegPath(path);
}

QImage FFmpegCompositionEngine::currentFrame() const
{
    return m_currentFrame;
}

bool FFmpegCompositionEngine::isReady() const
{
    return m_isReady;
}

void FFmpegCompositionEngine::play()
{
    if (!m_trackModel || !m_timelinePlayer)
        return;
    m_isReady = true;
    emit isReadyChanged();
    renderFrame(m_timelinePlayer->position());
}

void FFmpegCompositionEngine::pause()
{
}

void FFmpegCompositionEngine::stop()
{
    m_currentFrame.fill(Qt::black);
    emit currentFrameChanged();
}

void FFmpegCompositionEngine::seek(int frame)
{
    renderFrame(frame);
}

void FFmpegCompositionEngine::renderFrame(int frame)
{
    if (!m_trackModel)
        return;

    QMutexLocker locker(&m_frameMutex);

    QImage composite(1280, 720, QImage::Format_ARGB32);
    composite.fill(Qt::black);
    QPainter painter(&composite);
    painter.setRenderHint(QPainter::SmoothPixmapTransform);

    bool hasVideo = false;
    bool hasAudio = false;

    for (int ti = 0; ti < m_trackModel->trackCount(); ti++) {
        QString trackType = m_trackModel->getTrackTypeAt(ti);
        if (!m_trackModel->data(m_trackModel->index(ti), TrackModel::TrackVisibleRole).toBool())
            continue;

        for (int ci = 0; ci < m_trackModel->getClipCount(ti); ci++) {
            int start = m_trackModel->getClipStartFrame(ti, ci);
            int duration = m_trackModel->getClipDurationFrames(ti, ci);
            int end = start + duration;

            if (frame >= start && frame < end) {
                QString filePath = m_trackModel->getClipFilePath(ti, ci);
                QString fileType = m_trackModel->getClipFileType(ti, ci);

                if (fileType == "video" || fileType == "image") {
                    hasVideo = true;
                    QImage clipFrame;

                    if (fileType == "image") {
                        if (m_imageCache.contains(filePath)) {
                            clipFrame = m_imageCache.value(filePath);
                        } else {
                            clipFrame = decodeImageFrame(filePath);
                            if (!clipFrame.isNull()) {
                                m_imageCache.insert(filePath, clipFrame);
                            }
                        }
                    } else {
                        int localFrame = frame - start;
                        double timestamp = localFrame / m_timelinePlayer->fps();

                        QString cacheKey = filePath + "_" + QString::number(localFrame);
                        if (m_videoFrameCache.contains(filePath) &&
                            m_videoFrameCache.value(filePath).contains(localFrame)) {
                            clipFrame = m_videoFrameCache.value(filePath).value(localFrame);
                        } else {
                            clipFrame = decodeVideoFrame(filePath, timestamp);
                            if (!clipFrame.isNull()) {
                                m_videoFrameCache[filePath].insert(localFrame, clipFrame);
                            }
                        }
                    }

                    if (!clipFrame.isNull()) {
                        double aspectRatio = (double)clipFrame.width() / clipFrame.height();
                        int drawWidth = 1280;
                        int drawHeight = (int)(1280 / aspectRatio);
                        if (drawHeight > 720) {
                            drawHeight = 720;
                            drawWidth = (int)(720 * aspectRatio);
                        }
                        int x = (1280 - drawWidth) / 2;
                        int y = (720 - drawHeight) / 2;
                        painter.drawImage(x, y, clipFrame.scaled(drawWidth, drawHeight,
                            Qt::KeepAspectRatio, Qt::SmoothTransformation));
                    }
                }

                if (fileType == "audio") {
                    hasAudio = true;
                }
            }
        }
    }

    m_currentFrame = composite;
    locker.unlock();
    emit currentFrameChanged();
}

QImage FFmpegCompositionEngine::decodeVideoFrame(const QString &filePath, double timestamp)
{
    QProcess process;
    process.start(m_ffmpegPath, QStringList()
        << "-ss" << QString::number(timestamp, 'f', 3)
        << "-i" << filePath
        << "-vframes" << "1"
        << "-f" << "image2pipe"
        << "-vcodec" << "png"
        << "-");

    if (!process.waitForFinished(5000)) {
        process.kill();
        return QImage();
    }

    if (process.exitCode() != 0) {
        return QImage();
    }

    QByteArray data = process.readAllStandardOutput();
    QImage img;
    img.loadFromData(data, "PNG");
    return img;
}

QImage FFmpegCompositionEngine::decodeImageFrame(const QString &filePath)
{
    QImage img(filePath);
    return img;
}
