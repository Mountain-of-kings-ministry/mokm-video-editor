#include "TimelineModel.h"
#include <QUuid>
#include <QVariantList>
#include <QVariantMap>

static TimelineModel* s_instance = nullptr;

TimelineModel::TimelineModel(QObject *parent)
    : QAbstractListModel(parent)
{
    s_instance = this;
    
    // Create default tracks A1 & V1 for a fresh timeline
    addVideoTrack();
    addAudioTrack();
}

TimelineModel* TimelineModel::instance() {
    return s_instance;
}

int TimelineModel::rowCount(const QModelIndex &parent) const {
    if (parent.isValid()) return 0;
    return m_tracks.count();
}

QVariant TimelineModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() >= m_tracks.count())
        return QVariant();

    const TimelineTrack &track = m_tracks[index.row()];
    
    switch (role) {
        case IdRole: return track.id;
        case NameRole: return track.name;
        case IsAudioRole: return track.isAudio;
        case IsMutedRole: return track.isMuted;
        case IsSoloRole: return track.isSolo;
        case HeightRole: return track.height;
    }
    
    return QVariant();
}

QHash<int, QByteArray> TimelineModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[NameRole] = "name";
    roles[IsAudioRole] = "isAudio";
    roles[IsMutedRole] = "isMuted";
    roles[IsSoloRole] = "isSolo";
    roles[HeightRole] = "height";
    return roles;
}

QString TimelineModel::generateId() const {
    return QUuid::createUuid().toString(QUuid::WithoutBraces);
}

void TimelineModel::addVideoTrack() {
    TimelineTrack t;
    t.id = generateId();
    t.isAudio = false;
    
    // Calculate name e.g. "V1"
    int vCount = 1;
    for (const auto& tr : m_tracks) if (!tr.isAudio) vCount++;
    t.name = QString("V%1").arg(vCount);
    
    t.isMuted = false;
    t.isSolo = false;
    t.height = 80;
    
    beginInsertRows(QModelIndex(), m_tracks.count(), m_tracks.count());
    m_tracks.append(t);
    endInsertRows();
}

void TimelineModel::addAudioTrack() {
    TimelineTrack t;
    t.id = generateId();
    t.isAudio = true;
    
    int aCount = 1;
    for (const auto& tr : m_tracks) if (tr.isAudio) aCount++;
    t.name = QString("A%1").arg(aCount);
    
    t.isMuted = false;
    t.isSolo = false;
    t.height = 80;
    
    beginInsertRows(QModelIndex(), m_tracks.count(), m_tracks.count());
    m_tracks.append(t);
    endInsertRows();
}

void TimelineModel::addClipToTrack(int trackIndex, const QString &mediaId, double startFrame) {
    if (trackIndex < 0 || trackIndex >= m_tracks.count()) return;
    
    TimelineClip clip;
    clip.id = generateId();
    clip.mediaId = mediaId;
    clip.trackIndex = trackIndex;
    clip.startFrame = startFrame;
    clip.durationFrames = 100; // Placeholder
    clip.sourceInFrame = 0;
    clip.sourceOutFrame = 100; // Placeholder
    
    m_tracks[trackIndex].clips.append(clip);
    
    // We notify data change so UI can redraw
    QModelIndex idx = index(trackIndex, 0);
    emit dataChanged(idx, idx);
}

void TimelineModel::clear() {
    beginResetModel();
    m_tracks.clear();
    endResetModel();
}
