#include "MediaBinModel.h"
#include "FFmpegMediaProbe.h"
#include "FFmpegThumbnailer.h"

#include <QUuid>
#include <QFileInfo>
#include <QDebug>
#include <QDir>
#include <QDirIterator>

static MediaBinModel *s_instance = nullptr;

MediaBinModel::MediaBinModel(QObject *parent)
    : QAbstractListModel(parent), m_searchText(""), m_currentParentId(""), m_typeFilter("All")
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
    return m_visibleItems.count();
}

QVariant MediaBinModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_visibleItems.count())
        return QVariant();

    const MediaBinItem &item = m_visibleItems[index.row()];

    switch (role)
    {
    case IdRole: return item.id;
    case FilenameRole: return item.filename;
    case FilePathRole: return item.filePath;
    case DurationRole: return item.duration;
    case ResolutionRole: return item.resolution;
    case FrameRateRole: return item.frameRate;
    case CodecRole: return item.codec;
    case PixelFormatRole: return item.pixelFormat;
    case BitDepthRole: return item.bitDepth;
    case HasProxyRole: return item.hasProxy;
    case ProxyPathRole: return item.proxyPath;
    case MediaTypeRole: return item.mediaType;
    case ThumbnailRole: return QVariant::fromValue(item.thumbnail);
    case DurationSecondsRole: return item.durationSeconds;
    case ParentIdRole: return item.parentId;
    case IsFolderRole: return item.isFolder;
    case IsExpandedRole: return item.isExpanded;
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
    roles[DurationSecondsRole] = "durationSeconds";
    roles[ParentIdRole] = "parentId";
    roles[IsFolderRole] = "isFolder";
    roles[IsExpandedRole] = "isExpanded";
    return roles;
}

void MediaBinModel::setSearchText(const QString &text)
{
    if (m_searchText == text) return;
    m_searchText = text;
    updateVisibleItems();
    emit searchTextChanged();
}

void MediaBinModel::setCurrentParentId(const QString &id)
{
    if (m_currentParentId == id) return;
    m_currentParentId = id;
    updateVisibleItems();
    emit currentParentIdChanged();
}

void MediaBinModel::setTypeFilter(const QString &filter)
{
    if (m_typeFilter == filter) return;
    m_typeFilter = filter;
    updateVisibleItems();
    emit typeFilterChanged();
}

void MediaBinModel::addLinkedFolder(const QString &path)
{
    if (path.isEmpty() || m_linkedFolders.contains(path)) return;
    m_linkedFolders.append(path);
    emit linkedFoldersChanged();
}

void MediaBinModel::removeLinkedFolder(const QString &path)
{
    if (m_linkedFolders.removeAll(path) > 0) {
        emit linkedFoldersChanged();
    }
}

void MediaBinModel::updateVisibleItems()
{
    beginResetModel();
    m_visibleItems.clear();
    
    for (const auto &item : m_items) {
        bool matchesSearch = m_searchText.isEmpty() || item.filename.contains(m_searchText, Qt::CaseInsensitive);
        bool matchesParent = item.parentId == m_currentParentId;
        bool matchesType = (m_typeFilter == "All") || (item.mediaType == m_typeFilter) || item.isFolder;
        
        if (!m_searchText.isEmpty()) {
            if (matchesSearch && !item.isFolder && matchesType) {
                m_visibleItems.append(item);
            }
        } else {
            if (matchesParent && matchesType) {
                m_visibleItems.append(item);
            }
        }
    }
    endResetModel();
}

void MediaBinModel::importMedia(const QUrl &fileUrl)
{
    if (fileUrl.isLocalFile()) {
        QString path = fileUrl.toLocalFile();
        QFileInfo info(path);
        if (info.isDir()) {
            importFolder(path);
        } else {
            importMediaLocal(path);
        }
    }
}

