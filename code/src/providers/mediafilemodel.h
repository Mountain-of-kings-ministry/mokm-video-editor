#ifndef MEDIAFILEMODEL_H
#define MEDIAFILEMODEL_H

#include <QAbstractListModel>
#include <QFileInfo>
#include <QString>
#include <QUrl>

struct MediaFileEntry {
    QString fileName;
    QString filePath;
    QString fileType;
    QString duration;
    QString fileSize;
    QString resolution;
};

class MediaFileModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QUrl currentDirectory READ currentDirectory NOTIFY currentDirectoryChanged)
    Q_PROPERTY(QStringList supportedVideoExtensions READ supportedVideoExtensions CONSTANT)
    Q_PROPERTY(QStringList supportedAudioExtensions READ supportedAudioExtensions CONSTANT)
    Q_PROPERTY(QStringList supportedImageExtensions READ supportedImageExtensions CONSTANT)
    Q_PROPERTY(QStringList supportedExtensions READ supportedExtensions CONSTANT)

public:
    enum MediaRoles {
        FileNameRole = Qt::UserRole + 1,
        FilePathRole,
        FileTypeRole,
        DurationRole,
        FileSizeRole,
        ResolutionRole
    };

    explicit MediaFileModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    QUrl currentDirectory() const;
    QStringList supportedVideoExtensions() const;
    QStringList supportedAudioExtensions() const;
    QStringList supportedImageExtensions() const;
    QStringList supportedExtensions() const;

public slots:
    void browseDirectory(const QUrl &path);
    void browseDirectories(const QStringList &paths);
    void addFiles(const QStringList &filePaths);
    void goUpDirectory();
    QString getFileNameAt(int index) const;
    QString getFilePathAt(int index) const;
    QString getFileTypeAt(int index) const;
    void setFilterText(const QString &text);
    void setFilterType(const QString &type);

signals:
    void currentDirectoryChanged();

private:
    void applyFilters();
    QString determineFileType(const QString &fileName) const;
    QString formatFileSize(qint64 bytes) const;
    bool isSupportedMedia(const QString &fileName) const;
    void scanDirectory(const QString &dirPath);

    QUrl m_currentDirectory;
    QList<MediaFileEntry> m_allFiles;
    QList<MediaFileEntry> m_filteredFiles;
    QString m_filterText;
    QString m_filterType;
};

#endif
