#ifndef MOKM_PROJECT_MANAGER_H
#define MOKM_PROJECT_MANAGER_H

#include <QObject>
#include <QString>

class MokmProjectManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString projectName READ projectName WRITE setProjectName NOTIFY projectNameChanged)
    Q_PROPERTY(QString projectPath READ projectPath NOTIFY projectPathChanged)
    Q_PROPERTY(bool isDirty READ isDirty NOTIFY isDirtyChanged)

public:
    explicit MokmProjectManager(QObject *parent = nullptr);
    static MokmProjectManager* instance();

    QString projectName() const;
    void setProjectName(const QString &projectName);

    QString projectPath() const;
    bool isDirty() const;

public slots:
    bool createNewProject(const QString &name);
    bool loadProject(const QString &path);
    bool saveProject();
    bool saveProjectAs(const QString &path);
    void markDirty();

signals:
    void projectNameChanged();
    void projectPathChanged();
    void isDirtyChanged();
    void projectLoaded();

private:
    QString m_projectName;
    QString m_projectPath;
    bool m_isDirty;
    
    // Internal JSON struct handling
    bool writeToJson(const QString &path);
    bool readFromJson(const QString &path);
};

#endif // MOKM_PROJECT_MANAGER_H
