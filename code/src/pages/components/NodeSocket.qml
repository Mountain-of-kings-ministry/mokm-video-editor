import QtQuick
import mokm_video_editor

Rectangle {
    id: socket

    property bool isOutput: false
    property color socketColor: Theme.accent
    property bool isConnected: false

    width: 12
    height: 12
    radius: 6
    color: socket.isConnected ? socket.socketColor : "transparent"
    border.width: 2
    border.color: socket.socketColor

    MouseArea {
        anchors.fill: parent
        anchors.margins: -4
        hoverEnabled: true
        cursorShape: Qt.CrossCursor

        onEntered: socket.scale = 1.3
        onExited: socket.scale = 1.0
    }

    Behavior on scale { NumberAnimation { duration: 100 } }
}
