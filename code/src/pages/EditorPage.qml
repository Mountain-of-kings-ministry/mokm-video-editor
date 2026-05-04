import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import mokm_video_editor
import QtQuick.Effects

Item {
    id: editorPage

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Top half - Video preview
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: parent.height * 0.55
            color: Theme.background

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                // Preview viewport
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.margins: 8
                    radius: 8
                    color: "#000000"
                    border.width: 1
                    border.color: Theme.border

                    // Center play icon
                    Image {
                        anchors.centerIn: parent
                        source: "qrc:/icons/outline/player-play.svg"
                        width: 48
                        height: 48
                        sourceSize: Qt.size(48, 48)
                        opacity: 0.15
                        layer.effect: MultiEffect {
                            colorization: 1.0
                            colorizationColor: Theme.foreground
                            brightness: 1.0
                        }
                    }

                    // Timecode overlay
                    Rectangle {
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                        anchors.margins: 12
                        width: tcText.width + 12
                        height: 22
                        radius: 4
                        color: Qt.rgba(0, 0, 0, 0.6)

                        Text {
                            id: tcText
                            anchors.centerIn: parent
                            text: "00:00:00:00"
                            color: Theme.primary
                            font.pixelSize: 11
                            font.family: "monospace"
                        }
                    }
                }

                // Playback controls bar
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    color: Theme.secondary

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 16

                        Repeater {
                            model: ["qrc:/icons/outline/player-skip-back.svg", "qrc:/icons/outline/player-track-prev.svg", "qrc:/icons/outline/player-play.svg", "qrc:/icons/outline/player-track-next.svg", "qrc:/icons/outline/player-skip-forward.svg"]

                            Rectangle {
                                width: modelData.indexOf("player-play") >= 0 ? 36 : 28
                                height: width
                                radius: width / 2
                                color: modelData.indexOf("player-play") >= 0 ? Theme.primary : "transparent"

                                Image {
                                    anchors.centerIn: parent
                                    source: modelData
                                    width: modelData.indexOf("player-play") >= 0 ? 18 : 16
                                    height: width
                                    sourceSize: Qt.size(width, height)
                                    opacity: modelData.indexOf("player-play") >= 0 ? 1.0 : 0.5
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
                                }
                            }
                        }
                    }
                }
            }
        }

        // Divider
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 2
            color: Theme.border
        }

        // Bottom half - Timeline
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: parent.height * 0.45
            color: Theme.background

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                // Timeline toolbar
                EditorToolBar {
                    Layout.fillWidth: true

                    Repeater {
                        model: [
                            {
                                icon: "qrc:/icons/outline/cut.svg",
                                tip: "Cut"
                            },
                            {
                                icon: "qrc:/icons/outline/arrows-move-horizontal.svg",
                                tip: "Trim"
                            },
                            {
                                icon: "qrc:/icons/outline/separator.svg",
                                tip: "Split"
                            },
                            {
                                icon: "qrc:/icons/outline/magnet.svg",
                                tip: "Snap"
                            }
                        ]

                        Rectangle {
                            width: 28
                            height: 28
                            radius: 4
                            color: "transparent"
                            Layout.alignment: Qt.AlignVCenter

                            Image {
                                anchors.centerIn: parent
                                source: modelData.icon
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

                            ToolTip.visible: false
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    // Zoom controls
                    Image {
                        source: "qrc:/icons/outline/zoom-out.svg"
                        width: 14
                        height: 14
                        sourceSize: Qt.size(14, 14)
                        opacity: 0.4
                        Layout.alignment: Qt.AlignVCenter
                        layer.effect: MultiEffect {
                            colorization: 1.0
                            colorizationColor: Theme.foreground
                            brightness: 1.0
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: 80
                        Layout.preferredHeight: 4
                        radius: 2
                        color: Theme.muted
                        Layout.alignment: Qt.AlignVCenter

                        Rectangle {
                            width: parent.width * 0.5
                            height: parent.height
                            radius: 2
                            color: Theme.primary
                        }
                    }

                    Image {
                        source: "qrc:/icons/outline/zoom-in.svg"
                        width: 14
                        height: 14
                        sourceSize: Qt.size(14, 14)
                        opacity: 0.4
                        Layout.alignment: Qt.AlignVCenter
                        layer.effect: MultiEffect {
                            colorization: 1.0
                            colorizationColor: Theme.foreground
                            brightness: 1.0
                        }
                    }
                }

                // Timeline ruler
                TimelineRuler {
                    Layout.fillWidth: true
                }

                // Timeline tracks
                Flickable {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    contentHeight: trackColumn.height
                    clip: true

                    Column {
                        id: trackColumn
                        width: parent.width
                        spacing: 0

                        TimelineTrack {
                            width: parent.width
                            trackName: "V1"
                            trackColor: Theme.accent
                        }

                        TimelineTrack {
                            width: parent.width
                            trackName: "V2"
                            trackColor: "#8b5cf6"
                        }

                        TimelineTrack {
                            width: parent.width
                            trackName: "A1"
                            trackColor: Theme.success
                        }

                        TimelineTrack {
                            width: parent.width
                            trackName: "A2"
                            trackColor: "#14b8a6"
                        }
                    }
                }
            }
        }
    }
}
