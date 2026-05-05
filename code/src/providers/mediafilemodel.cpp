#include "mediafilemodel.h"
#include <QDir>
#include <QDirIterator>
#include <QStandardPaths>

MediaFileModel::MediaFileModel(QObject *parent)
    : QAbstractListModel{parent},
      m_filterType("all")
{
    QString homePath = QStandardPaths::writableLocation(QStandardPaths::HomeLocation);
    m_currentDirectory = QUrl::fromLocalFile(homePath);
}

int MediaFileModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return m_filteredFiles.size();
}

QVariant MediaFileModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_filteredFiles.size())
        return QVariant();

    const MediaFileEntry &entry = m_filteredFiles.at(index.row());

    switch (role) {
    case FileNameRole:
        return entry.fileName;
    case FilePathRole:
        return entry.filePath;
    case FileTypeRole:
        return entry.fileType;
    case DurationRole:
        return entry.duration;
    case FileSizeRole:
        return entry.fileSize;
    case ResolutionRole:
        return entry.resolution;
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> MediaFileModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[FileNameRole] = "fileName";
    roles[FilePathRole] = "filePath";
    roles[FileTypeRole] = "fileType";
    roles[DurationRole] = "duration";
    roles[FileSizeRole] = "fileSize";
    roles[ResolutionRole] = "resolution";
    return roles;
}

QUrl MediaFileModel::currentDirectory() const
{
    return m_currentDirectory;
}

QStringList MediaFileModel::supportedVideoExtensions() const
{
    return QStringList() << "mp4" << "avi" << "mkv" << "mov" << "wmv" << "flv" << "webm" << "m4v" << "mpg" << "mpeg";
}

QStringList MediaFileModel::supportedAudioExtensions() const
{
    return QStringList() << "mp3" << "wav" << "aac" << "flac" << "ogg" << "wma" << "m4a" << "aiff";
}

QStringList MediaFileModel::supportedImageExtensions() const
{
    return QStringList() << "png" << "jpg" << "jpeg" << "gif" << "bmp" << "svg" << "webp" << "tiff";
}

QStringList MediaFileModel::supportedExtensions() const
{
    QStringList all;
    all << supportedVideoExtensions() << supportedAudioExtensions() << supportedImageExtensions();
    return all;
}

void MediaFileModel::browseDirectory(const QUrl &path)
{
    QString dirPath = path.toLocalFile();
    QDir dir(dirPath);

    if (!dir.exists())
        return;

    m_currentDirectory = path;
    emit currentDirectoryChanged();

    m_allFiles.clear();
    scanDirectory(dirPath);
    applyFilters();
}

void MediaFileModel::browseDirectories(const QStringList &paths)
{
    if (paths.isEmpty())
        return;

    m_currentDirectory = QUrl::fromLocalFile(paths.first());
    emit currentDirectoryChanged();

    m_allFiles.clear();
    for (const QString &dirPath : paths) {
        if (QDir(dirPath).exists())
            scanDirectory(dirPath);
    }
    applyFilters();
}

void MediaFileModel::addFiles(const QStringList &filePaths)
{
    beginResetModel();
    for (const QString &path : filePaths) {
        QFileInfo fileInfo(path);
        if (fileInfo.exists() && isSupportedMedia(fileInfo.fileName())) {
            MediaFileEntry entry;
            entry.fileName = fileInfo.fileName();
            entry.filePath = fileInfo.absoluteFilePath();
            entry.fileType = determineFileType(fileInfo.fileName());
            entry.fileSize = formatFileSize(fileInfo.size());
            entry.duration = "";
            entry.resolution = "";

            bool exists = false;
            for (const auto &existing : m_allFiles) {
                if (existing.filePath == entry.filePath) {
                    exists = true;
                    break;
                }
            }
            if (!exists)
                m_allFiles.append(entry);
        }
    }
    applyFilters();
}

