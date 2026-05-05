#ifndef TRACKMODEL_H
#define TRACKMODEL_H

#include <QAbstractListModel>
#include <QColor>
#include <QString>

struct TrackEntry {
    QString trackName;
    QString trackType;
    QString trackColor;
    bool locked;
    bool visible;
    QStringList mediaFiles;
};

class TrackModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int trackCount READ trackCount NOTIFY trackCountChanged)

public:
    enum TrackRoles {
        TrackNameRole = Qt::UserRole + 1,
        TrackTypeRole,
        TrackColorRole,
        TrackLockedRole,
        TrackVisibleRole,
        TrackMediaCountRole
    };

    explicit TrackModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    int trackCount() const;

public slots:
    void addTrack(const QString &name, const QString &type);
    void addVideoTrack();
    void addAudioTrack();
    void removeTrack(int index);
    void toggleLock(int index);
    void toggleVisible(int index);
    void importMediaToTrack(const QString &filePath, int trackIndex);
    QString getTrackNameAt(int index) const;
    QString getTrackTypeAt(int index) const;
    void clearTracks();

signals:
    void trackCountChanged();
    void trackAdded(const QString &name, const QString &type);
    void mediaImportedToTrack(const QString &filePath, const QString &trackName);

private:
    QString autoGenerateTrackName(const QString &type) const;
    QColor defaultTrackColor(const QString &type, int index) const;

    QList<TrackEntry> m_tracks;
    int m_videoTrackCount;
    int m_audioTrackCount;
};

#endif
