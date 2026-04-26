#include "RemoveClipCommand.h"
#include "../../timeline/TimelineModel.h"
#include "../../timeline/TimelineClipModel.h"

RemoveClipCommand::RemoveClipCommand(TimelineModel *timeline, int trackIndex, const QString &clipId,
                                     QUndoCommand *parent)
    : QUndoCommand(parent), m_timeline(timeline), m_trackIndex(trackIndex), m_clipId(clipId)
{
    setText(QString("Remove clip from track %1").arg(trackIndex));
}

void RemoveClipCommand::undo()
{
    if (!m_dataStored) return;
    m_timeline->addClipToTrack(m_trackIndex, m_mediaId, m_mediaName, m_startFrame, m_durationFrames);
    // TODO: Restore source in/out and color properly - need addClipToTrack to accept full clip data
}

void RemoveClipCommand::redo()
{
    auto *clipsModel = m_timeline->data(m_timeline->index(m_trackIndex, 0), Qt::UserRole + 6).value<TimelineClipModel*>();
    if (!clipsModel) return;
    
    // Store clip data before removing if not already stored
    if (!m_dataStored) {
        for (const auto &clip : clipsModel->clips()) {
            if (clip.id == m_clipId) {
                m_mediaId = clip.mediaId;
                m_mediaName = clip.mediaName;
                m_startFrame = clip.startFrame;
                m_durationFrames = clip.durationFrames;
                m_sourceInFrame = clip.sourceInFrame;
                m_sourceOutFrame = clip.sourceOutFrame;
                m_color = clip.color;
                m_dataStored = true;
                break;
            }
        }
    }
    
    clipsModel->removeClip(m_clipId);
}

