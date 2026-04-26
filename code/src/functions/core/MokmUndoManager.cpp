#include "MokmUndoManager.h"
#include "commands/AddClipCommand.h"
#include "commands/RemoveClipCommand.h"
#include "commands/MoveClipCommand.h"
#include "commands/TrimClipCommand.h"
#include "../timeline/TimelineModel.h"

static MokmUndoManager* s_instance = nullptr;

MokmUndoManager::MokmUndoManager(QObject *parent)
    : QObject(parent), m_undoStack(new QUndoStack(this)) 
{
    s_instance = this;
    
    connect(m_undoStack, &QUndoStack::canUndoChanged, this, &MokmUndoManager::canUndoChanged);
    connect(m_undoStack, &QUndoStack::canRedoChanged, this, &MokmUndoManager::canRedoChanged);
    connect(m_undoStack, &QUndoStack::undoTextChanged, this, &MokmUndoManager::canUndoChanged);
    connect(m_undoStack, &QUndoStack::redoTextChanged, this, &MokmUndoManager::canRedoChanged);
}

MokmUndoManager* MokmUndoManager::instance() {
    return s_instance;
}

bool MokmUndoManager::canUndo() const {
    return m_undoStack->canUndo();
}

bool MokmUndoManager::canRedo() const {
    return m_undoStack->canRedo();
}

QString MokmUndoManager::undoText() const {
    return m_undoStack->undoText();
}

QString MokmUndoManager::redoText() const {
    return m_undoStack->redoText();
}

void MokmUndoManager::undo() {
    m_undoStack->undo();
}

void MokmUndoManager::redo() {
    m_undoStack->redo();
}

void MokmUndoManager::clear() {
    m_undoStack->clear();
}

void MokmUndoManager::addClip(int trackIndex, const QString &mediaId, const QString &mediaName, double startFrame, double durationFrames)
{
    auto *cmd = new AddClipCommand(TimelineModel::instance(), trackIndex, mediaId, mediaName, startFrame, durationFrames);
    m_undoStack->push(cmd);
}

void MokmUndoManager::removeClip(int trackIndex, const QString &clipId)
{
    auto *cmd = new RemoveClipCommand(TimelineModel::instance(), trackIndex, clipId);
    m_undoStack->push(cmd);
}

void MokmUndoManager::moveClip(int fromTrackIndex, int toTrackIndex, const QString &clipId, double newStartFrame)
{
    auto *cmd = new MoveClipCommand(TimelineModel::instance(), fromTrackIndex, toTrackIndex, clipId, newStartFrame);
    m_undoStack->push(cmd);
}

void MokmUndoManager::trimClip(int trackIndex, const QString &clipId, double newSourceIn, double newSourceOut, double newDuration)
{
    auto *cmd = new TrimClipCommand(TimelineModel::instance(), trackIndex, clipId, newSourceIn, newSourceOut, newDuration);
    m_undoStack->push(cmd);
}

