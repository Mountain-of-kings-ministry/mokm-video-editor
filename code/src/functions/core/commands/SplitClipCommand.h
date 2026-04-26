#ifndef SPLIT_CLIP_COMMAND_H
#define SPLIT_CLIP_COMMAND_H

#include <QUndoCommand>
#include <QString>

class TimelineModel;

class SplitClipCommand : public QUndoCommand {
public:
    SplitClipCommand(int trackIndex, const QString &clipId, double splitFrame, QUndoCommand *parent = nullptr);

    void undo() override;
    void redo() override;

private:
    int m_trackIndex;
    QString m_clipId;
    double m_splitFrame;
    
    // State to restore on undo
    QString m_newClipId;
    double m_originalDuration;
    double m_originalSourceOut;
};

#endif // SPLIT_CLIP_COMMAND_H
