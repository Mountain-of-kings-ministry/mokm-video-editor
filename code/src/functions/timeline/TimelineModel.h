#ifndef TIMELINE_MODEL_H
#define TIMELINE_MODEL_H

#include <QAbstractListModel>
#include <QList>
#include <QString>

struct TimelineClip {
    QString id;
    QString mediaId; // Reference to MediaBinItem
    int trackIndex;
    double startFrame; // Start position on timeline
    double durationFrames; // Length of clip on timeline
    double sourceInFrame; // In-point in source media
    double sourceOutFrame; // Out-point in source media
};

struct TimelineTrack {
    QString id;
    QString name;
    bool isAudio;
    bool isMuted;
    bool isSolo;
    int height;
    QList<TimelineClip> clips;
};

class TimelineModel : public QAbstractListModel {
    Q_OBJECT

public:
    enum TimelineRoles {
        IdRole = Qt::UserRole + 1,
        NameRole,
        IsAudioRole,
        IsMutedRole,
        IsSoloRole,
        HeightRole
        // Clips data requires a nested model or structured QVariantList, standard QVariantList for Phase A.
    };

    explicit TimelineModel(QObject *parent = nullptr);
    static TimelineModel* instance();

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

public slots:
    void addVideoTrack();
    void addAudioTrack();
    void addClipToTrack(int trackIndex, const QString &mediaId, double startFrame);
    void clear();

private:
    QList<TimelineTrack> m_tracks;
    QString generateId() const;
};

#endif // TIMELINE_MODEL_H
