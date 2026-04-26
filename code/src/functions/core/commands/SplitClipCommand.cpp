#include "SplitClipCommand.h"
#include "../../timeline/TimelineModel.h"
#include "../../timeline/TimelineClipModel.h"

SplitClipCommand::SplitClipCommand(int trackIndex, const QString &clipId, double splitFrame, QUndoCommand *parent)
    : QUndoCommand(parent), m_trackIndex(trackIndex), m_clipId(clipId), m_splitFrame(splitFrame), 
      m_originalDuration(0), m_originalSourceOut(0)
{
    setText("Razor (Split Clip)");
    
    // Capture original state
    auto *timeline = TimelineModel::instance();
    auto *clipsModel = timeline->data(timeline->index(m_trackIndex, 0), Qt::UserRole + 7).value<TimelineClipModel*>();
    if (clipsModel) {
        TimelineClip *clip = clipsModel->getClipById(m_clipId);
        if (clip) {
            m_originalDuration = clip->durationFrames;
            m_originalSourceOut = clip->sourceOutFrame;
        }
    }
}

void SplitClipCommand::redo()
{
    auto *timeline = TimelineModel::instance();
    timeline->splitClipAtFrame(m_trackIndex, m_clipId, m_splitFrame);
}

void SplitClipCommand::undo()
{
    // Implementation of merge back
    auto *timeline = TimelineModel::instance();
    auto *clipsModel = timeline->data(timeline->index(m_trackIndex, 0), Qt::UserRole + 7).value<TimelineClipModel*>();
    if (clipsModel) {
        // The split logic in TimelineClipModel inserts the second clip right after the first
        // We find the first clip and its successor
        for (int i = 0; i < clipsModel->rowCount(); ++i) {
            TimelineClip *clip = clipsModel->getClipById(m_clipId);
            if (clip) {
                // Find next clip which is the second part of the split
                // Actually the model might have moved it. 
                // But TimelineClipModel::splitClip inserts at i+1.
                // For simplicity, let's look for a clip starting at m_splitFrame
                for (int j = 0; j < clipsModel->rowCount(); ++j) {
                    QModelIndex idx = clipsModel->index(j, 0);
                    if (clipsModel->data(idx, TimelineClipModel::StartFrameRole).toDouble() == m_splitFrame) {
                        QString secondClipId = clipsModel->data(idx, TimelineClipModel::IdRole).toString();
                        clipsModel->removeClip(secondClipId);
                        break;
                    }
                }
                
                // Restore original clip
                clipsModel->trimClip(m_clipId, clip->sourceInFrame, m_originalSourceOut, m_originalDuration);
                break;
            }
        }
    }
}
