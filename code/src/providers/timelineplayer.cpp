#include "timelineplayer.h"

TimelinePlayer::TimelinePlayer(QObject *parent)
    : QObject{parent},
      m_isPlaying(false),
      m_position(0),
      m_duration(0),
      m_fps(24.0),
      m_zoomLevel(50)
{
    m_playbackTimer.setInterval(1000 / static_cast<int>(m_fps));
    connect(&m_playbackTimer, &QTimer::timeout, this, &TimelinePlayer::onTick);
}

bool TimelinePlayer::isPlaying() const
{
    return m_isPlaying;
}

int TimelinePlayer::position() const
{
    return m_position;
}

void TimelinePlayer::setPosition(int pos)
{
    m_position = qMax(0, qMin(pos, m_duration));
    emit positionChanged();
}

int TimelinePlayer::duration() const
{
    return m_duration;
}

double TimelinePlayer::fps() const
{
    return m_fps;
}

void TimelinePlayer::setFps(double fps)
{
    m_fps = fps > 0 ? fps : 24.0;
    m_playbackTimer.setInterval(1000 / static_cast<int>(m_fps));
    emit fpsChanged();
    emit positionChanged();
}

QString TimelinePlayer::timecode() const
{
    return formatTimecode(m_position);
}

int TimelinePlayer::zoomLevel() const
{
    return m_zoomLevel;
}

void TimelinePlayer::setZoomLevel(int zoom)
{
    m_zoomLevel = qMax(10, qMin(200, zoom));
    emit zoomLevelChanged();
}

void TimelinePlayer::play()
{
    if (!m_isPlaying) {
        m_isPlaying = true;
        m_playbackTimer.start();
        emit stateChanged();
    }
}

void TimelinePlayer::pause()
{
    if (m_isPlaying) {
        m_isPlaying = false;
        m_playbackTimer.stop();
        emit stateChanged();
    }
}

void TimelinePlayer::stop()
{
    m_isPlaying = false;
    m_playbackTimer.stop();
    m_position = 0;
    emit stateChanged();
    emit positionChanged();
}

void TimelinePlayer::togglePlayPause()
{
    if (m_isPlaying)
        pause();
    else
        play();
}

void TimelinePlayer::stepForward()
{
    setPosition(m_position + 1);
}

void TimelinePlayer::stepBackward()
{
    setPosition(m_position - 1);
}

void TimelinePlayer::skipToStart()
{
    setPosition(0);
}

void TimelinePlayer::skipToEnd()
{
    setPosition(m_duration);
}

void TimelinePlayer::setDuration(int frames)
{
    m_duration = qMax(0, frames);
    emit durationChanged();
    emit positionChanged();
}

void TimelinePlayer::onTick()
{
    if (m_position >= m_duration) {
        stop();
        return;
    }
    m_position++;
    emit positionChanged();
}

QString TimelinePlayer::formatTimecode(int frames) const
{
    if (m_fps <= 0) return "00:00:00:00";
    int totalSeconds = static_cast<int>(frames / m_fps);
    int hours = totalSeconds / 3600;
    int minutes = (totalSeconds % 3600) / 60;
    int seconds = totalSeconds % 60;
    int frameNum = frames % static_cast<int>(m_fps);
    return QString("%1:%2:%3:%4")
        .arg(hours, 2, 10, QChar('0'))
        .arg(minutes, 2, 10, QChar('0'))
        .arg(seconds, 2, 10, QChar('0'))
        .arg(frameNum, 2, 10, QChar('0'));
}
