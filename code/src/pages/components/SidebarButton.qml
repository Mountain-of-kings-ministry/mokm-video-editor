// import QtQuick
// import QtQuick.Controls
// import QtQuick.Layouts
// import mokm_video_editor

// Item {
//     id: root

//     property string iconSource: ""
//     property bool isActive: false
//     property string toolTipText: ""

//     signal clicked()

//     width: 48
//     height: 48

//     Rectangle {
//         id: bg
//         anchors.fill: parent
//         color: {
//             if (root.isActive) return Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.12)
//             if (mouseArea.containsMouse) return Theme.secondaryHover
//             return "transparent"
//         }
//         radius: 8

//         // Gold accent bar on the left when active
//         Rectangle {
//             visible: root.isActive
//             width: 3
//             height: 24
//             radius: 2
//             color: Theme.primary
//             anchors.left: parent.left
//             anchors.verticalCenter: parent.verticalCenter
//         }

//         Image {
//             id: icon
//             source: root.iconSource
//             width: 22
//             height: 22
//             anchors.centerIn: parent
//             sourceSize: Qt.size(22, 22)
//             fillMode: Image.PreserveAspectFit
//             opacity: root.isActive ? 1.0 : (mouseArea.containsMouse ? 0.9 : 0.55)
//         }

//         // Color overlay for the icon
//         // We use a ShaderEffect-free approach: tint by layering a colored rect with the icon as mask
//         // For simplicity, use opacity to indicate state (active icons are brighter)

//         MouseArea {
//             id: mouseArea
//             anchors.fill: parent
//             hoverEnabled: true
//             cursorShape: Qt.PointingHandCursor
//             onClicked: root.clicked()
//         }

//         ToolTip {
//             visible: mouseArea.containsMouse && root.toolTipText.length > 0
//             text: root.toolTipText
//             delay: 600
//             font.pixelSize: 12
//             background: Rectangle {
//                 color: Theme.secondary
//                 border.color: Theme.border
//                 radius: 4
//             }
//             contentItem: Text {
//                 text: root.toolTipText
//                 color: Theme.foreground
//                 font.pixelSize: 12
//             }
//         }
//     }

//     Behavior on opacity { NumberAnimation { duration: 150 } }
// }

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
// Import the effects module for color overlay
import QtQuick.Effects // This is the native Qt 6 module
import mokm_video_editor

Item {
    id: root

    property string iconSource: ""
    property bool isActive: false
    property string toolTipText: ""

    signal clicked

    width: 48
    height: 48

    Rectangle {
        id: bg
        anchors.fill: parent
        color: {
            if (root.isActive)
                return Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.12);
            if (mouseArea.containsMouse)
                return Theme.secondaryHover;
            return "transparent";
        }
        radius: 8

        Rectangle {
            visible: root.isActive
            width: 3
            height: 24
            radius: 2
            color: Theme.primary
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }

        Image {
            id: icon
            source: root.iconSource
            width: 22
            height: 22
            anchors.centerIn: parent
            sourceSize: Qt.size(22, 22)
            fillMode: Image.PreserveAspectFit

            // Enable layering and apply the effect directly to the Image
            layer.enabled: true
            layer.effect: MultiEffect {
                colorization: 1.0
                colorizationColor: root.isActive ? Theme.primary : (mouseArea.containsMouse ? Theme.foreground : "#8c8c8c")
                brightness: 1.0
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.clicked()
        }

        ToolTip {
            visible: mouseArea.containsMouse && root.toolTipText.length > 0
            text: root.toolTipText
            delay: 600
            font.pixelSize: 12
            background: Rectangle {
                color: Theme.secondary
                border.color: Theme.border
                radius: 4
            }
            contentItem: Text {
                text: root.toolTipText
                color: Theme.foreground
                font.pixelSize: 12
            }
        }
    }
    Behavior on opacity {
        NumberAnimation {
            duration: 150
        }
    }
}
