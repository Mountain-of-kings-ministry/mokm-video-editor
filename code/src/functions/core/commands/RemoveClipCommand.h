#ifndef REMOVE_CLIP_COMMAND_H
#define REMOVE_CLIP_COMMAND_H

#include <QUndoCommand>
#include <QString>

class TimelineModel;
class TimelineClipModel;

struct ClipData;

class RemoveClipCommand : public QUndoCommand
{
public:
    RemoveClipCommand(TimelineModel *timeline, int trackIndex, const QString &clipId,
                      QUndoCommand *parent = nullptr);

    void undo() override;
    void redo() override;

private:
    TimelineModel *m_timeline;
    int m_trackIndex;
    QString m_clipId;
    
    // Stored for undo
    QString m_mediaId;
    QString m_mediaName;
    double m_startFrame = 0;
    double m_durationFrames = 0;
    double m_sourceInFrame = 0;
    double m_sourceOutFrame = 0;
    QString m_color;
    bool m_dataStored = false;
};

#endif // REMOVE_CLIP_COMMAND_H

