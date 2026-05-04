import QtQuick
import mokm_video_editor

Rectangle {
    id: ruler

    property real pixelsPerSecond: 40
    property real durationSeconds: 120
    property real scrollOffset: 0

    height: 24
    color: Theme.secondary

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
        x: 200 - ruler.scrollOffset
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
        anchors.leftMargin: -ruler.scrollOffset % (ruler.pixelsPerSecond * 5)
        spacing: 0
        clip: true

        Repeater {
            model: Math.ceil(ruler.width / (ruler.pixelsPerSecond * 5)) + 2

            Item {
                width: ruler.pixelsPerSecond * 5
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
                        var sec = Math.floor((index * 5) + (ruler.scrollOffset / ruler.pixelsPerSecond))
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
                        x: (modelData + 1) * ruler.pixelsPerSecond
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
