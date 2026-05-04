import QtQuick
import QtQuick.Layouts
import mokm_video_editor

Rectangle {
    id: track

    property string trackName: "Track 1"
    property color trackColor: Theme.accent
    property bool isMuted: false
    property bool isSolo: false

    height: 48
    color: "transparent"

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
            anchors.rightMargin: 8
            spacing: 4

            Rectangle {
                width: 4
                height: 20
                radius: 2
                color: track.trackColor
                Layout.alignment: Qt.AlignVCenter
            }

            Text {
                text: track.trackName
                color: track.isMuted ? Theme.muted : Theme.foreground
                font.pixelSize: 11
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                elide: Text.ElideRight
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

        // Example clips (placeholder)
        Rectangle {
            x: 20
            y: 4
            width: 180
            height: parent.height - 8
            radius: 4
            color: Qt.rgba(track.trackColor.r, track.trackColor.g, track.trackColor.b, 0.35)
            border.width: 1
            border.color: Qt.rgba(track.trackColor.r, track.trackColor.g, track.trackColor.b, 0.6)

            Text {
                anchors.centerIn: parent
                text: "Clip 1"
                color: Theme.foreground
                font.pixelSize: 10
                opacity: 0.7
            }
        }

        Rectangle {
            x: 220
            y: 4
            width: 140
            height: parent.height - 8
            radius: 4
            color: Qt.rgba(track.trackColor.r, track.trackColor.g, track.trackColor.b, 0.25)
            border.width: 1
            border.color: Qt.rgba(track.trackColor.r, track.trackColor.g, track.trackColor.b, 0.5)

            Text {
                anchors.centerIn: parent
                text: "Clip 2"
                color: Theme.foreground
                font.pixelSize: 10
                opacity: 0.7
            }
        }
    }
}