void MediaBinModel::importMediaLocal(const QString &filePath)
{
    MediaProbeResult probe = FFmpegMediaProbe::probeFile(filePath);

    MediaBinItem item;
    item.id = generateId();
    item.filePath = filePath;
    item.filename = extractFilename(filePath);
    item.duration = probe.duration;
    item.durationSeconds = probe.durationSeconds;
    item.resolution = probe.resolution;
    item.frameRate = probe.frameRate;
    item.codec = probe.codec;
    item.pixelFormat = probe.pixelFormat;
    item.bitDepth = probe.bitDepth;
    item.hasProxy = false;
    item.mediaType = probe.mediaType;
    item.parentId = m_currentParentId;
    item.isFolder = false;

    if (probe.hasVideo || probe.mediaType == "Image") {
        item.thumbnail = FFmpegThumbnailer::extractThumbnail(filePath, 0.0, 320);
    }

    m_items.append(item);
    updateVisibleItems();
}

void MediaBinModel::importFolder(const QString &path)
{
    QFileInfo info(path);
    if (!info.isDir()) return;
    
    QString folderName = info.fileName();
    QString oldParent = m_currentParentId;
    
    // Create the folder in the bin
    MediaBinItem folder;
    folder.id = generateId();
    folder.filename = folderName;
    folder.isFolder = true;
    folder.mediaType = "Folder";
    folder.parentId = oldParent;
    m_items.append(folder);

    // Recursively import contents
    QString newParentId = folder.id;
    QString savedParentId = m_currentParentId;
    m_currentParentId = newParentId;
    
    QDir dir(path);
    QFileInfoList list = dir.entryInfoList(QDir::Files | QDir::Dirs | QDir::NoDotAndDotDot);
    for (const QFileInfo &fileInfo : list) {
        if (fileInfo.isDir()) {
            importFolder(fileInfo.absoluteFilePath());
        } else {
            importMediaLocal(fileInfo.absoluteFilePath());
        }
    }
    
    m_currentParentId = savedParentId;
    updateVisibleItems();
}

void MediaBinModel::createFolder(const QString &name, const QString &parentId)
{
    MediaBinItem folder;
    folder.id = generateId();
    folder.filename = name;
    folder.isFolder = true;
    folder.mediaType = "Folder";
    folder.parentId = parentId.isEmpty() ? m_currentParentId : parentId;
    
    m_items.append(folder);
    updateVisibleItems();
}

void MediaBinModel::removeMedia(int index)
{
    if (index < 0 || index >= m_visibleItems.count()) return;
    
    QString idToRemove = m_visibleItems[index].id;
    for (int i = 0; i < m_items.count(); ++i) {
        if (m_items[i].id == idToRemove) {
            m_items.removeAt(i);
            break;
        }
    }
    updateVisibleItems();
}

void MediaBinModel::clear()
{
    beginResetModel();
    m_items.clear();
    m_visibleItems.clear();
    m_currentParentId = "";
    endResetModel();
}

QVariantList MediaBinModel::getAllMedia() const
{
    QVariantList list;
    for (const auto &item : m_items) {
        QVariantMap map;
        map["id"] = item.id;
        map["filename"] = item.filename;
        map["filePath"] = item.filePath;
        map["mediaType"] = item.mediaType;
        map["parentId"] = item.parentId;
        map["isFolder"] = item.isFolder;
        list.append(map);
    }
    return list;
}

QVariantMap MediaBinModel::getMediaById(const QString &id) const
{
    for (const auto &item : m_items) {
        if (item.id == id) {
            QVariantMap map;
            map["id"] = item.id;
            map["filename"] = item.filename;
            map["filePath"] = item.filePath;
            map["duration"] = item.duration;
            map["durationSeconds"] = item.durationSeconds;
            map["mediaType"] = item.mediaType;
            map["isFolder"] = item.isFolder;
            map["parentId"] = item.parentId;
            map["resolution"] = item.resolution;
            map["frameRate"] = item.frameRate;
            map["codec"] = item.codec;
            map["bitDepth"] = item.bitDepth;
            map["hasProxy"] = item.hasProxy;
            return map;
        }
    }
    return QVariantMap();
}

QImage MediaBinModel::getThumbnail(const QString &id) const
{
    for (const auto &item : m_items) {
        if (item.id == id) return item.thumbnail;
    }
    return QImage();
}

QString MediaBinModel::extractFilename(const QString &path) const {
    return QFileInfo(path).fileName();
}

QString MediaBinModel::generateId() const {
    return QUuid::createUuid().toString(QUuid::WithoutBraces);
}
