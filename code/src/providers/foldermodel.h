#ifndef FOLDERMODEL_H
#define FOLDERMODEL_H

#include <QAbstractListModel>
#include <QStandardPaths>
#include <QUrl>

struct FolderEntry {
    QString folderName;
    QString folderPath;
    bool isSystemFolder;
    bool isSuperFolder;
    QStringList childPaths;
};

class FolderModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum FolderRoles {
        FolderNameRole = Qt::UserRole + 1,
        FolderPathRole,
        IsSystemFolderRole,
        IsSuperFolderRole,
        ChildPathsRole
    };

    explicit FolderModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

public slots:
    void addSystemMediaFolders();
    void addFolder(const QString &path);
    void removeFolder(int index);
    QUrl getFolderUrlAt(int index) const;
    QString getFolderPathAt(int index) const;
    QStringList getChildPathsAt(int index) const;
    int getSuperFolderIndex() const;

private:
    bool folderExists(const QString &path) const;

    QList<FolderEntry> m_folders;
    int m_superFolderIndex;
};

#endif
