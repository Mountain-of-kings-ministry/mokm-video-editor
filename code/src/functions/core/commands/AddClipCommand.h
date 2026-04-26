#ifndef ADD_CLIP_COMMAND_H
#define ADD_CLIP_COMMAND_H

#include <QUndoCommand>
#include <QString>

class TimelineModel;

class AddClipCommand : public QUndoCommand
{
public:
    AddClipCommand(TimelineModel *timeline, int trackIndex, const QString &mediaId,
                   const QString &mediaName, double startFrame, double durationFrames,
                   QUndoCommand *parent = nullptr);

    void undo() override;
    void redo() override;

private:
    TimelineModel *m_timeline;
    int m_trackIndex;
    QString m_mediaId;
    QString m_mediaName;
    double m_startFrame;
    double m_durationFrames;
    QString m_createdClipId;
    bool m_firstRedo = true;
};

#endif // ADD_CLIP_COMMAND_H
