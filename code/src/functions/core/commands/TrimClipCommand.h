#ifndef TRIM_CLIP_COMMAND_H
#define TRIM_CLIP_COMMAND_H

#include <QUndoCommand>
#include <QString>

class TimelineModel;

class TrimClipCommand : public QUndoCommand
{
public:
    TrimClipCommand(TimelineModel *timeline, int trackIndex, const QString &clipId,
                    double newSourceIn, double newSourceOut, double newDuration,
                    QUndoCommand *parent = nullptr);

    void undo() override;
    void redo() override;

private:
    TimelineModel *m_timeline;
    int m_trackIndex;
    QString m_clipId;
    double m_newSourceIn;
    double m_newSourceOut;
    double m_newDuration;
    
    // Stored for undo
    double m_oldSourceIn = 0;
    double m_oldSourceOut = 0;
    double m_oldDuration = 0;
    bool m_dataStored = false;
};

#endif // TRIM_CLIP_COMMAND_H

