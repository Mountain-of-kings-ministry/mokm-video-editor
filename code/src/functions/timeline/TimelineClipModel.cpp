#include "TimelineClipModel.h"
#include <QUuid>
#include <QDebug>

TimelineClipModel::TimelineClipModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

int TimelineClipModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return m_clips.count();
}

QVariant TimelineClipModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_clips.count())
        return QVariant();

    const TimelineClip &clip = m_clips[index.row()];

    switch (role)
    {
    case IdRole:
        return clip.id;
    case MediaIdRole:
        return clip.mediaId;
    case MediaNameRole:
        return clip.mediaName;
    case TrackIndexRole:
        return clip.trackIndex;
    case StartFrameRole:
        return clip.startFrame;
    case DurationFramesRole:
        return clip.durationFrames;
    case SourceInFrameRole:
        return clip.sourceInFrame;
    case SourceOutFrameRole:
        return clip.sourceOutFrame;
    case ColorRole:
        return clip.color;
    }

    return QVariant();
}

QHash<int, QByteArray> TimelineClipModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "clipId";
    roles[MediaIdRole] = "mediaId";
    roles[MediaNameRole] = "mediaName";
    roles[TrackIndexRole] = "trackIndex";
    roles[StartFrameRole] = "startFrame";
    roles[DurationFramesRole] = "durationFrames";
    roles[SourceInFrameRole] = "sourceInFrame";
    roles[SourceOutFrameRole] = "sourceOutFrame";
    roles[ColorRole] = "clipColor";
    return roles;
}

void TimelineClipModel::addClip(const TimelineClip &clip)
{
    beginInsertRows(QModelIndex(), m_clips.count(), m_clips.count());
    m_clips.append(clip);
    endInsertRows();
}

bool TimelineClipModel::removeClip(const QString &clipId)
{
    for (int i = 0; i < m_clips.count(); ++i)
    {
        if (m_clips[i].id == clipId)
        {
            beginRemoveRows(QModelIndex(), i, i);
            m_clips.removeAt(i);
            endRemoveRows();
            return true;
        }
    }
    return false;
}

bool TimelineClipModel::moveClip(const QString &clipId, double newStartFrame, int newTrackIndex)
{
    for (int i = 0; i < m_clips.count(); ++i)
    {
        if (m_clips[i].id == clipId)
        {
            m_clips[i].startFrame = newStartFrame;
            m_clips[i].trackIndex = newTrackIndex;
            emit dataChanged(index(i, 0), index(i, 0), {StartFrameRole, TrackIndexRole});
            return true;
        }
    }
    return false;
}

bool TimelineClipModel::trimClip(const QString &clipId, double newSourceIn, double newSourceOut, double newDuration)
{
    for (int i = 0; i < m_clips.count(); ++i)
    {
        if (m_clips[i].id == clipId)
        {
            m_clips[i].sourceInFrame = newSourceIn;
            m_clips[i].sourceOutFrame = newSourceOut;
            m_clips[i].durationFrames = newDuration;
            emit dataChanged(index(i, 0), index(i, 0), {SourceInFrameRole, SourceOutFrameRole, DurationFramesRole});
            return true;
        }
    }
    return false;
}

bool TimelineClipModel::splitClip(const QString &clipId, double atFrame)
{
    for (int i = 0; i < m_clips.count(); ++i)
    {
        if (m_clips[i].id == clipId)
        {
            TimelineClip &original = m_clips[i];
            double originalEnd = original.startFrame + original.durationFrames;

            if (atFrame <= original.startFrame || atFrame >= originalEnd)
                return false;

            double splitPoint = atFrame - original.startFrame;
            double ratio = splitPoint / original.durationFrames;
            double newSourceSplit = original.sourceInFrame + (original.sourceOutFrame - original.sourceInFrame) * ratio;

            // Adjust original clip
            original.durationFrames = splitPoint;
            original.sourceOutFrame = newSourceSplit;
            emit dataChanged(index(i, 0), index(i, 0), {DurationFramesRole, SourceOutFrameRole});

            // Create second clip
            TimelineClip second = original;
            second.id = generateId();
            second.startFrame = atFrame;
            second.durationFrames = originalEnd - atFrame;
            second.sourceInFrame = newSourceSplit;

            beginInsertRows(QModelIndex(), i + 1, i + 1);
            m_clips.insert(i + 1, second);
            endInsertRows();

            return true;
        }
    }
    return false;
}

void TimelineClipModel::clear()
{
    beginResetModel();
    m_clips.clear();
    endResetModel();
}

QString TimelineClipModel::generateId() const
{
    return QUuid::createUuid().toString(QUuid::WithoutBraces);
}

TimelineClip* TimelineClipModel::getClipById(const QString &clipId)
{
    for (int i = 0; i < m_clips.count(); ++i)
    {
        if (m_clips[i].id == clipId)
        {
            return &m_clips[i];
        }
    }
    return nullptr;
}
