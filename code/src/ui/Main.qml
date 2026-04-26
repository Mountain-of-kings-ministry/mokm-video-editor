import QtQuick
import QtQuick.Controls
import QtQuick.Controls.impl
import QtQuick.Layouts
import "project_settings"
import "preferences"
import "proxy_manager"
import "plugin_manager"
import "keyboard_shortcuts"
import untitled

ApplicationWindow {
    id: mainWindow
    width: 1280
    height: 720
    visible: true
    title: qsTr("MOKM Video Editor")
    color: Theme.surface

    Component.onCompleted: {
        console.log("Main UI Loaded")
        console.log("Theme Surface Color: " + Theme.surface)
    }

    // Instantiate Modals
    PreferencesModal { id: preferencesModal }
    ProjectSettingsModal { id: projectSettingsModal }
    ProxyDashboard { id: proxyDashboard }
    PluginManagerModal { id: pluginManagerModal }
    ShortcutMapper { id: shortcutMapperModal }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Global Navigation Rail
        Rectangle {
            id: navRail
            Layout.fillHeight: true
            Layout.preferredWidth: 60
            color: Theme.found

            ColumnLayout {
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Theme.paddingMedium
                anchors.topMargin: Theme.paddingMedium

                Repeater {
                    model: [
                        { name: "Media", icon: "folder.svg", workspace: "mediaBin" },
                        { name: "Edit", icon: "cut.svg", workspace: "videoEditor" },
                        { name: "Nodes", icon: "chart-arcs.svg", workspace: "nodeEditor" },
                        { name: "Color", icon: "color-filter.svg", workspace: "colorGrading" },
                        { name: "Audio", icon: "headphones.svg", workspace: "audioMixing" },
                        { name: "Export", icon: "rocket.svg", workspace: "exportPage" }
                    ]
                    delegate: ToolButton {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: 48
                        Layout.preferredHeight: 48
                        
                        background: Rectangle {
                            color: workspaceLoader.currentWorkspace === modelData.workspace ? Theme.glimmer : "transparent"
                            radius: Theme.radius
                        }
                        
                        contentItem: ColumnLayout {
                            spacing: 0
                            IconImage {
                                color: workspaceLoader.currentWorkspace === modelData.workspace ? Theme.surface : Theme.textSecondary
                                source: "icons/outline/" + modelData.icon
                                Layout.alignment: Qt.AlignHCenter
                                Layout.preferredWidth: 24
                                Layout.preferredHeight: 24
                                sourceSize.width: 24
                                sourceSize.height: 24
                                fillMode: Image.PreserveAspectFit
                            }
                            Text {
                                text: modelData.name
                                color: workspaceLoader.currentWorkspace === modelData.workspace ? Theme.surface : Theme.textSecondary
                                font: Theme.smallFont
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }

                        onClicked: workspaceLoader.currentWorkspace = modelData.workspace
                    }
                }
            }
            
            // Bottom system settings
            ColumnLayout {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Theme.paddingMedium
                anchors.bottomMargin: Theme.paddingMedium

                ToolButton {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 48
                    Layout.preferredHeight: 48
                    
                    background: Rectangle {
                        color: "transparent"
                        radius: Theme.radius
                    }
                    
                    contentItem: ColumnLayout {
                        spacing: 0
                        IconImage {

                            color: Theme.textSecondary; source: "icons/outline/settings.svg"
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredWidth: 24
                            Layout.preferredHeight: 24
                            sourceSize.width: 24
                            sourceSize.height: 24
                            fillMode: Image.PreserveAspectFit
                        }
                        Text {
                            text: "Settings"
                            color: Theme.textSecondary
                            font: Theme.smallFont
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                    
                    onClicked: {
                        menu.open()
                    }
                    
                    Menu {
                        id: menu
                        y: -height
                        MenuItem { text: "Project Settings"; onClicked: projectSettingsModal.open() }
                        MenuItem { text: "Preferences"; onClicked: preferencesModal.open() }
                        MenuItem { text: "Proxy Manager"; onClicked: proxyDashboard.open() }
                        MenuItem { text: "Plugin Manager"; onClicked: pluginManagerModal.open() }
                        MenuItem { text: "Keyboard Shortcuts"; onClicked: shortcutMapperModal.open() }
                    }
                }
            }
        }

        // Workspace Container
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Theme.surface

            Loader {
                id: workspaceLoader
                anchors.fill: parent
                property string currentWorkspace: "videoEditor"

                source: {
                    switch (currentWorkspace) {
                        case "mediaBin": return "media_bin/MediaBinWorkspace.qml"
                        case "videoEditor": return "video_editor/VideoEditorWorkspace.qml"
                        case "nodeEditor": return "node_editor/NodeEditorWorkspace.qml"
                        case "colorGrading": return "color_grading_editor/ColorGradingWorkspace.qml"
                        case "audioMixing": return "audio_editor/AudioMixingWorkspace.qml"
                        case "exportPage": return "export_page/ExportWorkspace.qml"
                        default: return ""
                    }
                }
            }
        }
    }
}
