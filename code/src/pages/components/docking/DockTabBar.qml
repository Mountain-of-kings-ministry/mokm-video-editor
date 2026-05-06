import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import mokm_video_editor

Rectangle {
    id: root
    height: 26
    color: Theme.secondary

    property var panels: []
    property int activeIndex: -1
    property alias contentArea: tabBarContentArea

    signal tabClosed(int index)
    signal tabClicked(int index)
    signal tabDragged(int index, point dragStart)

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 2
        anchors.rightMargin: 2
        spacing: 1

        Repeater {
            model: root.panels

            Rectangle {
                id: tab
                Layout.preferredWidth: tabText.width + 28
                Layout.preferredHeight: parent.height - 2
                radius: 3
                color: {
                    if (root.activeIndex === index) return Theme.background
                    if (tabMouse.containsMouse) return Theme.secondaryHover
                    return "transparent"
                }
                border.width: root.activeIndex === index ? 1 : 0
                border.color: Theme.border

                Image {
                    id: tabIcon
                    anchors.left: parent.left
                    anchors.leftMargin: 4
                    anchors.verticalCenter: parent.verticalCenter
                    source: root.panelIconsForType(modelData)
                    width: 12
                    height: 12
                    sourceSize: Qt.size(12, 12)
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        colorization: 1.0
                        colorizationColor: Theme.foreground
                        brightness: root.activeIndex === index ? 0.9 : 0.5
                    }
                }

                Text {
                    id: tabText
                    anchors.left: tabIcon.right
                    anchors.leftMargin: 4
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.panelNamesForType(modelData)
                    color: root.activeIndex === index ? Theme.foreground : Theme.mutedForeground
                    font.pixelSize: 10
                    font.weight: Font.Medium
                }

                // Close button
                Rectangle {
                    id: closeBtn
                    anchors.right: parent.right
                    anchors.rightMargin: 2
                    anchors.verticalCenter: parent.verticalCenter
                    width: 16
                    height: 16
                    radius: 8
                    color: closeMouse.containsMouse ? Qt.rgba(0.8, 0.2, 0.2, 0.3) : "transparent"

                    Image {
                        anchors.centerIn: parent
                        source: "qrc:/icons/outline/x.svg"
                        width: 10
                        height: 10
                        sourceSize: Qt.size(10, 10)
                        opacity: 0.5
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            colorization: 1.0
                            colorizationColor: Theme.foreground
                            brightness: 1.0
                        }
                    }

                    MouseArea {
                        id: closeMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.tabClosed(index)
                    }
                }

                MouseArea {
                    id: tabMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton

                    property real startX: 0
                    property real startY: 0
                    property bool dragging: false

                    onPressed: (mouse) => {
                        if (mouse.button === Qt.LeftButton) {
                            startX = mouse.x
                            startY = mouse.y
                            dragging = false
                        }
                    }

                    onPositionChanged: (mouse) => {
                        if (!pressed) return
                        if (!dragging && mouse.button === Qt.LeftButton) {
                            var dx = mouse.x - startX
                            var dy = mouse.y - startY
                            if (Math.sqrt(dx * dx + dy * dy) > 5) {
                                dragging = true
                                root.tabDragged(index, Qt.point(mouse.x, mouse.y))
                            }
                        }
                    }

                    onReleased: (mouse) => {
                        if (mouse.button === Qt.MiddleButton) {
                            root.tabClosed(index)
                        } else if (!dragging && mouse.button === Qt.LeftButton) {
                            root.tabClicked(index)
                        }
                        dragging = false
                    }
                }
            }
        }

        Item { Layout.fillWidth: true }
    }

    Item {
        id: tabBarContentArea
        width: 0
        height: 0
        visible: false
    }

    function panelNamesForType(type) {
        var names = ["Preview", "Media Bin", "Properties", "Node Editor", "Timeline"]
        if (type >= 0 && type < names.length) return names[type]
        return "Panel"
    }

    function panelIconsForType(type) {
        var icons = [
            "qrc:/icons/outline/player-play.svg",
            "qrc:/icons/outline/folder.svg",
            "qrc:/icons/outline/adjustments.svg",
            "qrc:/icons/outline/box.svg",
            "qrc:/icons/outline/list.svg"
        ]
        if (type >= 0 && type < icons.length) return icons[type]
        return "qrc:/icons/outline/folder.svg"
    }
}
