#include "ffmpegprobe.h"
#include <QProcess>
#include <QFileInfo>
#include <QDebug>
#include <QStandardPaths>

FFmpegProbe::FFmpegProbe(QObject *parent)
    : QObject{parent}
{
    m_ffprobePath = findFFprobe();
    m_ffmpegPath = findFFmpeg();
}

void FFmpegProbe::setFFprobePath(const QString &path)
{
    m_ffprobePath = path;
}

void FFmpegProbe::setFFmpegPath(const QString &path)
{
    m_ffmpegPath = path;
}

QString FFmpegProbe::findFFprobe()
{
    QString path = QStandardPaths::findExecutable("ffprobe");
    if (!path.isEmpty())
        return path;
    return "ffprobe";
}

QString FFmpegProbe::findFFmpeg()
{
    QString path = QStandardPaths::findExecutable("ffmpeg");
    if (!path.isEmpty())
        return path;
    return "ffmpeg";
}

MediaInfo FFmpegProbe::probe(const QString &filePath)
{
    MediaInfo info;
    info.duration = 0;
    info.width = 0;
    info.height = 0;
    info.hasVideo = false;
    info.hasAudio = false;
    info.isValid = false;

    if (!QFileInfo::exists(filePath))
        return info;

    QProcess process;
    process.start(m_ffprobePath, QStringList()
        << "-v" << "quiet"
        << "-print_format" << "json"
        << "-show_format"
        << "-show_streams"
        << filePath);

    if (!process.waitForFinished(10000)) {
        qWarning() << "ffprobe timed out for:" << filePath;
        return info;
    }

    if (process.exitCode() != 0) {
        qWarning() << "ffprobe failed for:" << filePath;
        return info;
    }

    QString output = process.readAllStandardOutput();
    return parseOutput(output);
}

MediaInfo FFmpegProbe::parseOutput(const QString &output)
{
    MediaInfo info;
    info.duration = 0;
    info.width = 0;
    info.height = 0;
    info.hasVideo = false;
    info.hasAudio = false;
    info.isValid = true;

    QStringList lines = output.split('\n');

    bool inStream = false;
    bool inFormat = false;
    QString currentCodecType;

    for (const QString &line : lines) {
        QString trimmed = line.trimmed();
        if (trimmed.isEmpty())
            continue;

        if (trimmed.contains("\"streams\"")) {
            inStream = true;
            inFormat = false;
            continue;
        }
        if (trimmed.contains("\"format\"")) {
            inStream = false;
            inFormat = true;
            continue;
        }

        if (inStream) {
            if (trimmed.contains("\"codec_type\":")) {
                currentCodecType = trimmed.split(':').last().trimmed().remove('"').remove(',');
            }
            if (currentCodecType == "video") {
                if (trimmed.contains("\"width\":")) {
                    info.width = trimmed.split(':').last().trimmed().remove(',').toInt();
                }
                if (trimmed.contains("\"height\":")) {
                    info.height = trimmed.split(':').last().trimmed().remove(',').toInt();
                }
                if (trimmed.contains("\"codec_name\":") && info.videoCodec.isEmpty()) {
                    info.videoCodec = trimmed.split(':').last().trimmed().remove('"').remove(',');
                }
                info.hasVideo = true;
            } else if (currentCodecType == "audio") {
                if (trimmed.contains("\"codec_name\":") && info.audioCodec.isEmpty()) {
                    info.audioCodec = trimmed.split(':').last().trimmed().remove('"').remove(',');
                }
                info.hasAudio = true;
            }
        }

        if (inFormat) {
            if (trimmed.contains("\"duration\":")) {
                QString val = trimmed.split(':').last().trimmed().remove('"').remove(',');
                bool ok;
                info.duration = val.toDouble(&ok);
                if (!ok)
                    info.duration = 0;
            }
        }
    }

    return info;
}
