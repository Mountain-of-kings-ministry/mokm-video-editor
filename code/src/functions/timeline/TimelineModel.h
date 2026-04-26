#ifndef TIMELINE_MODEL_H
#define TIMELINE_MODEL_H

#include <QAbstractListModel>
#include <QList>
#include <QString>
#include "TimelineClipModel.h"

struct TimelineTrack
{
    QString id;
    QString name;
    bool isAudio;
    bool isMuted;
    bool isSolo;
    int height;
    TimelineClipModel *clipsModel = nullptr;
};

class TimelineModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum TimelineRoles
    {
        IdRole = Qt::UserRole + 1,
        NameRole,
        IsAudioRole,
        IsMutedRole,
        IsSoloRole,
        HeightRole,
        ClipsRole
    };

    explicit TimelineModel(QObject *parent = nullptr);
    ~TimelineModel();
    static TimelineModel *instance();

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

public slots:
    void addVideoTrack();
    void addAudioTrack();
    void removeTrack(int trackIndex);
    void addClipToTrack(int trackIndex, const QString &mediaId, const QString &mediaName, double startFrame, double durationFrames);
    void moveClip(int fromTrackIndex, int toTrackIndex, const QString &clipId, double newStartFrame);
    void trimClip(int trackIndex, const QString &clipId, double newSourceIn, double newSourceOut, double newDuration);
    void splitClipAtFrame(int trackIndex, const QString &clipId, double atFrame);
    void clear();

private:
    QList<TimelineTrack> m_tracks;
    QString generateId() const;
};

#endif // TIMELINE_MODEL_H
