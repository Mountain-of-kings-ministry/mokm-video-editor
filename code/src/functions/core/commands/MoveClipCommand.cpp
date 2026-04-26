#include "MoveClipCommand.h"
#include "../../timeline/TimelineModel.h"
#include "../../timeline/TimelineClipModel.h"

MoveClipCommand::MoveClipCommand(TimelineModel *timeline, int fromTrackIndex, int toTrackIndex,
                                 const QString &clipId, double newStartFrame,
                                 QUndoCommand *parent)
    : QUndoCommand(parent), m_timeline(timeline), m_fromTrackIndex(fromTrackIndex),
      m_toTrackIndex(toTrackIndex), m_clipId(clipId), m_newStartFrame(newStartFrame)
{
    setText(QString("Move clip to track %1").arg(toTrackIndex));
}

void MoveClipCommand::undo()
{
    if (!m_dataStored)
        return;

    if (m_oldTrackIndex != m_toTrackIndex)
    {
        // Need to move back to old track - find clip in new track and move it
        auto *toClipsModel = m_timeline->data(m_timeline->index(m_toTrackIndex, 0), Qt::UserRole + 6).value<TimelineClipModel *>();
        if (!toClipsModel)
            return;

        // Find the clip (it may have been assigned a new ID if moved between tracks)
        // For simplicity, we search by mediaId and startFrame
        for (const auto &clip : toClipsModel->clips())
        {
            if (clip.startFrame == m_newStartFrame && clip.trackIndex == m_toTrackIndex)
            {
                m_clipId = clip.id; // Update ID
                break;
            }
        }

        m_timeline->moveClip(m_toTrackIndex, m_oldTrackIndex, m_clipId, m_oldStartFrame);
    }
    else
    {
        m_timeline->moveClip(m_toTrackIndex, m_oldTrackIndex, m_clipId, m_oldStartFrame);
    }
}

void MoveClipCommand::redo()
{
    if (!m_dataStored)
    {
        // Store original position
        auto *fromClipsModel = m_timeline->data(m_timeline->index(m_fromTrackIndex, 0), Qt::UserRole + 6).value<TimelineClipModel *>();
        if (fromClipsModel)
        {
            for (const auto &clip : fromClipsModel->clips())
            {
                if (clip.id == m_clipId)
                {
                    m_oldStartFrame = clip.startFrame;
                    m_oldTrackIndex = clip.trackIndex;
                    m_dataStored = true;
                    break;
                }
            }
        }
    }

    m_timeline->moveClip(m_fromTrackIndex, m_toTrackIndex, m_clipId, m_newStartFrame);
}
