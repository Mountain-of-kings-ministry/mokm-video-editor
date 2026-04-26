#include "MediaBinModel.h"
#include "FFmpegMediaProbe.h"
#include "FFmpegThumbnailer.h"

#include <QUuid>
#include <QFileInfo>
#include <QDebug>

static MediaBinModel *s_instance = nullptr;

MediaBinModel::MediaBinModel(QObject *parent)
    : QAbstractListModel(parent)
{
    s_instance = this;
}

MediaBinModel *MediaBinModel::instance()
{
    return s_instance;
}

int MediaBinModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return m_items.count();
}

QVariant MediaBinModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_items.count())
        return QVariant();

    const MediaBinItem &item = m_items[index.row()];

    switch (role)
    {
    case IdRole:
        return item.id;
    case FilenameRole:
        return item.filename;
    case FilePathRole:
        return item.filePath;
    case DurationRole:
        return item.duration;
    case ResolutionRole:
        return item.resolution;
    case FrameRateRole:
        return item.frameRate;
    case CodecRole:
        return item.codec;
    case PixelFormatRole:
        return item.pixelFormat;
    case BitDepthRole:
        return item.bitDepth;
    case HasProxyRole:
        return item.hasProxy;
    case ProxyPathRole:
        return item.proxyPath;
    case MediaTypeRole:
        return item.mediaType;
    case ThumbnailRole:
        return QVariant::fromValue(item.thumbnail);
    }

    return QVariant();
}

QHash<int, QByteArray> MediaBinModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[FilenameRole] = "filename";
    roles[FilePathRole] = "filePath";
    roles[DurationRole] = "duration";
    roles[ResolutionRole] = "resolution";
    roles[FrameRateRole] = "frameRate";
    roles[CodecRole] = "codec";
    roles[PixelFormatRole] = "pixelFormat";
    roles[BitDepthRole] = "bitDepth";
    roles[HasProxyRole] = "hasProxy";
    roles[ProxyPathRole] = "proxyPath";
    roles[MediaTypeRole] = "mediaType";
    roles[ThumbnailRole] = "thumbnail";
    return roles;
}

QString MediaBinModel::extractFilename(const QString &path) const
{
    QFileInfo info(path);
    return info.fileName();
}

QString MediaBinModel::generateId() const
{
    return QUuid::createUuid().toString(QUuid::WithoutBraces);
}

void MediaBinModel::importMedia(const QUrl &fileUrl)
{
    if (fileUrl.isLocalFile())
    {
        importMediaLocal(fileUrl.toLocalFile());
    }
}

void MediaBinModel::importMediaLocal(const QString &filePath)
{
    qDebug() << "Importing media:" << filePath;

    // Probe the file using FFmpeg
    MediaProbeResult probe = FFmpegMediaProbe::probeFile(filePath);

    MediaBinItem item;
    item.id = generateId();
    item.filePath = filePath;
    item.filename = extractFilename(filePath);
    item.duration = probe.duration;
    item.resolution = probe.resolution;
    item.frameRate = probe.frameRate;
    item.codec = probe.codec;
    item.pixelFormat = probe.pixelFormat;
    item.bitDepth = probe.bitDepth;
    item.hasProxy = false;
    item.mediaType = probe.mediaType;

    // Generate thumbnail
    if (probe.hasVideo || probe.mediaType == "Image")
    {
        item.thumbnail = FFmpegThumbnailer::extractThumbnail(filePath, 0.0, 320);
    }

    beginInsertRows(QModelIndex(), m_items.count(), m_items.count());
    m_items.append(item);
    endInsertRows();
}

void MediaBinModel::removeMedia(int index)
{
    if (index < 0 || index >= m_items.count())
        return;

    beginRemoveRows(QModelIndex(), index, index);
    m_items.removeAt(index);
    endRemoveRows();
}

void MediaBinModel::clear()
{
    beginResetModel();
    m_items.clear();
    endResetModel();
}

QVariantList MediaBinModel::getAllMedia() const
{
    QVariantList list;
    for (const auto &item : m_items)
    {
        QVariantMap map;
        map["id"] = item.id;
        map["filename"] = item.filename;
        map["filePath"] = item.filePath;
        map["duration"] = item.duration;
        map["resolution"] = item.resolution;
        map["frameRate"] = item.frameRate;
        map["codec"] = item.codec;
        map["pixelFormat"] = item.pixelFormat;
        map["bitDepth"] = item.bitDepth;
        map["hasProxy"] = item.hasProxy;
        map["proxyPath"] = item.proxyPath;
        map["mediaType"] = item.mediaType;
        list.append(map);
    }
    return list;
}

QVariantMap MediaBinModel::getMediaById(const QString &id) const
{
    for (const auto &item : m_items)
    {
        if (item.id == id)
        {
            QVariantMap map;
            map["id"] = item.id;
            map["filename"] = item.filename;
            map["filePath"] = item.filePath;
            map["duration"] = item.duration;
            map["resolution"] = item.resolution;
            map["frameRate"] = item.frameRate;
            map["codec"] = item.codec;
            map["pixelFormat"] = item.pixelFormat;
            map["bitDepth"] = item.bitDepth;
            map["hasProxy"] = item.hasProxy;
            map["proxyPath"] = item.proxyPath;
            map["mediaType"] = item.mediaType;
            return map;
        }
    }
    return QVariantMap();
}
