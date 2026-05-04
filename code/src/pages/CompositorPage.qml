import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import mokm_video_editor
import QtQuick.Effects

Item {
    id: compositorPage

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Left panel - Layer stack
        Rectangle {
            Layout.preferredWidth: 220
            Layout.fillHeight: true
            color: Theme.secondary

            Rectangle {
                width: 1
                height: parent.height
                anchors.right: parent.right
                color: Theme.border
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                PanelHeader {
                    Layout.fillWidth: true
                    title: "LAYERS"
                    accentColor: Theme.accent
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.margins: 4
                    clip: true
                    spacing: 2

                    model: ListModel {
                        ListElement {
                            name: "Title Overlay"
                            layerType: "text"
                            visible: true
                            opacity_val: 100
                            blendMode: "Normal"
                        }
                        ListElement {
                            name: "Color Grade"
                            layerType: "effect"
                            visible: true
                            opacity_val: 85
                            blendMode: "Overlay"
                        }
                        ListElement {
                            name: "Green Screen Key"
                            layerType: "effect"
                            visible: true
                            opacity_val: 100
                            blendMode: "Normal"
                        }
                        ListElement {
                            name: "Foreground"
                            layerType: "video"
                            visible: true
                            opacity_val: 100
                            blendMode: "Normal"
                        }
                        ListElement {
                            name: "Background Plate"
                            layerType: "video"
                            visible: true
                            opacity_val: 100
                            blendMode: "Normal"
                        }
                        ListElement {
                            name: "Solid (Black)"
                            layerType: "solid"
                            visible: false
                            opacity_val: 100
                            blendMode: "Normal"
                        }
                    }

                    delegate: Rectangle {
                        width: ListView.view.width
                        height: 44
                        radius: 4
                        color: index === 3 ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.12) : Theme.background

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 6
                            spacing: 6

                            Image {
                                source: model.visible ? "qrc:/icons/outline/eye.svg" : "qrc:/icons/outline/eye-off.svg"
                                width: 14
                                height: 14
                                sourceSize: Qt.size(14, 14)
                                opacity: model.visible ? 0.6 : 0.25
                                Layout.alignment: Qt.AlignVCenter
                                layer.effect: MultiEffect {
                                    colorization: 1.0
                                    colorizationColor: Theme.foreground
                                    brightness: 1.0
                                }
                            }

                            Column {
                                Layout.fillWidth: true
                                spacing: 1
                                Text {
                                    text: model.name
                                    color: Theme.foreground
                                    font.pixelSize: 11
                                }
                                Text {
                                    text: model.blendMode + " • " + model.opacity_val + "%"
                                    color: Theme.muted
                                    font.pixelSize: 9
                                }
                            }
                        }
                    }
                }

                // Add layer button
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 36
                    Layout.margins: 8
                    radius: 4
                    color: Theme.background
                    border.width: 1
                    border.color: Theme.border

                    Row {
                        anchors.centerIn: parent
                        spacing: 4
                        Image {
                            source: "qrc:/icons/outline/plus.svg"
                            width: 14
                            height: 14
                            sourceSize: Qt.size(14, 14)
                            opacity: 0.5
                            anchors.verticalCenter: parent.verticalCenter
                            layer.effect: MultiEffect {
                                colorization: 1.0
                                colorizationColor: Theme.foreground
                                brightness: 1.0
                            }
                        }
                        Text {
                            text: "Add Layer"
                            color: Theme.mutedForeground
                            font.pixelSize: 12
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }
        }

        // Center - Canvas preview
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            EditorToolBar {
                Layout.fillWidth: true
                Repeater {
                    model: ["qrc:/icons/outline/transform.svg", "qrc:/icons/outline/crop.svg", "qrc:/icons/outline/mask.svg", "qrc:/icons/outline/blend-mode.svg"]
                    Rectangle {
                        width: 28
                        height: 28
                        radius: 4
                        color: "transparent"
                        Layout.alignment: Qt.AlignVCenter
                        Image {
                            anchors.centerIn: parent
                            source: modelData
                            width: 16
                            height: 16
                            sourceSize: Qt.size(16, 16)
                            opacity: 0.5
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
                            onEntered: parent.color = Theme.secondaryHover
                            onExited: parent.color = "transparent"
                        }
                    }
                }
                Item {
                    Layout.fillWidth: true
                }
                Text {
                    text: "Compositor"
                    color: Theme.mutedForeground
                    font.pixelSize: 12
                    Layout.alignment: Qt.AlignVCenter
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: 12
                radius: 8
                color: "#000000"
                border.width: 1
                border.color: Theme.border

                // Composition frame guides
                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width * 0.7
                    height: parent.height * 0.7
                    color: "transparent"
                    border.width: 1
                    border.color: Qt.rgba(1, 1, 1, 0.08)

                    // Center cross
                    Rectangle {
                        anchors.centerIn: parent
                        width: 20
                        height: 1
                        color: Qt.rgba(1, 1, 1, 0.1)
                    }
                    Rectangle {
                        anchors.centerIn: parent
                        width: 1
                        height: 20
                        color: Qt.rgba(1, 1, 1, 0.1)
                    }

                    Text {
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: 30
                        text: "Composite Preview"
                        color: Qt.rgba(1, 1, 1, 0.12)
                        font.pixelSize: 16
                    }
                }
            }
        }

        Rectangle {
            width: 1
            Layout.fillHeight: true
            color: Theme.border
        }

        // Right panel - Properties
        Rectangle {
            Layout.preferredWidth: 240
            Layout.fillHeight: true
            color: Theme.secondary

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                PanelHeader {
                    Layout.fillWidth: true
                    title: "PROPERTIES"
                    accentColor: Theme.primary
                }

                Flickable {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    contentHeight: propsCol.height
                    clip: true

                    Column {
                        id: propsCol
                        width: parent.width
                        spacing: 8
                        padding: 12

                        // Transform section
                        Text {
                            text: "Transform"
                            color: Theme.mutedForeground
                            font.pixelSize: 11
                            font.weight: Font.Medium
                            leftPadding: 0
                        }

                        Repeater {
                            model: [
                                {
                                    label: "Position X",
                                    value: "960"
                                },
                                {
                                    label: "Position Y",
                                    value: "540"
                                },
                                {
                                    label: "Scale",
                                    value: "100%"
                                },
                                {
                                    label: "Rotation",
                                    value: "0°"
                                },
                                {
                                    label: "Opacity",
                                    value: "100%"
                                }
                            ]
                            RowLayout {
                                width: parent.width - 24
                                spacing: 8
                                Text {
                                    text: modelData.label
                                    color: Theme.muted
                                    font.pixelSize: 10
                                    Layout.preferredWidth: 70
                                }
                                Rectangle {
                                    Layout.fillWidth: true
                                    height: 24
                                    radius: 3
                                    color: Theme.background
                                    border.width: 1
                                    border.color: Theme.border
                                    Text {
                                        anchors.left: parent.left
                                        anchors.leftMargin: 6
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: modelData.value
                                        color: Theme.foreground
                                        font.pixelSize: 11
                                    }
                                }
                            }
                        }

                        Item {
                            width: 1
                            height: 8
                        }
                        Text {
                            text: "Blend Mode"
                            color: Theme.mutedForeground
                            font.pixelSize: 11
                            font.weight: Font.Medium
                        }

                        Rectangle {
                            width: parent.width - 24
                            height: 28
                            radius: 4
                            color: Theme.background
                            border.width: 1
                            border.color: Theme.border
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 6
                                Text {
                                    text: "Normal"
                                    color: Theme.foreground
                                    font.pixelSize: 11
                                    Layout.fillWidth: true
                                }
                                Image {
                                    source: "qrc:/icons/outline/chevron-down.svg"
                                    width: 12
                                    height: 12
                                    sourceSize: Qt.size(12, 12)
                                    opacity: 0.4
                                    layer.effect: MultiEffect {
                                        colorization: 1.0
                                        colorizationColor: Theme.foreground
                                        brightness: 1.0
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
