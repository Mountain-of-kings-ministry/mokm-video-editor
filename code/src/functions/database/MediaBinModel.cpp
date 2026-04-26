#include "MediaBinModel.h"
#include <QUuid>
#include <QFileInfo>
#include <QDebug>

static MediaBinModel* s_instance = nullptr;

MediaBinModel::MediaBinModel(QObject *parent)
    : QAbstractListModel(parent)
{
    s_instance = this;
}

MediaBinModel* MediaBinModel::instance() {
    return s_instance;
}

int MediaBinModel::rowCount(const QModelIndex &parent) const {
    if (parent.isValid()) return 0;
    return m_items.count();
}

QVariant MediaBinModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() >= m_items.count())
        return QVariant();

    const MediaBinItem &item = m_items[index.row()];
    
    switch (role) {
        case IdRole: return item.id;
        case FilenameRole: return item.filename;
        case FilePathRole: return item.filePath;
        case DurationRole: return item.duration;
        case ResolutionRole: return item.resolution;
        case FrameRateRole: return item.frameRate;
        case HasProxyRole: return item.hasProxy;
        case MediaTypeRole: return item.mediaType;
    }
    
    return QVariant();
}

QHash<int, QByteArray> MediaBinModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[FilenameRole] = "filename";
    roles[FilePathRole] = "filePath";
    roles[DurationRole] = "duration";
    roles[ResolutionRole] = "resolution";
    roles[FrameRateRole] = "frameRate";
    roles[HasProxyRole] = "hasProxy";
    roles[MediaTypeRole] = "mediaType";
    return roles;
}

QString MediaBinModel::extractFilename(const QString &path) const {
    QFileInfo info(path);
    return info.fileName();
}

QString MediaBinModel::generateId() const {
    return QUuid::createUuid().toString(QUuid::WithoutBraces);
}

void MediaBinModel::importMedia(const QUrl &fileUrl) {
    if (fileUrl.isLocalFile()) {
        importMediaLocal(fileUrl.toLocalFile());
    }
}

void MediaBinModel::importMediaLocal(const QString &filePath) {
    qDebug() << "Importing media:" << filePath;
    
    MediaBinItem item;
    item.id = generateId();
    item.filePath = filePath;
    item.filename = extractFilename(filePath);
    item.hasProxy = false;
    
    // Default placeholders for Phase A. 
    // Phase B will use FFmpegReader here to probe the actual file statistics.
    item.duration = "00:00:00:00";
    item.resolution = "Unknown";
    item.frameRate = "Unknown";
    item.mediaType = "Video";
    
    beginInsertRows(QModelIndex(), m_items.count(), m_items.count());
    m_items.append(item);
    endInsertRows();
}

void MediaBinModel::removeMedia(int index) {
    if (index < 0 || index >= m_items.count()) return;
    
    beginRemoveRows(QModelIndex(), index, index);
    m_items.removeAt(index);
    endRemoveRows();
}

void MediaBinModel::clear() {
    beginResetModel();
    m_items.clear();
    endResetModel();
}
