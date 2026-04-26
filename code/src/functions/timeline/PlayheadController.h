#ifndef PLAYHEAD_CONTROLLER_H
#define PLAYHEAD_CONTROLLER_H

#include <QObject>
#include <QTimer>

class PlayheadController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int currentFrame READ currentFrame WRITE setCurrentFrame NOTIFY currentFrameChanged)
    Q_PROPERTY(bool isPlaying READ isPlaying NOTIFY isPlayingChanged)
    Q_PROPERTY(double fps READ fps WRITE setFps NOTIFY fpsChanged)
    Q_PROPERTY(int totalFrames READ totalFrames WRITE setTotalFrames NOTIFY totalFramesChanged)

public:
    explicit PlayheadController(QObject *parent = nullptr);
    static PlayheadController *instance();

    int currentFrame() const;
    bool isPlaying() const;
    double fps() const;
    int totalFrames() const;

public slots:
    void setCurrentFrame(int frame);
    void setFps(double fps);
    void setTotalFrames(int frames);
    void play();
    void pause();
    void togglePlayPause();
    void seekTo(int frame);
    void stepForward(int frames = 1);
    void stepBackward(int frames = 1);
    void goToStart();
    void goToEnd();

signals:
    void currentFrameChanged();
    void isPlayingChanged();
    void fpsChanged();
    void totalFramesChanged();

private slots:
    void onTimerTick();

private:
    static PlayheadController *s_instance;

    int m_currentFrame = 0;
    bool m_isPlaying = false;
    double m_fps = 24.0;
    int m_totalFrames = 0;
    QTimer *m_playbackTimer = nullptr;

    int msPerFrame() const;
};

#endif // PLAYHEAD_CONTROLLER_H

