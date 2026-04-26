#include "TimelineModel.h"
#include <QUuid>
#include <QVariantList>
#include <QVariantMap>

static TimelineModel *s_instance = nullptr;

TimelineModel::TimelineModel(QObject *parent)
    : QAbstractListModel(parent)
{
    s_instance = this;

    // Create default tracks A1 & V1 for a fresh timeline
    addVideoTrack();
    addAudioTrack();
}

TimelineModel::~TimelineModel()
{
    for (auto &track : m_tracks)
    {
        if (track.clipsModel)
        {
            track.clipsModel->deleteLater();
            track.clipsModel = nullptr;
        }
    }
}

TimelineModel *TimelineModel::instance()
{
    return s_instance;
}

int TimelineModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return m_tracks.count();
}

QVariant TimelineModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_tracks.count())
        return QVariant();

    const TimelineTrack &track = m_tracks[index.row()];

    switch (role)
    {
    case IdRole:
        return track.id;
    case NameRole:
        return track.name;
    case IsAudioRole:
        return track.isAudio;
    case IsMutedRole:
        return track.isMuted;
    case IsSoloRole:
        return track.isSolo;
    case HeightRole:
        return track.height;
    case ClipsRole:
        return QVariant::fromValue(track.clipsModel);
    }

    return QVariant();
}

QHash<int, QByteArray> TimelineModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[NameRole] = "name";
    roles[IsAudioRole] = "isAudio";
    roles[IsMutedRole] = "isMuted";
    roles[IsSoloRole] = "isSolo";
    roles[HeightRole] = "height";
    roles[ClipsRole] = "clips";
    return roles;
}

QString TimelineModel::generateId() const
{
    return QUuid::createUuid().toString(QUuid::WithoutBraces);
}

void TimelineModel::addVideoTrack()
{
    TimelineTrack t;
    t.id = generateId();
    t.isAudio = false;

    // Calculate name e.g. "V1"
    int vCount = 1;
    for (const auto &tr : m_tracks)
        if (!tr.isAudio)
            vCount++;
    t.name = QString("V%1").arg(vCount);

    t.isMuted = false;
    t.isSolo = false;
    t.height = 80;
    t.clipsModel = new TimelineClipModel(this);

    beginInsertRows(QModelIndex(), m_tracks.count(), m_tracks.count());
    m_tracks.append(t);
    endInsertRows();
}

void TimelineModel::addAudioTrack()
{
    TimelineTrack t;
    t.id = generateId();
    t.isAudio = true;

    int aCount = 1;
    for (const auto &tr : m_tracks)
        if (tr.isAudio)
            aCount++;
    t.name = QString("A%1").arg(aCount);

    t.isMuted = false;
    t.isSolo = false;
    t.height = 80;
    t.clipsModel = new TimelineClipModel(this);

    beginInsertRows(QModelIndex(), m_tracks.count(), m_tracks.count());
    m_tracks.append(t);
    endInsertRows();
}

void TimelineModel::removeTrack(int trackIndex)
{
    if (trackIndex < 0 || trackIndex >= m_tracks.count())
        return;

    beginRemoveRows(QModelIndex(), trackIndex, trackIndex);
    if (m_tracks[trackIndex].clipsModel)
    {
        m_tracks[trackIndex].clipsModel->deleteLater();
    }
    m_tracks.removeAt(trackIndex);
    endRemoveRows();
}

QString TimelineModel::addClipToTrack(int trackIndex, const QString &mediaId, const QString &mediaName, double startFrame, double durationFrames)
{
    if (trackIndex < 0 || trackIndex >= m_tracks.count())
        return QString();

    TimelineClip clip;
    clip.id = generateId();
    clip.mediaId = mediaId;
    clip.mediaName = mediaName.isEmpty() ? mediaId : mediaName;
    clip.trackIndex = trackIndex;
    clip.startFrame = startFrame;
    clip.durationFrames = durationFrames;
    clip.sourceInFrame = 0;
    clip.sourceOutFrame = durationFrames;
    clip.color = "#4A9B8E"; // Default video clip color

    m_tracks[trackIndex].clipsModel->addClip(clip);
    return clip.id;
}

void TimelineModel::moveClip(int fromTrackIndex, int toTrackIndex, const QString &clipId, double newStartFrame)
{
    if (fromTrackIndex < 0 || fromTrackIndex >= m_tracks.count())
        return;
    if (toTrackIndex < 0 || toTrackIndex >= m_tracks.count())
        return;

    if (fromTrackIndex == toTrackIndex)
    {
        m_tracks[fromTrackIndex].clipsModel->moveClip(clipId, newStartFrame, toTrackIndex);
        return;
    }

    // Find clip in source track
    auto &fromClips = m_tracks[fromTrackIndex].clipsModel->clips();
    for (int i = 0; i < fromClips.count(); ++i)
    {
        if (fromClips[i].id == clipId)
        {
            TimelineClip clip = fromClips[i];
            clip.trackIndex = toTrackIndex;
            clip.startFrame = newStartFrame;

            m_tracks[fromTrackIndex].clipsModel->removeClip(clipId);
            m_tracks[toTrackIndex].clipsModel->addClip(clip);
            return;
        }
    }
}

void TimelineModel::trimClip(int trackIndex, const QString &clipId, double newSourceIn, double newSourceOut, double newDuration)
{
    if (trackIndex < 0 || trackIndex >= m_tracks.count())
        return;
    m_tracks[trackIndex].clipsModel->trimClip(clipId, newSourceIn, newSourceOut, newDuration);
}

void TimelineModel::splitClipAtFrame(int trackIndex, const QString &clipId, double atFrame)
{
    if (trackIndex < 0 || trackIndex >= m_tracks.count())
        return;
    m_tracks[trackIndex].clipsModel->splitClip(clipId, atFrame);
}

void TimelineModel::clear()
{
    beginResetModel();
    for (auto &track : m_tracks)
    {
        if (track.clipsModel)
        {
            track.clipsModel->clear();
        }
    }
    m_tracks.clear();
    endResetModel();
}
