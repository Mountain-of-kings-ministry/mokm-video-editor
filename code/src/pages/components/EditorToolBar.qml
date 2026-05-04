import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import mokm_video_editor

Rectangle {
    id: toolbar

    default property alias content: contentRow.data

    height: 36
    color: Theme.secondary
    radius: 0

    // Bottom border
    Rectangle {
        width: parent.width
        height: 1
        anchors.bottom: parent.bottom
        color: Theme.border
    }

    RowLayout {
        id: contentRow
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        spacing: 4
    }
}
