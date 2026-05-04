import QtQuick
import QtQuick.Layouts
import mokm_video_editor

Rectangle {
    id: header

    property string title: "Panel"
    property color accentColor: Theme.primary

    height: 30
    color: Theme.secondary

    // Bottom border
    Rectangle {
        width: parent.width
        height: 1
        anchors.bottom: parent.bottom
        color: Theme.border
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        spacing: 6

        Rectangle {
            width: 3
            height: 14
            radius: 2
            color: header.accentColor
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            text: header.title
            color: Theme.mutedForeground
            font.pixelSize: 12
            font.weight: Font.Medium
            font.letterSpacing: 0.5
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
        }
    }
}
