#include "PlayheadController.h"
#include <QDebug>

PlayheadController *PlayheadController::s_instance = nullptr;

PlayheadController::PlayheadController(QObject *parent)
    : QObject(parent), m_playbackTimer(new QTimer(this))
{
    s_instance = this;
    m_playbackTimer->setTimerType(Qt::PreciseTimer);
    connect(m_playbackTimer, &QTimer::timeout, this, &PlayheadController::onTimerTick);
}

PlayheadController *PlayheadController::instance()
{
    return s_instance;
}

int PlayheadController::currentFrame() const
{
    return m_currentFrame;
}

bool PlayheadController::isPlaying() const
{
    return m_isPlaying;
}

double PlayheadController::fps() const
{
    return m_fps;
}

int PlayheadController::totalFrames() const
{
    return m_totalFrames;
}

void PlayheadController::setCurrentFrame(int frame)
{
    if (m_currentFrame == frame)
        return;

    m_currentFrame = frame;
    emit currentFrameChanged();
}

void PlayheadController::setFps(double fps)
{
    if (qFuzzyCompare(m_fps, fps) || fps <= 0)
        return;

    m_fps = fps;
    emit fpsChanged();

    if (m_isPlaying)
    {
        m_playbackTimer->setInterval(msPerFrame());
    }
}

void PlayheadController::setTotalFrames(int frames)
{
    if (m_totalFrames == frames)
        return;

    m_totalFrames = frames;
    emit totalFramesChanged();
}

void PlayheadController::play()
{
    if (m_isPlaying)
        return;

    m_isPlaying = true;
    m_playbackTimer->start(msPerFrame());
    emit isPlayingChanged();
}

void PlayheadController::pause()
{
    if (!m_isPlaying)
        return;

    m_isPlaying = false;
    m_playbackTimer->stop();
    emit isPlayingChanged();
}

void PlayheadController::togglePlayPause()
{
    if (m_isPlaying)
        pause();
    else
        play();
}

void PlayheadController::seekTo(int frame)
{
    if (m_totalFrames > 0)
        frame = qBound(0, frame, m_totalFrames);
    else
        frame = qMax(0, frame);

    setCurrentFrame(frame);
}

void PlayheadController::stepForward(int frames)
{
    seekTo(m_currentFrame + frames);
}

void PlayheadController::stepBackward(int frames)
{
    seekTo(m_currentFrame - frames);
}

void PlayheadController::goToStart()
{
    seekTo(0);
}

void PlayheadController::goToEnd()
{
    if (m_totalFrames > 0)
        seekTo(m_totalFrames);
}

void PlayheadController::onTimerTick()
{
    if (m_totalFrames > 0 && m_currentFrame >= m_totalFrames)
    {
        pause();
        return;
    }

    setCurrentFrame(m_currentFrame + 1);
}

int PlayheadController::msPerFrame() const
{
    return qMax(1, static_cast<int>(1000.0 / m_fps));
}