void MediaFileModel::goUpDirectory()
{
    QDir dir(m_currentDirectory.toLocalFile());
    if (dir.cdUp()) {
        browseDirectory(QUrl::fromLocalFile(dir.absolutePath()));
    }
}

QString MediaFileModel::getFileNameAt(int index) const
{
    if (index >= 0 && index < m_filteredFiles.size())
        return m_filteredFiles.at(index).fileName;
    return QString();
}

QString MediaFileModel::getFilePathAt(int index) const
{
    if (index >= 0 && index < m_filteredFiles.size())
        return m_filteredFiles.at(index).filePath;
    return QString();
}

QString MediaFileModel::getFileTypeAt(int index) const
{
    if (index >= 0 && index < m_filteredFiles.size())
        return m_filteredFiles.at(index).fileType;
    return QString();
}

void MediaFileModel::setFilterText(const QString &text)
{
    m_filterText = text.toLower();
    applyFilters();
}

void MediaFileModel::setFilterType(const QString &type)
{
    m_filterType = type;
    applyFilters();
}

void MediaFileModel::applyFilters()
{
    beginResetModel();
    m_filteredFiles.clear();

    for (const auto &file : m_allFiles) {
        if (m_filterType != "all" && file.fileType != m_filterType)
            continue;

        if (!m_filterText.isEmpty() && !file.fileName.toLower().contains(m_filterText))
            continue;

        m_filteredFiles.append(file);
    }

    std::sort(m_filteredFiles.begin(), m_filteredFiles.end(), [](const MediaFileEntry &a, const MediaFileEntry &b) {
        return a.fileName.toLower() < b.fileName.toLower();
    });

    endResetModel();
}

void MediaFileModel::scanDirectory(const QString &dirPath)
{
    QStringList allExtensions = supportedExtensions();

    for (const QString &ext : allExtensions) {
        QDirIterator it(dirPath, QStringList() << ("*." + ext), QDir::Files, QDirIterator::Subdirectories);
        while (it.hasNext()) {
            it.next();
            QFileInfo fileInfo = it.fileInfo();
            if (isSupportedMedia(fileInfo.fileName())) {
                bool exists = false;
                for (const auto &existing : m_allFiles) {
                    if (existing.filePath == fileInfo.absoluteFilePath()) {
                        exists = true;
                        break;
                    }
                }
                if (!exists) {
                    MediaFileEntry entry;
                    entry.fileName = fileInfo.fileName();
                    entry.filePath = fileInfo.absoluteFilePath();
                    entry.fileType = determineFileType(fileInfo.fileName());
                    entry.fileSize = formatFileSize(fileInfo.size());
                    entry.duration = "";
                    entry.resolution = "";
                    m_allFiles.append(entry);
                }
            }
        }
    }
}

QString MediaFileModel::determineFileType(const QString &fileName) const
{
    QString ext = fileName.section('.', -1).toLower();
    if (supportedVideoExtensions().contains(ext))
        return "video";
    if (supportedAudioExtensions().contains(ext))
        return "audio";
    if (supportedImageExtensions().contains(ext))
        return "image";
    return "unknown";
}

QString MediaFileModel::formatFileSize(qint64 bytes) const
{
    if (bytes < 1024)
        return QString::number(bytes) + " B";
    if (bytes < 1024 * 1024)
        return QString::number(bytes / 1024.0, 'f', 1) + " KB";
    if (bytes < 1024 * 1024 * 1024)
        return QString::number(bytes / (1024.0 * 1024.0), 'f', 1) + " MB";
    return QString::number(bytes / (1024.0 * 1024.0 * 1024.0), 'f', 2) + " GB";
}

bool MediaFileModel::isSupportedMedia(const QString &fileName) const
{
    QString ext = fileName.section('.', -1).toLower();
    return supportedVideoExtensions().contains(ext) ||
           supportedAudioExtensions().contains(ext) ||
           supportedImageExtensions().contains(ext);
}
