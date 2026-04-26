#include "FFmpegThumbnailer.h"

extern "C" {
#include <libavformat/avformat.h>
#include <libavcodec/avcodec.h>
#include <libavutil/imgutils.h>
#include <libswscale/swscale.h>
}

#include <QDebug>

FFmpegThumbnailer::FFmpegThumbnailer(QObject *parent)
    : QObject(parent)
{
}

QImage FFmpegThumbnailer::extractThumbnail(const QString &filePath, double timeSeconds, int targetWidth)
{
    AVFormatContext *fmtCtx = nullptr;
    if (avformat_open_input(&fmtCtx, filePath.toUtf8().constData(), nullptr, nullptr) < 0) {
        qWarning() << "Thumbnailer: Failed to open file:" << filePath;
        return QImage();
    }

    if (avformat_find_stream_info(fmtCtx, nullptr) < 0) {
        avformat_close_input(&fmtCtx);
        return QImage();
    }

    // Find video stream
    int videoStreamIndex = -1;
    for (unsigned int i = 0; i < fmtCtx->nb_streams; ++i) {
        if (fmtCtx->streams[i]->codecpar->codec_type == AVMEDIA_TYPE_VIDEO) {
            videoStreamIndex = i;
            break;
        }
    }

    if (videoStreamIndex < 0) {
        avformat_close_input(&fmtCtx);
        return QImage();
    }

    AVStream *stream = fmtCtx->streams[videoStreamIndex];
    AVCodecParameters *codecPar = stream->codecpar;

    const AVCodec *codec = avcodec_find_decoder(codecPar->codec_id);
    if (!codec) {
        avformat_close_input(&fmtCtx);
        return QImage();
    }

    AVCodecContext *codecCtx = avcodec_alloc_context3(codec);
    if (!codecCtx) {
        avformat_close_input(&fmtCtx);
        return QImage();
    }

    if (avcodec_parameters_to_context(codecCtx, codecPar) < 0) {
        avcodec_free_context(&codecCtx);
        avformat_close_input(&fmtCtx);
        return QImage();
    }

    if (avcodec_open2(codecCtx, codec, nullptr) < 0) {
        avcodec_free_context(&codecCtx);
        avformat_close_input(&fmtCtx);
        return QImage();
    }

    // Seek to time
    int64_t targetTs = static_cast<int64_t>(timeSeconds * AV_TIME_BASE);
    av_seek_frame(fmtCtx, -1, targetTs, AVSEEK_FLAG_BACKWARD);

    // Read frames until we get a decodable one
    AVFrame *frame = av_frame_alloc();
    AVPacket *packet = av_packet_alloc();
    QImage result;

    while (av_read_frame(fmtCtx, packet) >= 0) {
        if (packet->stream_index == videoStreamIndex) {
            int ret = avcodec_send_packet(codecCtx, packet);
            if (ret < 0) {
                av_packet_unref(packet);
                continue;
            }

            ret = avcodec_receive_frame(codecCtx, frame);
            if (ret == 0) {
                // Convert to RGB
                int srcW = frame->width;
                int srcH = frame->height;
                int dstW = targetWidth;
                int dstH = static_cast<int>(srcH * (static_cast<double>(dstW) / srcW));

                struct SwsContext *swsCtx = sws_getContext(
                    srcW, srcH, static_cast<AVPixelFormat>(frame->format),
                    dstW, dstH, AV_PIX_FMT_RGB24,
                    SWS_BILINEAR, nullptr, nullptr, nullptr);

                if (swsCtx) {
                    uint8_t *rgbData[4];
                    int rgbLinesize[4];
                    av_image_alloc(rgbData, rgbLinesize, dstW, dstH, AV_PIX_FMT_RGB24, 32);

                    sws_scale(swsCtx, frame->data, frame->linesize, 0, srcH, rgbData, rgbLinesize);

                    result = QImage(rgbData[0], dstW, dstH, rgbLinesize[0], QImage::Format_RGB888).copy();

                    av_freep(&rgbData[0]);
                    sws_freeContext(swsCtx);
                }
                break;
            }
        }
        av_packet_unref(packet);
    }

    av_packet_free(&packet);
    av_frame_free(&frame);
    avcodec_free_context(&codecCtx);
    avformat_close_input(&fmtCtx);

    return result;
}

QImage FFmpegThumbnailer::extractImageThumbnail(const QString &filePath, int targetWidth)
{
    // For image files, we use the same path but at time 0
    return extractThumbnail(filePath, 0.0, targetWidth);
}

