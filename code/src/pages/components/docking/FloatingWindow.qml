import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import mokm_video_editor

Window {
    id: root
    width: 600
    height: 400
    minimumWidth: 200
    minimumHeight: 150
    title: panelNames[panelType]
    color: Theme.background
    flags: Qt.Window | Qt.WindowCloseButtonHint | Qt.WindowMinMaxButtonsHint

    property int panelType: DockManager.preview
    property bool isFloating: true

    readonly property var panelNames: ["Preview", "Media Bin", "Properties", "Node Editor", "Timeline"]
    readonly property var panelSources: [
        "qrc:/qt/qml/mokm_video_editor/src/pages/components/panels/PreviewPanel.qml",
        "qrc:/qt/qml/mokm_video_editor/src/pages/components/panels/MiniBin.qml",
        "qrc:/qt/qml/mokm_video_editor/src/pages/components/panels/PropertiesPanel.qml",
        "qrc:/qt/qml/mokm_video_editor/src/pages/components/panels/NodePanel.qml",
        "qrc:/qt/qml/mokm_video_editor/src/pages/components/panels/TimelinePanel.qml"
    ]

    signal closeRequested()

    Rectangle {
        anchors.fill: parent
        color: Theme.background
        border.width: 1
        border.color: Theme.border

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // Header bar
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 26
                color: Theme.secondary

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 4
                    spacing: 4

                    // Panel type indicator
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
                            source: panelIcons[root.panelType]
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
                                        root.panelType = index
                                        root.title = root.panelNames[index]
                                        loadPanelContent()
                                    }
                                }
                            }
                        }
                    }

                    Item { Layout.fillWidth: true }

                    // Dock back button
                    Rectangle {
                        width: 20
                        height: 20
                        radius: 3
                        color: "transparent"

                        Image {
                            anchors.centerIn: parent
                            source: "qrc:/icons/outline/layout-dashboard.svg"
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
                            onEntered: parent.color = Theme.secondaryHover
                            onExited: parent.color = "transparent"
                        }

                        ToolTip.visible: false
                        ToolTip.text: "Dock back to editor"
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
                            onClicked: root.close()
                            onEntered: parent.color = Qt.rgba(0.8, 0.2, 0.2, 0.3)
                            onExited: parent.color = "transparent"
                        }
                    }
                }
            }

            // Content area
            Item {
                id: contentArea
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
            }
        }
    }

    readonly property var panelIcons: [
        "qrc:/icons/outline/player-play.svg",
        "qrc:/icons/outline/folder.svg",
        "qrc:/icons/outline/adjustments.svg",
        "qrc:/icons/outline/box.svg",
        "qrc:/icons/outline/list.svg"
    ]

    function loadPanelContent() {
        for (var i = contentArea.children.length - 1; i >= 0; i--) {
            contentArea.children[i].destroy()
        }

        var source = panelSources[panelType]
        if (!source) return

        var comp = Qt.createComponent(source)
        if (comp.status === Component.Ready) {
            comp.createObject(contentArea, {
                "anchors.fill": contentArea
            })
        }
    }

    Component.onCompleted: loadPanelContent()
}
