import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import mokm_video_editor

Rectangle {
    id: root
    color: Theme.background
    border.width: 1
    border.color: Theme.border
    radius: 4

    property int panelType: DockManager.preview
    property bool isFloating: false
    property var contentItem: null

    readonly property var panelNames: ["Preview", "Media Bin", "Properties", "Node Editor", "Timeline"]
    readonly property var panelIcons: [
        "qrc:/icons/outline/player-play.svg",
        "qrc:/icons/outline/folder.svg",
        "qrc:/icons/outline/adjustments.svg",
        "qrc:/icons/outline/box.svg",
        "qrc:/icons/outline/list.svg"
    ]

    signal closeRequested(var panel)
    signal floatRequested(var panel)
    signal splitRequested(var panel, string direction)
    signal typeChanged(var panel, int newType)

    // Header bar
    Rectangle {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 26
        color: Theme.secondary

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 4
            spacing: 4

            // Panel type indicator/icon
            MouseArea {
                id: typeButton
                Layout.preferredWidth: typeIcon.width + 8
                Layout.preferredHeight: 20
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                Rectangle {
                    anchors.fill: parent
                    radius: 3
                    color: typeButton.containsMouse ? Theme.secondaryHover : "transparent"
                }

                Image {
                    id: typeIcon
                    anchors.left: parent.left
                    anchors.leftMargin: 4
                    anchors.verticalCenter: parent.verticalCenter
                    source: root.panelIcons[root.panelType]
                    width: 14
                    height: 14
                    sourceSize: Qt.size(14, 14)
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        colorization: 1.0
                        colorizationColor: Theme.foreground
                        brightness: 0.7
                    }
                }

                Text {
                    anchors.left: typeIcon.right
                    anchors.leftMargin: 4
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.panelNames[root.panelType]
                    color: Theme.foreground
                    font.pixelSize: 10
                    font.weight: Font.Medium
                    opacity: 0.7
                }

                onClicked: typeMenu.open()

                Menu {
                    id: typeMenu
                    width: 160

                    Repeater {
                        model: root.panelNames

                        MenuItem {
                            text: root.panelNames[index]
                            onTriggered: {
                                root.typeChanged(root, index)
                                root.panelType = index
                            }
                        }
                    }
                }
            }

            Item { Layout.fillWidth: true }

            // Float button
            Rectangle {
                width: 20
                height: 20
                radius: 3
                color: "transparent"
                visible: !root.isFloating

                Image {
                    anchors.centerIn: parent
                    source: "qrc:/icons/outline/arrows-move.svg"
                    width: 12
                    height: 12
                    sourceSize: Qt.size(12, 12)
                    opacity: 0.4
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        colorization: 1.0
                        colorizationColor: Theme.foreground
                        brightness: 1.0
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.floatRequested(root)
                    onEntered: parent.color = Theme.secondaryHover
                    onExited: parent.color = "transparent"
                }

                ToolTip.visible: false
                ToolTip.text: "Float window"
            }

            // Close button
            Rectangle {
                width: 20
                height: 20
                radius: 3
                color: "transparent"

                Image {
                    anchors.centerIn: parent
                    source: "qrc:/icons/outline/x.svg"
                    width: 12
                    height: 12
                    sourceSize: Qt.size(12, 12)
                    opacity: 0.4
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        colorization: 1.0
                        colorizationColor: Theme.foreground
                        brightness: 1.0
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.closeRequested(root)
                    onEntered: parent.color = Qt.rgba(0.8, 0.2, 0.2, 0.3)
                    onExited: parent.color = "transparent"
                }

                ToolTip.visible: false
                ToolTip.text: "Close panel"
            }
        }
    }

    // Content area
    Item {
        id: contentArea
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        clip: true
    }

    // Corner drag handle for splitting
    MouseArea {
        id: cornerHandle
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: 16
        height: 16
        hoverEnabled: true
        cursorShape: cornerHandle.containsMouse ? Qt.SizeFDiagCursor : Qt.ArrowCursor
        visible: !root.isFloating

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            width: 8
            height: 8
            radius: 1
            color: cornerHandle.containsMouse ? Theme.primary : "transparent"
            opacity: 0.5
        }

        onClicked: root.splitRequested(root, "right")
    }
}
