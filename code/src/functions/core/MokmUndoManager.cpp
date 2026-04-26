#include "MokmUndoManager.h"

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
