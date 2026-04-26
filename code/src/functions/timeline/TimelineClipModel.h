#ifndef TIMELINE_CLIP_MODEL_H
#define TIMELINE_CLIP_MODEL_H

#include <QAbstractListModel>
#include <QList>
#include <QString>

struct TimelineClip
{
    QString id;
    QString mediaId;   // Reference to MediaBinItem
    QString mediaName; // Display name
    int trackIndex;
    double startFrame;     // Start position on timeline
    double durationFrames; // Length of clip on timeline
    double sourceInFrame;  // In-point in source media
    double sourceOutFrame; // Out-point in source media
    QString color;         // UI color hint
};

class TimelineClipModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum ClipRoles
    {
        IdRole = Qt::UserRole + 1,
        MediaIdRole,
        MediaNameRole,
        TrackIndexRole,
        StartFrameRole,
        DurationFramesRole,
        SourceInFrameRole,
        SourceOutFrameRole,
        ColorRole
    };

    explicit TimelineClipModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    void addClip(const TimelineClip &clip);
    bool removeClip(const QString &clipId);
    bool moveClip(const QString &clipId, double newStartFrame, int newTrackIndex);
    bool trimClip(const QString &clipId, double newSourceIn, double newSourceOut, double newDuration);
    bool splitClip(const QString &clipId, double atFrame);
    void clear();
    TimelineClip* getClipById(const QString &clipId);

    QList<TimelineClip> &clips() { return m_clips; }
    const QList<TimelineClip> &clips() const { return m_clips; }

private:
    QList<TimelineClip> m_clips;
    QString generateId() const;
};

#endif // TIMELINE_CLIP_MODEL_H
