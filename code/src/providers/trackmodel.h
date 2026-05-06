#ifndef TRACKMODEL_H
#define TRACKMODEL_H

#include <QAbstractListModel>
#include <QColor>
#include <QString>

class QMediaPlayer;

struct ClipEntry {
    QString filePath;
    QString fileName;
    QString fileType;
    int startFrame;
    int durationFrames;
};

struct TrackEntry {
    QString trackName;
    QString trackType;
    QString trackColor;
    bool locked;
    bool visible;
    QList<ClipEntry> clips;
};

class TrackModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int trackCount READ trackCount NOTIFY trackCountChanged)
    Q_PROPERTY(int totalDurationFrames READ totalDurationFrames NOTIFY totalDurationFramesChanged)
    Q_PROPERTY(double fps READ fps WRITE setFps NOTIFY fpsChanged)

public:
    enum TrackRoles {
        TrackNameRole = Qt::UserRole + 1,
        TrackTypeRole,
        TrackColorRole,
        TrackLockedRole,
        TrackVisibleRole,
        TrackMediaCountRole,
        TrackTotalDurationRole
    };

    explicit TrackModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    int trackCount() const;
    int totalDurationFrames() const;
    double fps() const;
    void setFps(double fps);

    Q_INVOKABLE QStringList getTrackIndicesByType(const QString &type) const;
    Q_INVOKABLE bool isFileCompatibleWithTrack(const QString &filePath, int trackIndex) const;
    Q_INVOKABLE QString detectFileType(const QString &filePath) const;
    Q_INVOKABLE int getClipCount(int trackIndex) const;
    Q_INVOKABLE QString getClipFilePath(int trackIndex, int clipIndex) const;
    Q_INVOKABLE QString getClipFileName(int trackIndex, int clipIndex) const;
    Q_INVOKABLE QString getClipFileType(int trackIndex, int clipIndex) const;
    Q_INVOKABLE int getClipStartFrame(int trackIndex, int clipIndex) const;
    Q_INVOKABLE int getClipDurationFrames(int trackIndex, int clipIndex) const;
    Q_INVOKABLE int getTrackEndFrame(int trackIndex) const;
    Q_INVOKABLE void importMedia(const QString &filePath, int trackIndex);
    Q_INVOKABLE void importMediaWithDuration(const QString &filePath, int trackIndex, int durationMs);

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
    void setClipDuration(const QString &filePath, int durationFrames);

signals:
    void trackCountChanged();
    void trackAdded(const QString &name, const QString &type);
    void mediaImportedToTrack(const QString &filePath, const QString &trackName);
    void totalDurationFramesChanged();
    void clipsChanged(int trackIndex);
    void fpsChanged();
    void durationProbed(const QString &filePath, int durationFrames);

private slots:
    void onDurationReady(qint64 duration);

private:
    QString autoGenerateTrackName(const QString &type) const;
    QColor defaultTrackColor(const QString &type, int index) const;
    void recalculateTotalDuration();
    int msToFrames(int ms) const;

    QList<TrackEntry> m_tracks;
    int m_videoTrackCount;
    int m_audioTrackCount;
    int m_totalDurationFrames;
    double m_fps;
    QMediaPlayer *m_probePlayer;
    QString m_probeFilePath;
    int m_probeTrackIndex;
};

#endif
