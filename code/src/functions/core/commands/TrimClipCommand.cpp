#include "TrimClipCommand.h"
#include "../../timeline/TimelineModel.h"
#include "../../timeline/TimelineClipModel.h"

TrimClipCommand::TrimClipCommand(TimelineModel *timeline, int trackIndex, const QString &clipId,
                                 double newSourceIn, double newSourceOut, double newDuration,
                                 QUndoCommand *parent)
    : QUndoCommand(parent), m_timeline(timeline), m_trackIndex(trackIndex), m_clipId(clipId),
      m_newSourceIn(newSourceIn), m_newSourceOut(newSourceOut), m_newDuration(newDuration)
{
    setText(QString("Trim clip on track %1").arg(trackIndex));
}

void TrimClipCommand::undo()
{
    if (!m_dataStored) return;
    m_timeline->trimClip(m_trackIndex, m_clipId, m_oldSourceIn, m_oldSourceOut, m_oldDuration);
}

void TrimClipCommand::redo()
{
    if (!m_dataStored) {
        // Store original trim values
        auto *clipsModel = m_timeline->data(m_timeline->index(m_trackIndex, 0), Qt::UserRole + 6).value<TimelineClipModel*>();
        if (clipsModel) {
            for (const auto &clip : clipsModel->clips()) {
                if (clip.id == m_clipId) {
                    m_oldSourceIn = clip.sourceInFrame;
                    m_oldSourceOut = clip.sourceOutFrame;
                    m_oldDuration = clip.durationFrames;
                    m_dataStored = true;
                    break;
                }
            }
        }
    }
    
    m_timeline->trimClip(m_trackIndex, m_clipId, m_newSourceIn, m_newSourceOut, m_newDuration);
}

