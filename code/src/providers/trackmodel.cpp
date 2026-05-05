#include "trackmodel.h"
#include <QColor>

TrackModel::TrackModel(QObject *parent)
    : QAbstractListModel{parent},
      m_videoTrackCount(0),
      m_audioTrackCount(0)
{
    addVideoTrack();
    addVideoTrack();
    addAudioTrack();
    addAudioTrack();
}

int TrackModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return m_tracks.size();
}

QVariant TrackModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_tracks.size())
        return QVariant();

    const TrackEntry &track = m_tracks.at(index.row());

    switch (role) {
    case TrackNameRole:
        return track.trackName;
    case TrackTypeRole:
        return track.trackType;
    case TrackColorRole:
        return track.trackColor;
    case TrackLockedRole:
        return track.locked;
    case TrackVisibleRole:
        return track.visible;
    case TrackMediaCountRole:
        return track.mediaFiles.size();
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> TrackModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TrackNameRole] = "trackName";
    roles[TrackTypeRole] = "trackType";
    roles[TrackColorRole] = "trackColor";
    roles[TrackLockedRole] = "trackLocked";
    roles[TrackVisibleRole] = "trackVisible";
    roles[TrackMediaCountRole] = "trackMediaCount";
    return roles;
}

int TrackModel::trackCount() const
{
    return m_tracks.size();
}

void TrackModel::addTrack(const QString &name, const QString &type)
{
    beginInsertRows(QModelIndex(), m_tracks.size(), m_tracks.size());
    TrackEntry entry;
    entry.trackName = name;
    entry.trackType = type;
    entry.trackColor = defaultTrackColor(type, m_tracks.size()).name();
    entry.locked = false;
    entry.visible = true;
    m_tracks.append(entry);
    endInsertRows();
    emit trackCountChanged();
    emit trackAdded(name, type);
}

void TrackModel::addVideoTrack()
{
    m_videoTrackCount++;
    addTrack(autoGenerateTrackName("video"), "video");
}

void TrackModel::addAudioTrack()
{
    m_audioTrackCount++;
    addTrack(autoGenerateTrackName("audio"), "audio");
}

void TrackModel::removeTrack(int index)
{
    if (index < 0 || index >= m_tracks.size())
        return;

    beginRemoveRows(QModelIndex(), index, index);
    m_tracks.removeAt(index);
    endRemoveRows();
    emit trackCountChanged();
}

void TrackModel::toggleLock(int index)
{
    if (index < 0 || index >= m_tracks.size())
        return;

    m_tracks[index].locked = !m_tracks[index].locked;
    QModelIndex modelIndex = this->index(index);
    emit dataChanged(modelIndex, modelIndex, {TrackLockedRole});
}

void TrackModel::toggleVisible(int index)
{
    if (index < 0 || index >= m_tracks.size())
        return;

    m_tracks[index].visible = !m_tracks[index].visible;
    QModelIndex modelIndex = this->index(index);
    emit dataChanged(modelIndex, modelIndex, {TrackVisibleRole});
}

void TrackModel::importMediaToTrack(const QString &filePath, int trackIndex)
{
    if (trackIndex < 0 || trackIndex >= m_tracks.size())
        return;

    m_tracks[trackIndex].mediaFiles.append(filePath);
    QModelIndex modelIndex = this->index(trackIndex);
    emit dataChanged(modelIndex, modelIndex, {TrackMediaCountRole});
    emit mediaImportedToTrack(filePath, m_tracks[trackIndex].trackName);
}

QString TrackModel::getTrackNameAt(int index) const
{
    if (index >= 0 && index < m_tracks.size())
        return m_tracks.at(index).trackName;
    return QString();
}

QString TrackModel::getTrackTypeAt(int index) const
{
    if (index >= 0 && index < m_tracks.size())
        return m_tracks.at(index).trackType;
    return QString();
}

void TrackModel::clearTracks()
{
    beginResetModel();
    m_tracks.clear();
    m_videoTrackCount = 0;
    m_audioTrackCount = 0;
    endResetModel();
    emit trackCountChanged();
}

QString TrackModel::autoGenerateTrackName(const QString &type) const
{
    if (type == "video")
        return "V" + QString::number(m_videoTrackCount);
    else
        return "A" + QString::number(m_audioTrackCount);
}

QColor TrackModel::defaultTrackColor(const QString &type, int index) const
{
    if (type == "video") {
        static const QStringList videoColors = {"#3b82f6", "#8b5cf6", "#06b6d4", "#f59e0b"};
        return QColor(videoColors[index % videoColors.size()]);
    } else {
        static const QStringList audioColors = {"#22c55e", "#14b8a6", "#ec4899", "#f97316"};
        return QColor(audioColors[index % audioColors.size()]);
    }
}
