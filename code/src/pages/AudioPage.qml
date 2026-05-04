import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import mokm_video_editor
import QtQuick.Effects

Item {
    id: audioPage

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Left panel - Preview + Timeline
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // Small video preview
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 180
                color: "#000000"
                Layout.margins: 6
                radius: 6
                border.width: 1
                border.color: Theme.border

                Image {
                    anchors.centerIn: parent
                    source: "qrc:/icons/outline/video.svg"
                    width: 32
                    height: 32
                    sourceSize: Qt.size(32, 32)
                    opacity: 0.15
                    layer.effect: MultiEffect {
                        colorization: 1.0
                        colorizationColor: Theme.foreground
                        brightness: 1.0
                    }
                }
            }

            // Separator
            PanelHeader {
                Layout.fillWidth: true
                title: "AUDIO TIMELINE"
                accentColor: Theme.success
            }

            // Audio timeline tracks
            Flickable {
                Layout.fillWidth: true
                Layout.fillHeight: true
                contentHeight: audioTracks.height
                clip: true

                Column {
                    id: audioTracks
                    width: parent.width
                    spacing: 0

                    TimelineTrack {
                        width: parent.width
                        trackName: "Voice"
                        trackColor: Theme.success
                    }
                    TimelineTrack {
                        width: parent.width
                        trackName: "Music"
                        trackColor: Theme.accent
                    }
                    TimelineTrack {
                        width: parent.width
                        trackName: "SFX"
                        trackColor: Theme.warning
                    }
                    TimelineTrack {
                        width: parent.width
                        trackName: "Foley"
                        trackColor: "#8b5cf6"
                    }
                    TimelineTrack {
                        width: parent.width
                        trackName: "Ambience"
                        trackColor: "#14b8a6"
                    }

                    // Automation lane placeholder
                    Rectangle {
                        width: parent.width
                        height: 80
                        color: "transparent"

                        Rectangle {
                            anchors.left: parent.left
                            width: 120
                            height: parent.height
                            color: Theme.secondary
                            Rectangle {
                                width: 1
                                height: parent.height
                                anchors.right: parent.right
                                color: Theme.border
                            }
                            Row {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 8
                                spacing: 4
                                Rectangle {
                                    width: 4
                                    height: 16
                                    radius: 2
                                    color: Theme.primary
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Text {
                                    text: "Automation"
                                    color: Theme.mutedForeground
                                    font.pixelSize: 11
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                        }

                        // Simple automation curve placeholder
                        Rectangle {
                            anchors.left: parent.left
                            anchors.leftMargin: 120
                            anchors.right: parent.right
                            height: parent.height
                            color: "transparent"
                            Rectangle {
                                width: parent.width
                                height: 1
                                anchors.bottom: parent.bottom
                                color: Theme.border
                                opacity: 0.4
                            }

                            Canvas {
                                anchors.fill: parent
                                anchors.margins: 4
                                onPaint: {
                                    var ctx = getContext("2d");
                                    ctx.clearRect(0, 0, width, height);
                                    ctx.strokeStyle = Theme.primary;
                                    ctx.lineWidth = 2;
                                    ctx.globalAlpha = 0.6;
                                    ctx.beginPath();
                                    ctx.moveTo(0, height * 0.7);
                                    ctx.bezierCurveTo(width * 0.2, height * 0.3, width * 0.4, height * 0.5, width * 0.6, height * 0.2);
                                    ctx.bezierCurveTo(width * 0.8, height * 0.1, width * 0.9, height * 0.6, width, height * 0.4);
                                    ctx.stroke();
                                }
                            }
                        }
                    }
                }
            }
        }

        // Right border
        Rectangle {
            width: 1
            Layout.fillHeight: true
            color: Theme.border
        }

        // Right panel - Mixer / Plugins
        Rectangle {
            Layout.preferredWidth: 280
            Layout.fillHeight: true
            color: Theme.secondary

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                PanelHeader {
                    Layout.fillWidth: true
                    title: "MIXER"
                    accentColor: Theme.primary
                }

                // Volume sliders
                Flickable {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    contentHeight: mixerCol.height
                    clip: true

                    Column {
                        id: mixerCol
                        width: parent.width
                        spacing: 8
                        padding: 12

                        Repeater {
                            model: [
                                {
                                    name: "Voice",
                                    color: "#22c55e",
                                    level: 0.75
                                },
                                {
                                    name: "Music",
                                    color: "#3b82f6",
                                    level: 0.55
                                },
                                {
                                    name: "SFX",
                                    color: "#f59e0b",
                                    level: 0.40
                                },
                                {
                                    name: "Foley",
                                    color: "#8b5cf6",
                                    level: 0.60
                                },
                                {
                                    name: "Ambience",
                                    color: "#14b8a6",
                                    level: 0.30
                                }
                            ]

                            Rectangle {
                                width: parent.width - 24
                                height: 36
                                radius: 4
                                color: Theme.background

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 8
                                    spacing: 8

                                    Rectangle {
                                        width: 4
                                        height: 16
                                        radius: 2
                                        color: modelData.color
                                    }
                                    Text {
                                        text: modelData.name
                                        color: Theme.foreground
                                        font.pixelSize: 11
                                        Layout.preferredWidth: 60
                                    }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        height: 4
                                        radius: 2
                                        color: Theme.muted
                                        Rectangle {
                                            width: parent.width * modelData.level
                                            height: parent.height
                                            radius: 2
                                            color: modelData.color
                                        }
                                    }

                                    Text {
                                        text: Math.round(modelData.level * 100) + "%"
                                        color: Theme.mutedForeground
                                        font.pixelSize: 10
                                    }
                                }
                            }
                        }

                        // Master volume
                        Rectangle {
                            width: parent.width - 24
                            height: 44
                            radius: 6
                            color: Theme.background
                            border.width: 1
                            border.color: Theme.primary

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 8
                                spacing: 8
                                Rectangle {
                                    width: 4
                                    height: 20
                                    radius: 2
                                    color: Theme.primary
                                }
                                Text {
                                    text: "Master"
                                    color: Theme.primary
                                    font.pixelSize: 12
                                    font.weight: Font.Medium
                                    Layout.preferredWidth: 60
                                }
                                Rectangle {
                                    Layout.fillWidth: true
                                    height: 6
                                    radius: 3
                                    color: Theme.muted
                                    Rectangle {
                                        width: parent.width * 0.8
                                        height: parent.height
                                        radius: 3
                                        color: Theme.primary
                                    }
                                }
                                Text {
                                    text: "80%"
                                    color: Theme.primary
                                    font.pixelSize: 11
                                }
                            }
                        }
                    }
                }

                // Plugin section
                PanelHeader {
                    Layout.fillWidth: true
                    title: "PLUGINS"
                    accentColor: Theme.accent
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 120
                    Layout.margins: 8
                    clip: true
                    spacing: 4

                    model: ListModel {
                        ListElement {
                            name: "EQ (Parametric)"
                            active: true
                        }
                        ListElement {
                            name: "Compressor"
                            active: true
                        }
                        ListElement {
                            name: "Reverb"
                            active: false
                        }
                    }

                    delegate: Rectangle {
                        width: ListView.view.width
                        height: 28
                        radius: 4
                        color: Theme.background

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 6
                            spacing: 6
                            Rectangle {
                                width: 6
                                height: 6
                                radius: 3
                                color: model.active ? Theme.success : Theme.muted
                            }
                            Text {
                                text: model.name
                                color: Theme.foreground
                                font.pixelSize: 11
                                Layout.fillWidth: true
                            }
                            Image {
                                source: "qrc:/icons/outline/dots-vertical.svg"
                                width: 14
                                height: 14
                                sourceSize: Qt.size(14, 14)
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
