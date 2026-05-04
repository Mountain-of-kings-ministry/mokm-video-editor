import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import mokm_video_editor
import QtQuick.Effects

Item {
    id: historyPage

    property int viewMode: 0 // 0 = list, 1 = node

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        EditorToolBar {
            Layout.fillWidth: true

            Image {
                source: "qrc:/icons/outline/arrow-back-up.svg"
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
            Image {
                source: "qrc:/icons/outline/arrow-forward-up.svg"
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

            Item {
                Layout.preferredWidth: 16
            }

            // View mode toggle
            Rectangle {
                width: 28
                height: 28
                radius: 4
                Layout.alignment: Qt.AlignVCenter
                color: historyPage.viewMode === 0 ? Theme.secondaryHover : "transparent"
                Image {
                    anchors.centerIn: parent
                    source: "qrc:/icons/outline/list.svg"
                    width: 16
                    height: 16
                    sourceSize: Qt.size(16, 16)
                    opacity: historyPage.viewMode === 0 ? 0.9 : 0.4
                    layer.effect: MultiEffect {
                        colorization: 1.0
                        colorizationColor: Theme.primary
                        brightness: 1.0
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: historyPage.viewMode = 0
                }
            }
            Rectangle {
                width: 28
                height: 28
                radius: 4
                Layout.alignment: Qt.AlignVCenter
                color: historyPage.viewMode === 1 ? Theme.secondaryHover : "transparent"
                Image {
                    anchors.centerIn: parent
                    source: "qrc:/icons/outline/git-branch.svg"
                    width: 16
                    height: 16
                    sourceSize: Qt.size(16, 16)
                    opacity: historyPage.viewMode === 1 ? 0.9 : 0.4
                    layer.effect: MultiEffect {
                        colorization: 1.0
                        colorizationColor: Theme.primary
                        brightness: 1.0
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: historyPage.viewMode = 1
                }
            }

            Item {
                Layout.fillWidth: true
            }
            Text {
                text: "History Manager"
                color: Theme.mutedForeground
                font.pixelSize: 12
                Layout.alignment: Qt.AlignVCenter
            }
        }

        // Header
        PanelHeader {
            Layout.fillWidth: true
            title: historyPage.viewMode === 0 ? "ACTION HISTORY" : "NODE HISTORY"
            accentColor: Theme.warning
        }

        // Content
        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: historyPage.viewMode

            // List View
            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: 8
                clip: true
                spacing: 2

                model: ListModel {
                    ListElement {
                        action: "Cut clip at 00:01:24"
                        track: "V1"
                        time: "11:04:32"
                        isCurrent: false
                    }
                    ListElement {
                        action: "Applied Color Grade"
                        track: "V1"
                        time: "11:04:28"
                        isCurrent: false
                    }
                    ListElement {
                        action: "Moved clip to 00:02:10"
                        track: "V2"
                        time: "11:04:15"
                        isCurrent: false
                    }
                    ListElement {
                        action: "Added audio crossfade"
                        track: "A1"
                        time: "11:03:58"
                        isCurrent: true
                    }
                    ListElement {
                        action: "Imported scene_03.mp4"
                        track: "—"
                        time: "11:03:40"
                        isCurrent: false
                    }
                    ListElement {
                        action: "Trimmed clip end"
                        track: "V1"
                        time: "11:03:22"
                        isCurrent: false
                    }
                    ListElement {
                        action: "Added transition (Dissolve)"
                        track: "V1"
                        time: "11:02:55"
                        isCurrent: false
                    }
                    ListElement {
                        action: "Volume adjustment -3dB"
                        track: "A2"
                        time: "11:02:30"
                        isCurrent: false
                    }
                    ListElement {
                        action: "Speed ramp 200%"
                        track: "V1"
                        time: "11:01:45"
                        isCurrent: false
                    }
                    ListElement {
                        action: "Project created"
                        track: "—"
                        time: "11:00:00"
                        isCurrent: false
                    }
                }

                delegate: Rectangle {
                    width: ListView.view.width
                    height: 36
                    radius: 4
                    color: model.isCurrent ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.12) : (index < 4 ? Theme.secondary : Qt.rgba(Theme.secondary.r, Theme.secondary.g, Theme.secondary.b, 0.4))

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 8

                        Rectangle {
                            width: 8
                            height: 8
                            radius: 4
                            Layout.alignment: Qt.AlignVCenter
                            color: model.isCurrent ? Theme.primary : (index < 4 ? Theme.accent : Theme.muted)
                        }

                        Text {
                            text: model.action
                            color: index < 4 ? Theme.foreground : Theme.muted
                            font.pixelSize: 12
                            Layout.fillWidth: true
                        }

                        Rectangle {
                            visible: model.track !== "—"
                            Layout.preferredWidth: trackLabel.width + 8
                            height: 18
                            radius: 3
                            color: Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.15)
                            Text {
                                id: trackLabel
                                anchors.centerIn: parent
                                text: model.track
                                color: Theme.accent
                                font.pixelSize: 9
                            }
                        }

                        Text {
                            text: model.time
                            color: Theme.muted
                            font.pixelSize: 10
                            font.family: "monospace"
                        }
                    }
                }
            }

            // Node View (placeholder)
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Theme.background

                Canvas {
                    anchors.fill: parent
                    anchors.margins: 20
                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.clearRect(0, 0, width, height);
                        ctx.fillStyle = Qt.rgba(0.2, 0.2, 0.25, 0.3);
                        for (var x = 0; x < width; x += 30)
                            for (var y = 0; y < height; y += 30) {
                                ctx.beginPath();
                                ctx.arc(x, y, 1, 0, 2 * Math.PI);
                                ctx.fill();
                            }
                    }
                }

                // History nodes
                Column {
                    anchors.centerIn: parent
                    spacing: 24

                    Repeater {
                        model: ["Project Created", "Import Media", "Edit Timeline", "Color Grade", "Audio Mix"]
                        Row {
                            spacing: 12
                            Rectangle {
                                width: 160
                                height: 48
                                radius: 8
                                color: Theme.secondary
                                border.width: 1
                                border.color: index === 3 ? Theme.primary : Theme.border
                                Text {
                                    anchors.centerIn: parent
                                    text: modelData
                                    color: Theme.foreground
                                    font.pixelSize: 12
                                }
                            }

                            // Connection line
                            Rectangle {
                                visible: index < 4
                                width: 40
                                height: 2
                                color: Theme.muted
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Rectangle {
                                visible: index < 4
                                width: 8
                                height: 8
                                radius: 4
                                color: Theme.accent
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                }
            }
        }
    }
}
