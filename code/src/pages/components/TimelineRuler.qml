import QtQuick
import mokm_video_editor

Rectangle {
    id: ruler

    height: 24
    color: Theme.secondary

    readonly property real pixelsPerFrame: timelinePlayer.zoomLevel / 10.0
    readonly property real pixelsPerSecond: pixelsPerFrame * timelinePlayer.fps

    // Bottom border
    Rectangle {
        width: parent.width
        height: 1
        anchors.bottom: parent.bottom
        color: Theme.border
    }

    // Tick marks
    Repeater {
        model: {
            var count = Math.ceil(ruler.width / ruler.pixelsPerSecond) + 1
            return Math.max(count, 1)
        }

        Item {
            x: index * ruler.pixelsPerSecond
            width: ruler.pixelsPerSecond
            height: ruler.height
            visible: x >= 0 && x < ruler.width

            // Major tick
            Rectangle {
                x: 0
                width: 1
                height: 10
                color: Theme.muted
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 1
            }

            // Time label
            Text {
                x: 4
                y: 2
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
                    x: (index + 1) * ruler.pixelsPerSecond / 5
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

    // Click on ruler to seek
    MouseArea {
        anchors.fill: parent
        onClicked: (mouse) => {
            var frame = Math.round(mouse.x / ruler.pixelsPerFrame)
            timelinePlayer.position = Math.max(0, frame)
        }
    }
}
