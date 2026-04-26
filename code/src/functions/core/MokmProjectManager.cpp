#include "MokmProjectManager.h"
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>

static MokmProjectManager* s_instance = nullptr;

MokmProjectManager::MokmProjectManager(QObject *parent)
    : QObject(parent), m_projectName("Untitled Project"), m_projectPath(""), m_isDirty(false)
{
    s_instance = this;
}

MokmProjectManager* MokmProjectManager::instance() {
    return s_instance;
}

QString MokmProjectManager::projectName() const {
    return m_projectName;
}

void MokmProjectManager::setProjectName(const QString &projectName) {
    if (m_projectName == projectName) return;
    m_projectName = projectName;
    emit projectNameChanged();
    markDirty();
}

QString MokmProjectManager::projectPath() const {
    return m_projectPath;
}

bool MokmProjectManager::isDirty() const {
    return m_isDirty;
}

void MokmProjectManager::markDirty() {
    if (!m_isDirty) {
        m_isDirty = true;
        emit isDirtyChanged();
    }
}

bool MokmProjectManager::createNewProject(const QString &name) {
    m_projectName = name;
    m_projectPath = "";
    m_isDirty = false;
    emit projectNameChanged();
    emit projectPathChanged();
    emit isDirtyChanged();
    emit projectLoaded();
    return true;
}

bool MokmProjectManager::loadProject(const QString &path) {
    if (readFromJson(path)) {
        m_projectPath = path;
        m_isDirty = false;
        emit projectPathChanged();
        emit isDirtyChanged();
        emit projectLoaded();
        return true;
    }
    return false;
}

bool MokmProjectManager::saveProject() {
    if (m_projectPath.isEmpty()) {
        qWarning() << "No project path set. Use saveProjectAs.";
        return false;
    }
    return writeToJson(m_projectPath);
}

bool MokmProjectManager::saveProjectAs(const QString &path) {
    if (writeToJson(path)) {
        m_projectPath = path;
        m_isDirty = false;
        emit projectPathChanged();
        emit isDirtyChanged();
        return true;
    }
    return false;
}

bool MokmProjectManager::writeToJson(const QString &path) {
    QJsonObject rootObject;
    rootObject["projectName"] = m_projectName;
    rootObject["version"] = "1.0";
    
    // TODO: Serialize MediaBinModel and TimelineModel here
    
    QJsonDocument doc(rootObject);
    QFile file(path);
    if (!file.open(QIODevice::WriteOnly)) {
        qWarning() << "Could not open file for writing:" << path;
        return false;
    }
    
    file.write(doc.toJson());
    file.close();
    
    m_isDirty = false;
    emit isDirtyChanged();
    return true;
}

bool MokmProjectManager::readFromJson(const QString &path) {
    QFile file(path);
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Could not open file for reading:" << path;
        return false;
    }
    
    QByteArray data = file.readAll();
    file.close();
    
    QJsonParseError parseError;
    QJsonDocument doc = QJsonDocument::fromJson(data, &parseError);
    if (parseError.error != QJsonParseError::NoError) {
        qWarning() << "JSON parse error:" << parseError.errorString();
        return false;
    }
    
    if (!doc.isObject()) return false;
    
    QJsonObject rootObject = doc.object();
    m_projectName = rootObject["projectName"].toString("Untitled Project");
    emit projectNameChanged();
    
    // TODO: Deserialize MediaBinModel and TimelineModel here
    
    return true;
}
