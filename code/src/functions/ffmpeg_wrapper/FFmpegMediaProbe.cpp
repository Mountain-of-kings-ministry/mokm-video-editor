#include "FFmpegMediaProbe.h"

extern "C"
{
#include <libavformat/avformat.h>
#include <libavcodec/avcodec.h>
#include <libavutil/rational.h>
#include <libavutil/dict.h>
#include <libavutil/pixdesc.h>
}

#include <QFileInfo>
#include <QDebug>

FFmpegMediaProbe::FFmpegMediaProbe(QObject *parent)
    : QObject(parent)
{
}

QString FFmpegMediaProbe::secondsToTimecode(double seconds, double fps)
{
    if (fps <= 0)
        fps = 24.0;
    int totalFrames = static_cast<int>(seconds * fps);
    int frames = totalFrames % static_cast<int>(fps);
    int totalSeconds = totalFrames / static_cast<int>(fps);
    int hrs = totalSeconds / 3600;
    int mins = (totalSeconds % 3600) / 60;
    int secs = totalSeconds % 60;
    return QString("%1:%2:%3:%4")
        .arg(hrs, 2, 10, QChar('0'))
        .arg(mins, 2, 10, QChar('0'))
        .arg(secs, 2, 10, QChar('0'))
        .arg(frames, 2, 10, QChar('0'));
}

double FFmpegMediaProbe::avRationalToDouble(void *rational)
{
    AVRational *r = static_cast<AVRational *>(rational);
    return av_q2d(*r);
}

MediaProbeResult FFmpegMediaProbe::probeFile(const QString &filePath)
{
    MediaProbeResult result;
    result.filePath = filePath;
    result.filename = QFileInfo(filePath).fileName();

    AVFormatContext *fmtCtx = nullptr;
    if (avformat_open_input(&fmtCtx, filePath.toUtf8().constData(), nullptr, nullptr) < 0)
    {
        qWarning() << "Failed to open file:" << filePath;
        return result;
    }

    if (avformat_find_stream_info(fmtCtx, nullptr) < 0)
    {
        qWarning() << "Failed to find stream info:" << filePath;
        avformat_close_input(&fmtCtx);
        return result;
    }

    // Duration
    if (fmtCtx->duration != AV_NOPTS_VALUE)
    {
        result.durationSeconds = static_cast<double>(fmtCtx->duration) / AV_TIME_BASE;
    }

    // Probe streams
    int videoStreamIndex = -1;
    int audioStreamIndex = -1;

    for (unsigned int i = 0; i < fmtCtx->nb_streams; ++i)
    {
        AVStream *stream = fmtCtx->streams[i];
        if (stream->codecpar->codec_type == AVMEDIA_TYPE_VIDEO && videoStreamIndex < 0)
        {
            videoStreamIndex = i;
        }
        else if (stream->codecpar->codec_type == AVMEDIA_TYPE_AUDIO && audioStreamIndex < 0)
        {
            audioStreamIndex = i;
        }
    }

    // Video info
    if (videoStreamIndex >= 0)
    {
        AVStream *vStream = fmtCtx->streams[videoStreamIndex];
        AVCodecParameters *vCodecPar = vStream->codecpar;

        result.hasVideo = true;
        result.width = vCodecPar->width;
        result.height = vCodecPar->height;
        result.resolution = QString("%1x%2").arg(result.width).arg(result.height);

        // Frame rate
        AVRational frameRate = vStream->avg_frame_rate;
        if (frameRate.den == 0 || av_q2d(frameRate) == 0)
        {
            frameRate = vStream->r_frame_rate;
        }
        result.fps = av_q2d(frameRate);
        result.frameRate = QString::number(result.fps, 'f', 3) + " fps";

        // Duration in timecode
        double durationSec = result.durationSeconds;
        if (durationSec <= 0 && vStream->duration != AV_NOPTS_VALUE)
        {
            durationSec = av_q2d(vStream->time_base) * vStream->duration;
        }
        if (durationSec > 0)
        {
            result.durationSeconds = durationSec;
            result.duration = secondsToTimecode(durationSec, result.fps);
        }

        // Codec
        const AVCodec *codec = avcodec_find_decoder(vCodecPar->codec_id);
        if (codec)
        {
            result.codec = QString(codec->name).toUpper();
            result.codecLongName = codec->long_name ? QString(codec->long_name) : result.codec;
        }

        // Pixel format & bit depth
        if (vCodecPar->format != -1)
        {
            const char *pixFmtName = av_get_pix_fmt_name(static_cast<AVPixelFormat>(vCodecPar->format));
            if (pixFmtName)
            {
                result.pixelFormat = QString(pixFmtName);
                // Estimate bit depth from pixel format name
                if (result.pixelFormat.contains("10le") || result.pixelFormat.contains("10be"))
                {
                    result.bitDepth = 10;
                }
                else if (result.pixelFormat.contains("12le") || result.pixelFormat.contains("12be"))
                {
                    result.bitDepth = 12;
                }
                else if (result.pixelFormat.contains("16le") || result.pixelFormat.contains("16be"))
                {
                    result.bitDepth = 16;
                }
            }
        }
    }

    // Audio info
    if (audioStreamIndex >= 0)
    {
        AVStream *aStream = fmtCtx->streams[audioStreamIndex];
        AVCodecParameters *aCodecPar = aStream->codecpar;

        result.hasAudio = true;
        result.audioChannels = aCodecPar->ch_layout.nb_channels;
        result.audioSampleRate = aCodecPar->sample_rate;

        const AVCodec *aCodec = avcodec_find_decoder(aCodecPar->codec_id);
        if (aCodec)
        {
            result.audioCodec = QString(aCodec->name).toUpper();
        }
    }

    // Determine media type
    if (result.hasVideo && result.hasAudio)
    {
        result.mediaType = "Video";
    }
    else if (result.hasVideo)
    {
        // Could be image or video
        if (result.durationSeconds <= 0.04 || QFileInfo(filePath).suffix().toLower() == "jpg" || QFileInfo(filePath).suffix().toLower() == "png")
        {
            result.mediaType = "Image";
            result.duration = "00:00:00:00";
            result.durationSeconds = 0;
            result.isImageSequence = false;
        }
        else
        {
            result.mediaType = "Video";
        }
    }
    else if (result.hasAudio)
    {
        result.mediaType = "Audio";
        result.duration = secondsToTimecode(result.durationSeconds, 24.0);
    }

    avformat_close_input(&fmtCtx);
    return result;
}
