import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import mokm_video_editor
import QtQuick.Effects

Item {
    id: settingsPage

    property int selectedCategory: 0

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Left panel - Settings categories
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
                    title: "SETTINGS"
                }

                ListView {
                    id: categoryList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.margins: 6
                    clip: true
                    spacing: 2

                    model: ListModel {
                        ListElement {
                            name: "General"
                            icon: "qrc:/icons/outline/settings.svg"
                        }
                        ListElement {
                            name: "Proxy"
                            icon: "qrc:/icons/outline/arrows-exchange.svg"
                        }
                        ListElement {
                            name: "Playback"
                            icon: "qrc:/icons/outline/player-play.svg"
                        }
                        ListElement {
                            name: "Timeline"
                            icon: "qrc:/icons/outline/layout-rows.svg"
                        }
                        ListElement {
                            name: "Shortcuts"
                            icon: "qrc:/icons/outline/keyboard.svg"
                        }
                        ListElement {
                            name: "Appearance"
                            icon: "qrc:/icons/outline/palette.svg"
                        }
                        ListElement {
                            name: "Performance"
                            icon: "qrc:/icons/outline/gauge.svg"
                        }
                        ListElement {
                            name: "Plugins"
                            icon: "qrc:/icons/outline/puzzle.svg"
                        }
                        ListElement {
                            name: "About"
                            icon: "qrc:/icons/outline/info-circle.svg"
                        }
                    }

                    delegate: Rectangle {
                        width: ListView.view.width
                        height: 36
                        radius: 6
                        color: settingsPage.selectedCategory === index ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.12) : "transparent"

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 8
                            Image {
                                source: model.icon
                                width: 16
                                height: 16
                                sourceSize: Qt.size(16, 16)
                                opacity: settingsPage.selectedCategory === index ? 0.9 : 0.4
                                layer.enabled: true
                                layer.effect: MultiEffect {
                                    colorization: 1.0
                                    colorizationColor: settingsPage.selectedCategory === index ? Theme.primary : (mouseArea.containsMouse ? Theme.foreground : "#8c8c8c")
                                    brightness: 1.0
                                }
                            }
                            Text {
                                text: model.name
                                Layout.fillWidth: true
                                color: settingsPage.selectedCategory === index ? Theme.primary : Theme.foreground
                                font.pixelSize: 12
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: settingsPage.selectedCategory = index
                        }
                    }
                }
            }
        }

        // Right panel - Settings detail
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            PanelHeader {
                Layout.fillWidth: true
                title: {
                    var names = ["GENERAL", "PROXY", "PLAYBACK", "TIMELINE", "SHORTCUTS", "APPEARANCE", "PERFORMANCE", "PLUGINS", "ABOUT"];
                    return names[settingsPage.selectedCategory] || "GENERAL";
                }
                accentColor: Theme.primary
            }

            Flickable {
                Layout.fillWidth: true
                Layout.fillHeight: true
                contentHeight: settingsContent.height
                clip: true

                Column {
                    id: settingsContent
                    width: parent.width
                    spacing: 12
                    padding: 16

                    // Settings rows
                    Repeater {
                        model: ListModel {
                            ListElement {
                                label: "Auto-save interval"
                                value: "5 minutes"
                                settingType: "dropdown"
                            }
                            ListElement {
                                label: "Default project location"
                                value: "~/Projects"
                                settingType: "path"
                            }
                            ListElement {
                                label: "Undo history limit"
                                value: "100"
                                settingType: "number"
                            }
                            ListElement {
                                label: "Hardware acceleration"
                                value: "Enabled"
                                settingType: "toggle"
                            }
                            ListElement {
                                label: "Proxy auto-generation"
                                value: "On Import"
                                settingType: "dropdown"
                            }
                            ListElement {
                                label: "Preview quality"
                                value: "Full"
                                settingType: "dropdown"
                            }
                            ListElement {
                                label: "Show welcome screen"
                                value: "true"
                                settingType: "toggle"
                            }
                            ListElement {
                                label: "Cache size limit"
                                value: "8 GB"
                                settingType: "number"
                            }
                        }

                        Rectangle {
                            width: parent.width - 32
                            height: 44
                            radius: 6
                            color: Theme.secondary

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 12
                                spacing: 12

                                Text {
                                    text: model.label
                                    color: Theme.foreground
                                    font.pixelSize: 12
                                    Layout.fillWidth: true
                                }

                                // Toggle-style control
                                Rectangle {
                                    visible: model.settingType === "toggle"
                                    width: 40
                                    height: 22
                                    radius: 11
                                    color: model.value === "true" ? Theme.primary : Theme.muted

                                    Rectangle {
                                        width: 16
                                        height: 16
                                        radius: 8
                                        color: Theme.foreground
                                        x: model.value === "true" ? parent.width - width - 3 : 3
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }

                                // Dropdown-style control
                                Rectangle {
                                    visible: model.settingType === "dropdown"
                                    width: 140
                                    height: 26
                                    radius: 4
                                    color: Theme.background
                                    border.width: 1
                                    border.color: Theme.border

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 6
                                        Text {
                                            text: model.value
                                            color: Theme.foreground
                                            font.pixelSize: 11
                                            Layout.fillWidth: true
                                        }
                                        Image {
                                            source: "qrc:/icons/outline/chevron-down.svg"
                                            width: 10
                                            height: 10
                                            sourceSize: Qt.size(10, 10)
                                            opacity: 0.4
                                            layer.enabled: true
                                            layer.effect: MultiEffect {
                                                colorization: 1.0
                                                colorizationColor: settingsPage.selectedCategory === index ? Theme.primary : (mouseArea.containsMouse ? Theme.foreground : "#8c8c8c")
                                                brightness: 1.0
                                            }
                                        }
                                    }
                                }

                                // Number / Path control
                                Rectangle {
                                    visible: model.settingType === "number" || model.settingType === "path"
                                    width: 140
                                    height: 26
                                    radius: 4
                                    color: Theme.background
                                    border.width: 1
                                    border.color: Theme.border

                                    Text {
                                        anchors.left: parent.left
                                        anchors.leftMargin: 8
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: model.value
                                        color: Theme.foreground
                                        font.pixelSize: 11
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
