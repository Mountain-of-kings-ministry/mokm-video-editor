import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import mokm_video_editor

Rectangle {
    id: track

    property string trackName: "Track 1"
    property color trackColor: Theme.accent
    property string trackType: "video"
    property bool trackLocked: false
    property bool trackVisible: true
    property int mediaCount: 0
    property int clipCount: 0
    property int trackIndex: 0
    property bool compatible: true

    height: 48
    color: compatible ? "transparent" : Qt.rgba(0.8, 0.2, 0.2, 0.15)
    border.color: compatible ? "transparent" : Theme.error
    border.width: compatible ? 0 : 1
    opacity: trackVisible ? 1.0 : 0.4

    readonly property real pixelsPerFrame: timelinePlayer.zoomLevel / 10.0
    readonly property real headerWidth: 120

    // Track header (left label area)
    Rectangle {
        id: trackHeader
        width: 120
        height: parent.height
        color: Theme.secondary
        anchors.left: parent.left

        // Right border
        Rectangle {
            width: 1
            height: parent.height
            anchors.right: parent.right
            color: Theme.border
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 4
            spacing: 4

            // Color indicator
            Rectangle {
                width: 4
                height: 20
                radius: 2
                color: track.trackColor
                Layout.alignment: Qt.AlignVCenter
            }

            // Track name
            Text {
                text: track.trackName
                color: track.trackLocked ? Theme.muted : Theme.foreground
                font.pixelSize: 11
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                elide: Text.ElideRight
            }

            // Lock button
            Rectangle {
                width: 20
                height: 20
                radius: 3
                color: track.trackLocked ? Qt.rgba(Theme.warning.r, Theme.warning.g, Theme.warning.b, 0.2) : "transparent"
                Layout.alignment: Qt.AlignVCenter

                Image {
                    anchors.centerIn: parent
                    source: track.trackLocked ? "qrc:/icons/outline/lock.svg" : "qrc:/icons/outline/lock-open.svg"
                    width: 12
                    height: 12
                    sourceSize: Qt.size(12, 12)
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        colorization: 1.0
                        colorizationColor: track.trackLocked ? Theme.warning : Theme.muted
                        brightness: 1.0
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: trackModel.toggleLock(track.trackIndex)
                    onEntered: parent.color = Theme.secondaryHover
                    onExited: parent.color = track.trackLocked ? Qt.rgba(Theme.warning.r, Theme.warning.g, Theme.warning.b, 0.2) : "transparent"
                }
            }

            // Visibility button
            Rectangle {
                width: 20
                height: 20
                radius: 3
                color: !trackVisible ? Qt.rgba(Theme.error.r, Theme.error.g, Theme.error.b, 0.2) : "transparent"
                Layout.alignment: Qt.AlignVCenter

                Image {
                    anchors.centerIn: parent
                    source: trackVisible ? "qrc:/icons/outline/eye.svg" : "qrc:/icons/outline/eye-off.svg"
                    width: 12
                    height: 12
                    sourceSize: Qt.size(12, 12)
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        colorization: 1.0
                        colorizationColor: trackVisible ? Theme.muted : Theme.error
                        brightness: 1.0
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: trackModel.toggleVisible(track.trackIndex)
                    onEntered: parent.color = Theme.secondaryHover
                    onExited: parent.color = !trackVisible ? Qt.rgba(Theme.error.r, Theme.error.g, Theme.error.b, 0.2) : "transparent"
                }
            }
        }
    }

    // Track content area (clips)
    Rectangle {
        anchors.left: trackHeader.right
        anchors.right: parent.right
        height: parent.height
        color: "transparent"

        // Bottom border
        Rectangle {
            width: parent.width
            height: 1
            anchors.bottom: parent.bottom
            color: Theme.border
            opacity: 0.4
        }

        // Media clips display - proportional to duration
        Repeater {
            model: track.clipCount

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
}
