import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import mokm_video_editor

Window {
    id: splash
    width: 640
    height: 480
    visible: true
    title: qsTr("Starting...")

    color: Theme.background
    flags: Qt.FramelessWindowHint

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 16

        Rectangle {
            width: 100
            height: 100
            color: Theme.primary
            radius: 16
            Layout.alignment: Qt.AlignHCenter

            Text {
                anchors.centerIn: parent
                text: "M"
                color: Theme.background
                font.pixelSize: 40
                font.bold: true
            }
        }

        Text {
            text: qsTr("MOKM VIDEO EDITOR")
            color: Theme.foreground
            font.pixelSize: 22
            font.weight: Font.Medium
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: qsTr("Initializing...")
            color: Theme.mutedForeground
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }
    }

    Loader {
        id: mainLoader
        anchors.fill: parent
        visible: false
    }

    Timer {
        interval: 1400
        running: true
        repeat: false
        onTriggered: {
            mainLoader.source = "Main.qml";
            mainLoader.asynchronous = false;
        }
    }

    // hide splash when main Window is ready
    Connections {
        target: mainLoader
        function onStatusChanged() {
            if (mainLoader.status === Loader.Ready && mainLoader.item && mainLoader.item.visible) {
                splash.visible = false;
            }
        }
    }
}
