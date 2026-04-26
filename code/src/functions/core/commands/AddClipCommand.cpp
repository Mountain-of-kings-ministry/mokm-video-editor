#include "AddClipCommand.h"
#include "../../timeline/TimelineModel.h"
#include "../../timeline/TimelineClipModel.h"

AddClipCommand::AddClipCommand(TimelineModel *timeline, int trackIndex, const QString &mediaId,
                               const QString &mediaName, double startFrame, double durationFrames,
                               QUndoCommand *parent)
    : QUndoCommand(parent), m_timeline(timeline), m_trackIndex(trackIndex),
      m_mediaId(mediaId), m_mediaName(mediaName), m_startFrame(startFrame), m_durationFrames(durationFrames)
{
    setText(QString("Add clip %1 to track %2").arg(mediaName).arg(trackIndex));
}

void AddClipCommand::undo()
{
    if (m_createdClipId.isEmpty()) return;
    auto *clipsModel = m_timeline->data(m_timeline->index(m_trackIndex, 0), Qt::UserRole + 6).value<TimelineClipModel*>();
    if (clipsModel) clipsModel->removeClip(m_createdClipId);
    m_createdClipId.clear();
}

void AddClipCommand::redo()
{
    m_createdClipId = m_timeline->addClipToTrack(m_trackIndex, m_mediaId, m_mediaName, m_startFrame, m_durationFrames);
}

