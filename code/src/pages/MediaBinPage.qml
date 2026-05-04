import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import mokm_video_editor
import QtQuick.Effects

Item {
    id: mediaBinPage

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Toolbar
        EditorToolBar {
            Layout.fillWidth: true

            Image {
                source: "qrc:/icons/outline/search.svg"
                width: 16
                height: 16
                sourceSize: Qt.size(16, 16)
                opacity: 0.5
                Layout.alignment: Qt.AlignVCenter
                layer.effect: MultiEffect {
                    colorization: 1.0
                    colorizationColor: Theme.primary
                    brightness: 1.0
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 26
                radius: 4
                color: Theme.input
                border.color: Theme.border
                border.width: 1

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Search media..."
                    color: Theme.muted
                    font.pixelSize: 12
                }
            }

            Item {
                Layout.preferredWidth: 8
            }

            // Grid view toggle
            Rectangle {
                width: 28
                height: 28
                radius: 4
                color: Theme.secondaryHover
                Layout.alignment: Qt.AlignVCenter

                Image {
                    anchors.centerIn: parent
                    source: "qrc:/icons/outline/layout-grid.svg"
                    width: 16
                    height: 16
                    sourceSize: Qt.size(16, 16)
                    opacity: 0.7
                    layer.effect: MultiEffect {
                        colorization: 1.0
                        colorizationColor: Theme.primary
                        brightness: 1.0
                    }
                }
            }

            // List view toggle
            Rectangle {
                width: 28
                height: 28
                radius: 4
                color: "transparent"
                Layout.alignment: Qt.AlignVCenter

                Image {
                    anchors.centerIn: parent
                    source: "qrc:/icons/outline/list.svg"
                    width: 16
                    height: 16
                    sourceSize: Qt.size(16, 16)
                    opacity: 0.4
                    layer.effect: MultiEffect {
                        colorization: 1.0
                        colorizationColor: Theme.primary
                        brightness: 1.0
                    }
                }
            }

            Item {
                Layout.preferredWidth: 8
            }

            // Import button
            Rectangle {
                width: 80
                height: 26
                radius: 4
                color: Theme.primary
                Layout.alignment: Qt.AlignVCenter

                Row {
                    anchors.centerIn: parent
                    spacing: 4

                    Image {
                        source: "qrc:/icons/outline/plus.svg"
                        width: 14
                        height: 14
                        sourceSize: Qt.size(14, 14)
                        anchors.verticalCenter: parent.verticalCenter
                        layer.effect: MultiEffect {
                            colorization: 1.0
                            colorizationColor: Theme.primary
                            brightness: 1.0
                        }
                    }

                    Text {
                        text: "Import"
                        color: Theme.background
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }

        // Content area
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // Left panel - Folder tree
            Rectangle {
                Layout.preferredWidth: 200
                Layout.fillHeight: true
                color: Theme.secondary

                // Right border
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
                        title: "FOLDERS"
                    }

                    ListView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.margins: 4
                        clip: true
                        spacing: 1

                        model: ListModel {
                            ListElement {
                                name: "Project Files"
                                depth: 0
                                expanded: true
                            }
                            ListElement {
                                name: "Footage"
                                depth: 1
                                expanded: false
                            }
                            ListElement {
                                name: "Audio"
                                depth: 1
                                expanded: false
                            }
                            ListElement {
                                name: "Graphics"
                                depth: 1
                                expanded: false
                            }
                            ListElement {
                                name: "Sequences"
                                depth: 1
                                expanded: false
                            }
                            ListElement {
                                name: "Exports"
                                depth: 0
                                expanded: false
                            }
                        }

                        delegate: Rectangle {
                            width: ListView.view.width
                            height: 28
                            radius: 4
                            color: index === 1 ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.12) : "transparent"

                            Row {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 8 + model.depth * 16
                                spacing: 6

                                Image {
                                    source: model.expanded ? "qrc:/icons/outline/folder-open.svg" : "qrc:/icons/outline/folder.svg"
                                    width: 14
                                    height: 14
                                    sourceSize: Qt.size(14, 14)
                                    opacity: index === 1 ? 0.9 : 0.5
                                    anchors.verticalCenter: parent.verticalCenter
                                    layer.effect: MultiEffect {
                                        colorization: 1.0
                                        colorizationColor: Theme.primary
                                        brightness: 1.0
                                    }
                                }

                                Text {
                                    text: model.name
                                    color: index === 1 ? Theme.primary : Theme.foreground
                                    font.pixelSize: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                        }
                    }
                }
            }

            // Right panel - File grid
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Theme.background

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0

                    PanelHeader {
                        Layout.fillWidth: true
                        title: "FILES"
                        accentColor: Theme.accent
                    }

                    // File grid
                    GridView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.margins: 8
                        cellWidth: 130
                        cellHeight: 110
                        clip: true

                        model: ListModel {
                            ListElement {
                                fileName: "scene_01.mp4"
                                fileType: "video"
                                duration: "00:02:34"
                            }
                            ListElement {
                                fileName: "scene_02.mp4"
                                fileType: "video"
                                duration: "00:01:12"
                            }
                            ListElement {
                                fileName: "interview.mp4"
                                fileType: "video"
                                duration: "00:15:40"
                            }
                            ListElement {
                                fileName: "b-roll_01.mp4"
                                fileType: "video"
                                duration: "00:00:45"
                            }
                            ListElement {
                                fileName: "music_bg.wav"
                                fileType: "audio"
                                duration: "00:03:20"
                            }
                            ListElement {
                                fileName: "sfx_whoosh.wav"
                                fileType: "audio"
                                duration: "00:00:02"
                            }
                            ListElement {
                                fileName: "title_card.png"
                                fileType: "image"
                                duration: ""
                            }
                            ListElement {
                                fileName: "lower_third.png"
                                fileType: "image"
                                duration: ""
                            }
                            ListElement {
                                fileName: "logo.svg"
                                fileType: "image"
                                duration: ""
                            }
                        }

                        delegate: Rectangle {
                            width: 122
                            height: 102
                            radius: 6
                            color: Theme.secondary
                            border.width: 1
                            border.color: Theme.border

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 4
                                spacing: 4

                                // Thumbnail area
                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 58
                                    radius: 4
                                    color: Theme.background

                                    Image {
                                        anchors.centerIn: parent
                                        source: {
                                            if (model.fileType === "video")
                                                return "qrc:/icons/outline/video.svg";
                                            if (model.fileType === "audio")
                                                return "qrc:/icons/outline/music.svg";
                                            return "qrc:/icons/outline/photo.svg";
                                        }
                                        width: 20
                                        height: 20
                                        sourceSize: Qt.size(20, 20)
                                        opacity: 0.3
                                        layer.effect: MultiEffect {
                                            colorization: 1.0
                                            colorizationColor: Theme.primary
                                            brightness: 1.0
                                        }
                                    }

                                    // Duration badge
                                    Rectangle {
                                        visible: model.duration !== ""
                                        anchors.right: parent.right
                                        anchors.bottom: parent.bottom
                                        anchors.margins: 3
                                        width: durationText.width + 6
                                        height: 14
                                        radius: 2
                                        color: Qt.rgba(0, 0, 0, 0.7)

                                        Text {
                                            id: durationText
                                            anchors.centerIn: parent
                                            text: model.duration
                                            color: Theme.foreground
                                            font.pixelSize: 8
                                        }
                                    }
                                }

                                // File name
                                Text {
                                    Layout.fillWidth: true
                                    text: model.fileName
                                    color: Theme.foreground
                                    font.pixelSize: 10
                                    elide: Text.ElideMiddle
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
