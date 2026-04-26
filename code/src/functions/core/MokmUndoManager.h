#ifndef MOKM_UNDO_MANAGER_H
#define MOKM_UNDO_MANAGER_H

#include <QObject>
#include <QUndoStack>

class TimelineModel;

class MokmUndoManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool canUndo READ canUndo NOTIFY canUndoChanged)
    Q_PROPERTY(bool canRedo READ canRedo NOTIFY canRedoChanged)
    Q_PROPERTY(QString undoText READ undoText NOTIFY canUndoChanged)
    Q_PROPERTY(QString redoText READ redoText NOTIFY canRedoChanged)

public:
    explicit MokmUndoManager(QObject *parent = nullptr);
    static MokmUndoManager* instance();

    bool canUndo() const;
    bool canRedo() const;
    QString undoText() const;
    QString redoText() const;

    QUndoStack* stack() const { return m_undoStack; }

public slots:
    void undo();
    void redo();
    void clear();
    
    // Editing commands with undo support
    void addClip(int trackIndex, const QString &mediaId, const QString &mediaName, double startFrame, double durationFrames);
    void removeClip(int trackIndex, const QString &clipId);
    void moveClip(int fromTrackIndex, int toTrackIndex, const QString &clipId, double newStartFrame);
    void trimClip(int trackIndex, const QString &clipId, double newSourceIn, double newSourceOut, double newDuration);

signals:
    void canUndoChanged();
    void canRedoChanged();

private:
    QUndoStack *m_undoStack;
};

#endif // MOKM_UNDO_MANAGER_H
