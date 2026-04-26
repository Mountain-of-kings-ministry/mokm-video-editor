#ifndef MEDIA_BIN_MODEL_H
#define MEDIA_BIN_MODEL_H

#include <QAbstractListModel>
#include <QList>
#include <QString>
#include <QUrl>
#include <QImage>
#include <QVariantList>
#include <QVariantMap>

struct MediaBinItem
{
    QString id;
    QString filename;
    QString filePath;
    QString duration;   // "00:00:23:14"
    double durationSeconds = 0;
    QString resolution; // "1920x1080"
    QString frameRate;  // "23.976 fps"
    QString codec;
    QString pixelFormat;
    int bitDepth = 8;
    bool hasProxy;
    QString proxyPath;
    QString mediaType; // "Video", "Audio", "Image", "Folder"
    QImage thumbnail;
    QString parentId;  // For folder structure
    bool isFolder = false;
    bool isExpanded = true;
};

class MediaBinModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum MediaBinRoles
    {
        IdRole = Qt::UserRole + 1,
        FilenameRole,
        FilePathRole,
        DurationRole,
        ResolutionRole,
        FrameRateRole,
        CodecRole,
        PixelFormatRole,
        BitDepthRole,
        HasProxyRole,
        ProxyPathRole,
        MediaTypeRole,
        ThumbnailRole,
        DurationSecondsRole,
        ParentIdRole,
        IsFolderRole,
        IsExpandedRole
    };

    Q_PROPERTY(QString searchText READ searchText WRITE setSearchText NOTIFY searchTextChanged)
    Q_PROPERTY(QString currentParentId READ currentParentId WRITE setCurrentParentId NOTIFY currentParentIdChanged)
    Q_PROPERTY(QString typeFilter READ typeFilter WRITE setTypeFilter NOTIFY typeFilterChanged)
    Q_PROPERTY(QStringList linkedFolders READ linkedFolders NOTIFY linkedFoldersChanged)

    explicit MediaBinModel(QObject *parent = nullptr);
    static MediaBinModel *instance();

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    QString searchText() const { return m_searchText; }
    void setSearchText(const QString &text);

    QString currentParentId() const { return m_currentParentId; }
    void setCurrentParentId(const QString &id);

public slots:
    void importMedia(const QUrl &fileUrl);
    void importMediaLocal(const QString &filePath);
    void importFolder(const QString &path);
    void createFolder(const QString &name, const QString &parentId = "");
    void removeMedia(int index);
    void clear();

    Q_INVOKABLE QVariantList getAllMedia() const;
    Q_INVOKABLE QVariantMap getMediaById(const QString &id) const;
    Q_INVOKABLE QImage getThumbnail(const QString &id) const;

    QString typeFilter() const { return m_typeFilter; }
    void setTypeFilter(const QString &filter);

    QStringList linkedFolders() const { return m_linkedFolders; }
    Q_INVOKABLE void addLinkedFolder(const QString &path);
    Q_INVOKABLE void removeLinkedFolder(const QString &path);

signals:
    void searchTextChanged();
    void currentParentIdChanged();
    void typeFilterChanged();
    void linkedFoldersChanged();

private:
    QList<MediaBinItem> m_items;
    QList<MediaBinItem> m_visibleItems;
    QString m_searchText;
    QString m_currentParentId;
    QString m_typeFilter; // "All", "Video", "Audio", "Image"
    QStringList m_linkedFolders;

    void updateVisibleItems();
    QString generateId() const;
    QString extractFilename(const QString &path) const;
};

#endif // MEDIA_BIN_MODEL_H
