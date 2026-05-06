import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Rectangle {
    id: root
    color: Theme.background

    property int selectedTrackIndex: -1
    property var selectedClip: null

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Track properties section
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 30
            color: Theme.secondary

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                text: "TRACK"
                color: Theme.mutedForeground
                font.pixelSize: 9
                font.weight: Font.Medium
                font.letterSpacing: 1
            }
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 0

            model: trackModel

            delegate: ItemDelegate {
                width: ListView.view.width
                height: 40
                highlighted: root.selectedTrackIndex === index

                background: Rectangle {
                    color: root.selectedTrackIndex === index ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.1) : "transparent"
                }

                contentItem: RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    spacing: 8

                    Rectangle {
                        Layout.preferredWidth: 4
                        Layout.preferredHeight: 20
                        radius: 2
                        color: model.trackColor
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2

                        Text {
                            text: model.trackName
                            color: Theme.foreground
                            font.pixelSize: 11
                            font.weight: Font.Medium
                        }

                        Text {
                            text: model.trackType
                            color: Theme.mutedForeground
                            font.pixelSize: 9
                        }
                    }

                    // Visibility toggle
                    Rectangle {
                        width: 20
                        height: 20
                        radius: 3
                        color: "transparent"

                        Image {
                            anchors.centerIn: parent
                            source: model.trackVisible ? "qrc:/icons/outline/eye.svg" : "qrc:/icons/outline/eye-off.svg"
                            width: 14
                            height: 14
                            sourceSize: Qt.size(14, 14)
                            layer.enabled: true
                            layer.effect: MultiEffect {
                                colorization: 1.0
                                colorizationColor: Theme.mutedForeground
                                brightness: model.trackVisible ? 1.0 : 0.3
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: trackModel.toggleVisible(index)
                            onEntered: parent.color = Theme.secondaryHover
                            onExited: parent.color = "transparent"
                        }
                    }

                    // Lock toggle
                    Rectangle {
                        width: 20
                        height: 20
                        radius: 3
                        color: "transparent"

                        Image {
                            anchors.centerIn: parent
                            source: model.trackLocked ? "qrc:/icons/outline/lock.svg" : "qrc:/icons/outline/lock-open.svg"
                            width: 14
                            height: 14
                            sourceSize: Qt.size(14, 14)
                            layer.enabled: true
                            layer.effect: MultiEffect {
                                colorization: 1.0
                                colorizationColor: model.trackLocked ? Theme.accent : Theme.mutedForeground
                                brightness: 1.0
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: trackModel.setTrackLocked(index, !model.trackLocked)
                            onEntered: parent.color = Theme.secondaryHover
                            onExited: parent.color = "transparent"
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.selectedTrackIndex = index
                }
            }
        }

        // Empty state
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: trackModel.trackCount === 0

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 12

                Image {
                    Layout.alignment: Qt.AlignHCenter
                    source: "qrc:/icons/outline/adjustments.svg"
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
            }
        }
    }
}
