import QtQuick
import mokm_video_editor

Rectangle {
    id: ruler

    height: 24
    color: Theme.secondary

    readonly property real pixelsPerFrame: timelinePlayer.zoomLevel / 10.0
    readonly property real pixelsPerSecond: timelinePlayer.zoomLevel / 10.0 * timelinePlayer.fps
    readonly property real timelineWidth: Math.max(ruler.width, trackModel.totalDurationFrames * pixelsPerFrame + headerWidth)
    readonly property real headerWidth: 120

    // Bottom border
    Rectangle {
        width: parent.width
        height: 1
        anchors.bottom: parent.bottom
        color: Theme.border
    }

    // Playhead indicator
    Rectangle {
        id: playhead
        x: ruler.headerWidth + timelinePlayer.position * ruler.pixelsPerFrame
        width: 2
        height: parent.height
        color: Theme.primary
        z: 10

        Rectangle {
            width: 10
            height: 6
            color: Theme.primary
            radius: 1
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
        }
    }

    Row {
        anchors.fill: parent
        anchors.leftMargin: ruler.headerWidth
        spacing: 0
        clip: true

        Repeater {
            model: {
                var secondsPerTick = 1
                var totalSeconds = Math.ceil(trackModel.totalDurationFrames / timelinePlayer.fps)
                return Math.ceil(ruler.width / (ruler.pixelsPerSecond * secondsPerTick)) + 2
            }

            Item {
                width: ruler.pixelsPerSecond
                height: ruler.height

                // Major tick
                Rectangle {
                    width: 1
                    height: 10
                    color: Theme.muted
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 1
                }

                // Time label
                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 4
                    anchors.top: parent.top
                    anchors.topMargin: 2
                    text: {
                        var sec = index
                        var m = Math.floor(sec / 60)
                        var s = sec % 60
                        return (m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s
                    }
                    color: Theme.mutedForeground
                    font.pixelSize: 9
                }

                // Minor ticks
                Repeater {
                    model: 4
                    Rectangle {
                        x: (modelData + 1) * ruler.pixelsPerSecond / 5
                        width: 1
                        height: 5
                        color: Theme.muted
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 1
                        opacity: 0.5
                    }
                }
            }
        }
    }
}
