#ifndef TIMELINEPLAYER_H
#define TIMELINEPLAYER_H

#include <QObject>
#include <QTimer>

class TimelinePlayer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isPlaying READ isPlaying NOTIFY stateChanged)
    Q_PROPERTY(int position READ position WRITE setPosition NOTIFY positionChanged)
    Q_PROPERTY(int duration READ duration NOTIFY durationChanged)
    Q_PROPERTY(double fps READ fps WRITE setFps NOTIFY fpsChanged)
    Q_PROPERTY(QString timecode READ timecode NOTIFY positionChanged)
    Q_PROPERTY(int zoomLevel READ zoomLevel WRITE setZoomLevel NOTIFY zoomLevelChanged)

public:
    explicit TimelinePlayer(QObject *parent = nullptr);

    bool isPlaying() const;
    int position() const;
    void setPosition(int pos);
    int duration() const;
    double fps() const;
    void setFps(double fps);
    QString timecode() const;
    int zoomLevel() const;
    void setZoomLevel(int zoom);

public slots:
    void play();
    void pause();
    void stop();
    void togglePlayPause();
    void stepForward();
    void stepBackward();
    void skipToStart();
    void skipToEnd();
    void setDuration(int frames);

signals:
    void stateChanged();
    void positionChanged();
    void durationChanged();
    void fpsChanged();
    void zoomLevelChanged();

private slots:
    void onTick();

private:
    QString formatTimecode(int frames) const;

    bool m_isPlaying;
    int m_position;
    int m_duration;
    double m_fps;
    int m_zoomLevel;
    QTimer m_playbackTimer;
};

#endif
