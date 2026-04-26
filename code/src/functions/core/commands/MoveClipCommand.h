#ifndef MOVE_CLIP_COMMAND_H
#define MOVE_CLIP_COMMAND_H

#include <QUndoCommand>
#include <QString>

class TimelineModel;

class MoveClipCommand : public QUndoCommand
{
public:
    MoveClipCommand(TimelineModel *timeline, int fromTrackIndex, int toTrackIndex,
                    const QString &clipId, double newStartFrame,
                    QUndoCommand *parent = nullptr);

    void undo() override;
    void redo() override;

private:
    TimelineModel *m_timeline;
    int m_fromTrackIndex;
    int m_toTrackIndex;
    QString m_clipId;
    double m_newStartFrame;
    
    // Stored for undo
    double m_oldStartFrame = 0;
    int m_oldTrackIndex = 0;
    bool m_dataStored = false;
};

#endif // MOVE_CLIP_COMMAND_H

