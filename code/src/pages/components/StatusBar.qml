import QtQuick
import QtQuick.Layouts
import mokm_video_editor

Rectangle {
    id: statusBar

    property string projectName: "Untitled Project"
    property string resolution: "1920×1080"
    property string framerate: "24 fps"
    property string timecode: "00:00:00:00"

    height: 28
    color: Theme.secondary

    // Top border
    Rectangle {
        width: parent.width
        height: 1
        anchors.top: parent.top
        color: Theme.border
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 16

        Text {
            text: statusBar.projectName
            color: Theme.mutedForeground
            font.pixelSize: 11
            Layout.alignment: Qt.AlignVCenter
        }

        Item { Layout.fillWidth: true }

        Text {
            text: statusBar.resolution
            color: Theme.muted
            font.pixelSize: 11
            Layout.alignment: Qt.AlignVCenter
        }

        Rectangle { width: 1; height: 12; color: Theme.border; Layout.alignment: Qt.AlignVCenter }

        Text {
            text: statusBar.framerate
            color: Theme.muted
            font.pixelSize: 11
            Layout.alignment: Qt.AlignVCenter
        }

        Rectangle { width: 1; height: 12; color: Theme.border; Layout.alignment: Qt.AlignVCenter }

        Text {
            text: statusBar.timecode
            color: Theme.primary
            font.pixelSize: 11
            font.family: "monospace"
            Layout.alignment: Qt.AlignVCenter
        }
    }
}
