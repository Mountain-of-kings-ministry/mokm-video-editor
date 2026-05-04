import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import mokm_video_editor

Rectangle {
    id: sidebar

    property int currentIndex: 0
    signal pageSelected(int index)

    width: 52
    color: Theme.background
    border.width: 0

    // Right border line
    Rectangle {
        width: 1
        height: parent.height
        anchors.right: parent.right
        color: Theme.border
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: 8
        anchors.bottomMargin: 8
        spacing: 2

        // App logo / brand mark at top
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            width: 32
            height: 32
            radius: 8
            color: Theme.primary
            Layout.bottomMargin: 12

            Text {
                anchors.centerIn: parent
                text: "M"
                color: Theme.background
                font.pixelSize: 16
                font.bold: true
            }
        }

        SidebarButton {
            Layout.alignment: Qt.AlignHCenter
            iconSource: "qrc:/icons/outline/folder.svg"
            toolTipText: "Media Bin"
            isActive: sidebar.currentIndex === 0
            onClicked: { sidebar.currentIndex = 0; sidebar.pageSelected(0) }
        }

        SidebarButton {
            Layout.alignment: Qt.AlignHCenter
            iconSource: "qrc:/icons/outline/video.svg"
            toolTipText: "Editor"
            isActive: sidebar.currentIndex === 1
            onClicked: { sidebar.currentIndex = 1; sidebar.pageSelected(1) }
        }

        SidebarButton {
            Layout.alignment: Qt.AlignHCenter
            iconSource: "qrc:/icons/outline/topology-star-3.svg"
            toolTipText: "Node Editor"
            isActive: sidebar.currentIndex === 2
            onClicked: { sidebar.currentIndex = 2; sidebar.pageSelected(2) }
        }

        SidebarButton {
            Layout.alignment: Qt.AlignHCenter
            iconSource: "qrc:/icons/outline/music.svg"
            toolTipText: "Audio"
            isActive: sidebar.currentIndex === 3
            onClicked: { sidebar.currentIndex = 3; sidebar.pageSelected(3) }
        }

        SidebarButton {
            Layout.alignment: Qt.AlignHCenter
            iconSource: "qrc:/icons/outline/layers-subtract.svg"
            toolTipText: "Compositor"
            isActive: sidebar.currentIndex === 4
            onClicked: { sidebar.currentIndex = 4; sidebar.pageSelected(4) }
        }

        SidebarButton {
            Layout.alignment: Qt.AlignHCenter
            iconSource: "qrc:/icons/outline/history.svg"
            toolTipText: "History"
            isActive: sidebar.currentIndex === 5
            onClicked: { sidebar.currentIndex = 5; sidebar.pageSelected(5) }
        }

        SidebarButton {
            Layout.alignment: Qt.AlignHCenter
            iconSource: "qrc:/icons/outline/device-desktop.svg"
            toolTipText: "Renderer"
            isActive: sidebar.currentIndex === 6
            onClicked: { sidebar.currentIndex = 6; sidebar.pageSelected(6) }
        }

        Item { Layout.fillHeight: true } // Spacer

        SidebarButton {
            Layout.alignment: Qt.AlignHCenter
            iconSource: "qrc:/icons/outline/settings.svg"
            toolTipText: "Settings"
            isActive: sidebar.currentIndex === 7
            onClicked: { sidebar.currentIndex = 7; sidebar.pageSelected(7) }
        }
    }
}
