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
    QString resolution; // "1920x1080"
    QString frameRate;  // "23.976 fps"
    QString codec;
    QString pixelFormat;
    int bitDepth = 8;
    bool hasProxy;
    QString proxyPath;
    QString mediaType; // "Video", "Audio", "Image"
    QImage thumbnail;
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
        ThumbnailRole
    };

    explicit MediaBinModel(QObject *parent = nullptr);
    static MediaBinModel *instance();

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

public slots:
    void importMedia(const QUrl &fileUrl);
    void importMediaLocal(const QString &filePath);
    void removeMedia(int index);
    void clear();

    Q_INVOKABLE QVariantList getAllMedia() const;
    Q_INVOKABLE QVariantMap getMediaById(const QString &id) const;

private:
    QList<MediaBinItem> m_items;

    QString generateId() const;
    QString extractFilename(const QString &path) const;
};

#endif // MEDIA_BIN_MODEL_H
