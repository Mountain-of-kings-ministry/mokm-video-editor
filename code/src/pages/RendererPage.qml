import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import mokm_video_editor
import QtQuick.Effects

Item {
    id: rendererPage

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Left panel - Render queue
        Rectangle {
            Layout.preferredWidth: 260
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
                    title: "RENDER QUEUE"
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.margins: 6
                    clip: true
                    spacing: 4

                    model: ListModel {
                        ListElement {
                            name: "Final Export v3"
                            status: "rendering"
                            progress: 0.62
                            format: "H.264 • 1080p"
                        }
                        ListElement {
                            name: "Proxy Batch #1"
                            status: "queued"
                            progress: 0.0
                            format: "H.264 • 540p"
                        }
                        ListElement {
                            name: "Preview Render"
                            status: "queued"
                            progress: 0.0
                            format: "ProRes • 1080p"
                        }
                        ListElement {
                            name: "Audio Mixdown"
                            status: "done"
                            progress: 1.0
                            format: "WAV • 48kHz"
                        }
                        ListElement {
                            name: "Title Sequence"
                            status: "done"
                            progress: 1.0
                            format: "H.264 • 4K"
                        }
                    }

                    delegate: Rectangle {
                        width: ListView.view.width
                        height: 64
                        radius: 6
                        color: Theme.background
                        border.width: model.status === "rendering" ? 1 : 0
                        border.color: Theme.primary

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 4

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 6
                                Image {
                                    source: model.status === "done" ? "qrc:/icons/outline/circle-check.svg" : (model.status === "rendering" ? "qrc:/icons/outline/loader.svg" : "qrc:/icons/outline/clock.svg")
                                    width: 14
                                    height: 14
                                    sourceSize: Qt.size(14, 14)
                                    opacity: model.status === "done" ? 0.6 : 0.8
                                    layer.enabled: true
                                    layer.effect: MultiEffect {
                                        colorization: 1.0
                                        colorizationColor: model.status === "done" ? Theme.primary : (mouseArea.containsMouse ? Theme.foreground : "#8c8c8c")
                                        brightness: 1.0
                                    }
                                }
                                Text {
                                    text: model.name
                                    color: Theme.foreground
                                    font.pixelSize: 12
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }
                            }

                            Text {
                                text: model.format
                                color: Theme.muted
                                font.pixelSize: 10
                            }

                            // Progress bar
                            Rectangle {
                                Layout.fillWidth: true
                                height: 3
                                radius: 2
                                color: Theme.muted
                                visible: model.status !== "done"
                                Rectangle {
                                    width: parent.width * model.progress
                                    height: parent.height
                                    radius: 2
                                    color: model.status === "rendering" ? Theme.primary : Theme.muted
                                }
                            }
                            Rectangle {
                                Layout.fillWidth: true
                                height: 3
                                radius: 2
                                color: Theme.success
                                visible: model.status === "done"
                                opacity: 0.4
                            }
                        }
                    }
                }

                // Add to queue button
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 36
                    Layout.margins: 8
                    radius: 4
                    color: Theme.primary
                    Row {
                        anchors.centerIn: parent
                        spacing: 4
                        Image {
                            source: "qrc:/icons/outline/plus.svg"
                            width: 14
                            height: 14
                            sourceSize: Qt.size(14, 14)
                            anchors.verticalCenter: parent.verticalCenter
                            layer.enabled: true
                            layer.effect: MultiEffect {
                                colorization: 1.0
                                colorizationColor: settingsPage.selectedCategory === index ? Theme.primary : (mouseArea.containsMouse ? Theme.foreground : "#8c8c8c")
                                brightness: 1.0
                            }
                        }
                        Text {
                            text: "Add Render"
                            color: Theme.background
                            font.pixelSize: 12
                            font.weight: Font.Medium
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }
        }

        // Right panel - Current render details
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            PanelHeader {
                Layout.fillWidth: true
                title: "RENDER DETAILS"
                accentColor: Theme.primary
            }

            Flickable {
                Layout.fillWidth: true
                Layout.fillHeight: true
                contentHeight: detailsCol.height
                clip: true

                Column {
                    id: detailsCol
                    width: parent.width
                    spacing: 16
                    padding: 16

                    // Current render info card
                    Rectangle {
                        width: parent.width - 32
                        height: 120
                        radius: 8
                        color: Theme.secondary
                        border.width: 1
                        border.color: Theme.border

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 8

                            Text {
                                text: "Final Export v3"
                                color: Theme.foreground
                                font.pixelSize: 16
                                font.weight: Font.Medium
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 16
                                Column {
                                    spacing: 2
                                    Text {
                                        text: "Format"
                                        color: Theme.muted
                                        font.pixelSize: 10
                                    }
                                    Text {
                                        text: "H.264"
                                        color: Theme.foreground
                                        font.pixelSize: 12
                                    }
                                }
                                Column {
                                    spacing: 2
                                    Text {
                                        text: "Resolution"
                                        color: Theme.muted
                                        font.pixelSize: 10
                                    }
                                    Text {
                                        text: "1920×1080"
                                        color: Theme.foreground
                                        font.pixelSize: 12
                                    }
                                }
                                Column {
                                    spacing: 2
                                    Text {
                                        text: "Frame Rate"
                                        color: Theme.muted
                                        font.pixelSize: 10
                                    }
                                    Text {
                                        text: "24 fps"
                                        color: Theme.foreground
                                        font.pixelSize: 12
                                    }
                                }
                                Column {
                                    spacing: 2
                                    Text {
                                        text: "Bit Depth"
                                        color: Theme.muted
                                        font.pixelSize: 10
                                    }
                                    Text {
                                        text: "8-bit"
                                        color: Theme.foreground
                                        font.pixelSize: 12
                                    }
                                }
                            }

                            // Progress
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 8
                                Rectangle {
                                    Layout.fillWidth: true
                                    height: 6
                                    radius: 3
                                    color: Theme.muted
                                    Rectangle {
                                        width: parent.width * 0.62
                                        height: parent.height
                                        radius: 3
                                        color: Theme.primary
                                        Behavior on width {
                                            NumberAnimation {
                                                duration: 300
                                            }
                                        }
                                    }
                                }
                                Text {
                                    text: "62%"
                                    color: Theme.primary
                                    font.pixelSize: 12
                                    font.weight: Font.Medium
                                }
                            }
                        }
                    }

                    // Time remaining
                    Rectangle {
                        width: parent.width - 32
                        height: 60
                        radius: 8
                        color: Theme.secondary

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 16
                            Column {
                                spacing: 2
                                Text {
                                    text: "Elapsed"
                                    color: Theme.muted
                                    font.pixelSize: 10
                                }
                                Text {
                                    text: "00:04:32"
                                    color: Theme.foreground
                                    font.pixelSize: 14
                                    font.family: "monospace"
                                }
                            }
                            Column {
                                spacing: 2
                                Text {
                                    text: "Remaining"
                                    color: Theme.muted
                                    font.pixelSize: 10
                                }
                                Text {
                                    text: "00:02:48"
                                    color: Theme.primary
                                    font.pixelSize: 14
                                    font.family: "monospace"
                                }
                            }
                            Column {
                                spacing: 2
                                Text {
                                    text: "Speed"
                                    color: Theme.muted
                                    font.pixelSize: 10
                                }
                                Text {
                                    text: "2.4× realtime"
                                    color: Theme.success
                                    font.pixelSize: 14
                                }
                            }
                        }
                    }

                    // Destination
                    Rectangle {
                        width: parent.width - 32
                        height: 50
                        radius: 8
                        color: Theme.secondary

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 8
                            Image {
                                source: "qrc:/icons/outline/folder.svg"
                                width: 16
                                height: 16
                                sourceSize: Qt.size(16, 16)
                                opacity: 0.5
                                layer.enabled: true
                                layer.effect: MultiEffect {
                                    colorization: 1.0
                                    colorizationColor: model.status === "done" ? Theme.primary : (mouseArea.containsMouse ? Theme.foreground : "#8c8c8c")
                                    brightness: 1.0
                                }
                            }
                            Column {
                                Layout.fillWidth: true
                                spacing: 1
                                Text {
                                    text: "Output Destination"
                                    color: Theme.muted
                                    font.pixelSize: 10
                                }
                                Text {
                                    text: "/home/user/Projects/exports/final_v3.mp4"
                                    color: Theme.foreground
                                    font.pixelSize: 11
                                    elide: Text.ElideMiddle
                                    width: 400
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
