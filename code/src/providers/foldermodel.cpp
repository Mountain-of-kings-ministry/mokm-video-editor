#include "foldermodel.h"
#include <QDir>
#include <QStandardPaths>

FolderModel::FolderModel(QObject *parent)
    : QAbstractListModel{parent},
      m_superFolderIndex(-1)
{
}

int FolderModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return m_folders.size();
}

QVariant FolderModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_folders.size())
        return QVariant();

    const FolderEntry &entry = m_folders.at(index.row());

    switch (role) {
    case FolderNameRole:
        return entry.folderName;
    case FolderPathRole:
        return entry.folderPath;
    case IsSystemFolderRole:
        return entry.isSystemFolder;
    case IsSuperFolderRole:
        return entry.isSuperFolder;
    case ChildPathsRole:
        return entry.childPaths;
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> FolderModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[FolderNameRole] = "folderName";
    roles[FolderPathRole] = "folderPath";
    roles[IsSystemFolderRole] = "isSystemFolder";
    roles[IsSuperFolderRole] = "isSuperFolder";
    roles[ChildPathsRole] = "childPaths";
    return roles;
}

void FolderModel::addSystemMediaFolders()
{
    QStringList superPaths;
    struct {
        QStandardPaths::StandardLocation location;
        const char *fallbackName;
    } mediaLocations[] = {
        { QStandardPaths::MoviesLocation, "Videos" },
        { QStandardPaths::MusicLocation, "Music" },
        { QStandardPaths::PicturesLocation, "Pictures" }
    };

    beginResetModel();

    for (const auto &loc : mediaLocations) {
        QStringList paths = QStandardPaths::standardLocations(loc.location);
        for (const QString &path : paths) {
            QDir dir(path);
            if (dir.exists() && folderExists(path)) {
                superPaths.append(path);
                FolderEntry entry;
                entry.folderName = loc.fallbackName;
                entry.folderPath = path;
                entry.isSystemFolder = true;
                entry.isSuperFolder = false;
                m_folders.append(entry);
            }
        }
    }

    FolderEntry superEntry;
    superEntry.folderName = "All Media";
    superEntry.folderPath = "";
    superEntry.isSystemFolder = false;
    superEntry.isSuperFolder = true;
    superEntry.childPaths = superPaths;
    m_superFolderIndex = m_folders.size();
    m_folders.prepend(superEntry);

    endResetModel();
}

void FolderModel::addFolder(const QString &path)
{
    if (!folderExists(path))
        return;

    for (const auto &existing : m_folders) {
        if (existing.folderPath == path)
            return;
    }

    beginInsertRows(QModelIndex(), m_folders.size(), m_folders.size());
    FolderEntry entry;
    QDir dir(path);
    entry.folderName = dir.dirName();
    entry.folderPath = path;
    entry.isSystemFolder = false;
    entry.isSuperFolder = false;
    m_folders.append(entry);
    endInsertRows();
}

void FolderModel::removeFolder(int index)
{
    if (index < 0 || index >= m_folders.size())
        return;

    if (m_folders.at(index).isSystemFolder)
        return;

    if (m_folders.at(index).isSuperFolder)
        return;

    beginRemoveRows(QModelIndex(), index, index);
    m_folders.removeAt(index);
    endRemoveRows();
}

QUrl FolderModel::getFolderUrlAt(int index) const
{
    if (index >= 0 && index < m_folders.size())
        return QUrl::fromLocalFile(m_folders.at(index).folderPath);
    return QUrl();
}

QString FolderModel::getFolderPathAt(int index) const
{
    if (index >= 0 && index < m_folders.size())
        return m_folders.at(index).folderPath;
    return QString();
}

QStringList FolderModel::getChildPathsAt(int index) const
{
    if (index >= 0 && index < m_folders.size())
        return m_folders.at(index).childPaths;
    return QStringList();
}

int FolderModel::getSuperFolderIndex() const
{
    return m_superFolderIndex;
}

bool FolderModel::folderExists(const QString &path) const
{
    QDir dir(path);
    return dir.exists();
}
