import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import mokm_video_editor

Rectangle {
    id: track

    property string trackType: "video"
    property bool trackLocked: false
    property bool trackVisible: true
    property color trackColor: Theme.accent
    property int trackIndex: 0
    property bool compatible: true

    height: 48
    color: compatible ? "transparent" : Qt.rgba(0.8, 0.2, 0.2, 0.15)
    border.color: compatible ? "transparent" : Theme.error
    border.width: compatible ? 0 : 1
    opacity: trackVisible ? 1.0 : 0.4

    readonly property real pixelsPerFrame: timelinePlayer.zoomLevel / 10.0

    // Bottom border
    Rectangle {
        width: parent.width
        height: 1
        anchors.bottom: parent.bottom
        color: Theme.border
        opacity: 0.4
    }

    // Clip items
    Repeater {
        model: trackModel.getClipCount(track.trackIndex)

        Rectangle {
            x: trackModel.getClipStartFrame(track.trackIndex, index) * track.pixelsPerFrame
            width: Math.max(trackModel.getClipDurationFrames(track.trackIndex, index) * track.pixelsPerFrame, 20)
            height: parent.height - 8
            y: 4
            radius: 4
            color: Qt.rgba(track.trackColor.r, track.trackColor.g, track.trackColor.b, 0.35)
            border.width: 1
            border.color: Qt.rgba(track.trackColor.r, track.trackColor.g, track.trackColor.b, 0.6)

            Row {
                anchors.fill: parent
                anchors.margins: 4
                anchors.leftMargin: 6
                spacing: 4

                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    source: {
                        var ft = trackModel.getClipFileType(track.trackIndex, index)
                        if (ft === "video") return "qrc:/icons/outline/video.svg"
                        if (ft === "audio") return "qrc:/icons/outline/music.svg"
                        return "qrc:/icons/outline/photo.svg"
                    }
                    width: 12
                    height: 12
                    sourceSize: Qt.size(12, 12)
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        colorization: 1.0
                        colorizationColor: Theme.foreground
                        brightness: 1.0
                    }
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: {
                        var name = trackModel.getClipFileName(track.trackIndex, index)
                        if (name.length > 15) name = name.substring(0, 12) + "..."
                        return name || "Clip " + (index + 1)
                    }
                    color: Theme.foreground
                    font.pixelSize: 9
                    opacity: 0.7
                    elide: Text.ElideRight
                }
            }
        }
    }
}
