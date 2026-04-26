#ifndef MOKM_PROJECT_MANAGER_H
#define MOKM_PROJECT_MANAGER_H

#include <QObject>
#include <QString>
#include <QStringList>
#include <QTimer>

class MokmProjectManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString projectName READ projectName WRITE setProjectName NOTIFY projectNameChanged)
    Q_PROPERTY(QString projectPath READ projectPath NOTIFY projectPathChanged)
    Q_PROPERTY(bool isDirty READ isDirty NOTIFY isDirtyChanged)
    Q_PROPERTY(QStringList recentProjects READ recentProjects NOTIFY recentProjectsChanged)

public:
    explicit MokmProjectManager(QObject *parent = nullptr);
    ~MokmProjectManager();
    static MokmProjectManager* instance();

    QString projectName() const;
    void setProjectName(const QString &projectName);

    QString projectPath() const;
    bool isDirty() const;
    QStringList recentProjects() const;

public slots:
    bool createNewProject(const QString &name);
    bool loadProject(const QString &path);
    bool saveProject();
    bool saveProjectAs(const QString &path);
    void markDirty();
    void autoSave();
    bool checkForAutoSave();
    void clearRecentProjects();

signals:
    void projectNameChanged();
    void projectPathChanged();
    void isDirtyChanged();
    void projectLoaded();
    void recentProjectsChanged();
    void autoSaveRecovered(const QString &path);

private:
    QString m_projectName;
    QString m_projectPath;
    bool m_isDirty;
    QTimer *m_autoSaveTimer = nullptr;
    
    void loadRecentProjects();
    void saveRecentProjects();
    void addToRecentProjects(const QString &path);
    QString autoSavePath() const;
    
    bool writeToJson(const QString &path);
    bool readFromJson(const QString &path);
};

#endif // MOKM_PROJECT_MANAGER_H

