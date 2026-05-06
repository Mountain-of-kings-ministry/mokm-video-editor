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
    property alias contentArea: contentAreaItem

    signal closeRequested()
    signal floatRequested()
    signal typeChanged()

    readonly property var panelNames: ["Preview", "Media Bin", "Properties", "Node Editor", "Timeline"]
    readonly property var panelIcons: [
        "qrc:/icons/outline/player-play.svg",
        "qrc:/icons/outline/folder.svg",
        "qrc:/icons/outline/adjustments.svg",
        "qrc:/icons/outline/box.svg",
        "qrc:/icons/outline/list.svg"
    ]

    readonly property var panelSources: [
        "qrc:/qt/qml/mokm_video_editor/src/pages/components/panels/PreviewPanel.qml",
        "qrc:/qt/qml/mokm_video_editor/src/pages/components/panels/MiniBin.qml",
        "qrc:/qt/qml/mokm_video_editor/src/pages/components/panels/PropertiesPanel.qml",
        "qrc:/qt/qml/mokm_video_editor/src/pages/components/panels/NodePanel.qml",
        "qrc:/qt/qml/mokm_video_editor/src/pages/components/panels/TimelinePanel.qml"
    ]

    function init() {
        while (contentAreaItem.children.length > 0) {
            contentAreaItem.children[0].destroy()
        }

        var source = panelSources[panelType]
        if (!source) return

        var comp = Qt.createComponent(source)
        if (comp.status === Component.Ready) {
            comp.createObject(contentAreaItem, {
                "anchors.fill": contentAreaItem
            })
        } else {
            console.error("Failed to load panel:", comp.errorString())
        }
    }

    function changeType(newType) {
        panelType = newType
        init()
    }

    // Header bar - anchored to top
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
                    source: root.panelIcons[panelType]
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
                    text: root.panelNames[panelType]
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
                            onTriggered: root.changeType(index)
                        }
                    }
                }
            }

            Item { Layout.fillWidth: true }

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
                    onClicked: root.floatRequested()
                    onEntered: parent.color = Theme.secondaryHover
                    onExited: parent.color = "transparent"
                }

                ToolTip.visible: false
                ToolTip.text: "Float window"
            }

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
                    onClicked: root.closeRequested()
                    onEntered: parent.color = Qt.rgba(0.8, 0.2, 0.2, 0.3)
                    onExited: parent.color = "transparent"
                }

                ToolTip.visible: false
                ToolTip.text: "Close panel"
            }
        }
    }

    // Content area - fills remaining space below header
    Item {
        id: contentAreaItem
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        clip: true
    }
}
