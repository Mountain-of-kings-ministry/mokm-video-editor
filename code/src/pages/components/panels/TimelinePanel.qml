import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import mokm_video_editor

Rectangle {
    id: root
    color: Theme.background

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Timeline toolbar
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 32
            color: Theme.secondary

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 4
                anchors.rightMargin: 4
                spacing: 4

                // Tool buttons
                Repeater {
                    model: [
                        { icon: "qrc:/icons/outline/cut.svg", tip: "Cut" },
                        { icon: "qrc:/icons/outline/arrows-move-horizontal.svg", tip: "Trim" },
                        { icon: "qrc:/icons/outline/separator.svg", tip: "Split" },
                        { icon: "qrc:/icons/outline/magnet.svg", tip: "Snap" }
                    ]

                    Rectangle {
                        width: 24
                        height: 24
                        radius: 3
                        color: "transparent"

                        Image {
                            anchors.centerIn: parent
                            source: modelData.icon
                            width: 14
                            height: 14
                            sourceSize: Qt.size(14, 14)
                            opacity: 0.5
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
                            onEntered: parent.color = Theme.secondaryHover
                            onExited: parent.color = "transparent"
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                // Add track buttons
                Rectangle {
                    width: 24
                    height: 24
                    radius: 3
                    color: "transparent"

                    Row {
                        anchors.centerIn: parent
                        spacing: 2

                        Image {
                            anchors.verticalCenter: parent.verticalCenter
                            source: "qrc:/icons/outline/plus.svg"
                            width: 12
                            height: 12
                            sourceSize: Qt.size(12, 12)
                            layer.enabled: true
                            layer.effect: MultiEffect {
                                colorization: 1.0
                                colorizationColor: Theme.accent
                                brightness: 1.0
                            }
                        }

                        Text {
                            text: "V"
                            color: Theme.accent
                            font.pixelSize: 9
                            font.weight: Font.Medium
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: trackModel.addVideoTrack()
                        onEntered: parent.color = Theme.secondaryHover
                        onExited: parent.color = "transparent"
                    }
                }

                Rectangle {
                    width: 24
                    height: 24
                    radius: 3
                    color: "transparent"

                    Row {
                        anchors.centerIn: parent
                        spacing: 2

                        Image {
                            anchors.verticalCenter: parent.verticalCenter
                            source: "qrc:/icons/outline/plus.svg"
                            width: 12
                            height: 12
                            sourceSize: Qt.size(12, 12)
                            layer.enabled: true
                            layer.effect: MultiEffect {
                                colorization: 1.0
                                colorizationColor: Theme.success
                                brightness: 1.0
                            }
                        }

                        Text {
                            text: "A"
                            color: Theme.success
                            font.pixelSize: 9
                            font.weight: Font.Medium
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: trackModel.addAudioTrack()
                        onEntered: parent.color = Theme.secondaryHover
                        onExited: parent.color = "transparent"
                    }
                }

                Item { Layout.preferredWidth: 8 }

                // Zoom controls
                Image {
                    source: "qrc:/icons/outline/zoom-out.svg"
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

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: timelinePlayer.zoomLevel = Math.max(10, timelinePlayer.zoomLevel - 10)
                        onEntered: parent.opacity = 0.7
                        onExited: parent.opacity = 0.4
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 60
                    Layout.preferredHeight: 3
                    radius: 2
                    color: Theme.muted

                    Rectangle {
                        width: (timelinePlayer.zoomLevel / 200) * parent.width
                        height: parent.height
                        radius: 2
                        color: Theme.primary
                    }
                }

                Image {
                    source: "qrc:/icons/outline/zoom-in.svg"
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

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: timelinePlayer.zoomLevel = Math.min(200, timelinePlayer.zoomLevel + 10)
                        onEntered: parent.opacity = 0.7
                        onExited: parent.opacity = 0.4
                    }
                }
            }
        }

        // Timeline ruler
        TimelineRuler {
            Layout.fillWidth: true
        }

        // Timeline tracks with drop support
        Flickable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentHeight: trackColumn.height
            clip: true

            // Drop area for media files
            DropArea {
                anchors.fill: parent
                onDropped: (drop) => {
                    if (drop.hasText) {
                        var filePath = drop.text
                        var targetTrack = Math.floor(trackColumn.children.length - 1)
                        if (targetTrack >= 0) {
                            trackModel.importMediaToTrack(filePath, targetTrack)
                        }
                    }
                }
            }

            Column {
                id: trackColumn
                width: parent.width
                spacing: 0

                Repeater {
                    model: trackModel

                    TimelineTrack {
                        width: parent.width
                        trackName: model.trackName
                        trackColor: model.trackColor
                        trackType: model.trackType
                        trackLocked: model.trackLocked
                        trackVisible: model.trackVisible
                        mediaCount: model.trackMediaCount

                        DropArea {
                            anchors.fill: parent
                            onDropped: (drop) => {
                                if (drop.hasText) {
                                    trackModel.importMediaToTrack(drop.text, index)
                                }
                            }
                        }
                    }
                }
            }
        }

        // Empty state
        ColumnLayout {
            anchors.centerIn: parent
            spacing: 12
            visible: trackModel.trackCount === 0

            Image {
                Layout.alignment: Qt.AlignHCenter
                source: "qrc:/icons/outline/list.svg"
                width: 32
                height: 32
                sourceSize: Qt.size(32, 32)
                opacity: 0.15
                layer.enabled: true
                layer.effect: MultiEffect {
                    colorization: 1.0
                    colorizationColor: Theme.muted
                    brightness: 1.0
                }
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "No tracks yet"
                color: Theme.muted
                font.pixelSize: 11
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "Add video or audio tracks to begin"
                color: Theme.muted
                font.pixelSize: 9
            }
        }
    }
}
