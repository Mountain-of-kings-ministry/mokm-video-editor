import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../core"

Item {
    id: exportWorkspace
    anchors.fill: parent

    SplitView {
        anchors.fill: parent
        orientation: Qt.Horizontal

        // Left: Preset Manager & Settings
        Rectangle {
            SplitView.preferredWidth: 350
            SplitView.minimumWidth: 250
            color: Theme.found

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Theme.paddingMedium

                Text {
                    text: "Render Settings"
                    color: Theme.sovereign
                    font: Theme.headerFont
                    Layout.fillWidth: true
                }
                
                // Form
                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    rowSpacing: Theme.paddingSmall
                    columnSpacing: Theme.paddingSmall
                    
                    Text { text: "Preset:"; color: Theme.textSecondary; font: Theme.smallFont }
                    ComboBox {
                        Layout.fillWidth: true
                        model: ["YouTube 1080p", "YouTube 4K", "ProRes HQ", "Custom FFmpeg"]
                    }
                    
                    Text { text: "File Name:"; color: Theme.textSecondary; font: Theme.smallFont }
                    TextField {
                        Layout.fillWidth: true
                        text: "Final_Edit_v1"
                    }
                    
                    Text { text: "Location:"; color: Theme.textSecondary; font: Theme.smallFont }
                    RowLayout {
                        Layout.fillWidth: true
                        TextField {
                            Layout.fillWidth: true
                            text: "~/Videos/Exports"
                        }
                        Button {
                            text: "..."
                        }
                    }
                }
                
                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Theme.panel
                    Layout.topMargin: Theme.paddingMedium
                    Layout.bottomMargin: Theme.paddingMedium
                }
                
                Text {
                    text: "Video Settings"
                    color: Theme.textPrimary
                    font: Theme.defaultFont
                }
                
                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    rowSpacing: Theme.paddingSmall
                    columnSpacing: Theme.paddingSmall
                    
                    Text { text: "Format:"; color: Theme.textSecondary; font: Theme.smallFont }
                    ComboBox { Layout.fillWidth: true; model: ["MP4", "MOV", "MKV"] }
                    
                    Text { text: "Codec:"; color: Theme.textSecondary; font: Theme.smallFont }
                    ComboBox { Layout.fillWidth: true; model: ["H.265 (NVENC)", "H.264", "ProRes"] }
                    
                    Text { text: "Resolution:"; color: Theme.textSecondary; font: Theme.smallFont }
                    ComboBox { Layout.fillWidth: true; model: ["1920x1080", "3840x2160"] }
                }

                Item { Layout.fillHeight: true } // Spacer
                
                Button {
                    Layout.fillWidth: true
                    text: "Add to Render Queue"
                    font.bold: true
                    background: Rectangle {
                        color: Theme.sovereign
                        radius: Theme.radius
                    }
                    contentItem: Text {
                        text: parent.text
                        font: parent.font
                        color: Theme.surface
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }

        // Right: Render Queue
        Rectangle {
            SplitView.fillWidth: true
            color: Theme.surface

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Theme.paddingMedium

                Text {
                    text: "Render Queue"
                    color: Theme.textPrimary
                    font: Theme.headerFont
                    Layout.fillWidth: true
                }
                
                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: Theme.paddingSmall
                    
                    model: [
                        { name: "Final_Edit_v1.mp4", status: "Rendering...", progress: 0.45 },
                        { name: "Draft_Proxy.mov", status: "Completed", progress: 1.0 },
                        { name: "Audio_Mixdown.wav", status: "Waiting", progress: 0.0 }
                    ]
                    
                    delegate: Rectangle {
                        width: parent.width
                        height: 70
                        color: Theme.panel
                        radius: Theme.radius
                        
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Theme.paddingSmall
                            
                            RowLayout {
                                Layout.fillWidth: true
                                Text {
                                    text: modelData.name
                                    color: Theme.textPrimary
                                    font: Theme.defaultFontBold
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: modelData.status
                                    color: modelData.progress === 1.0 ? Theme.sovereign : Theme.textSecondary
                                    font: Theme.smallFont
                                }
                            }
                            
                            ProgressBar {
                                Layout.fillWidth: true
                                value: modelData.progress
                                background: Rectangle {
                                    color: Theme.found
                                    radius: 2
                                }
                                contentItem: Item {
                                    Rectangle {
                                        width: parent.value * parent.width
                                        height: parent.height
                                        color: modelData.progress === 1.0 ? Theme.sovereign : Theme.glimmer
                                        radius: 2
                                    }
                                }
                            }
                        }
                    }
                }
                
                Button {
                    Layout.alignment: Qt.AlignRight
                    text: "Start All"
                    background: Rectangle {
                        color: Theme.highlight
                        radius: Theme.radius
                    }
                    contentItem: Text {
                        text: parent.text
                        font: parent.font
                        color: Theme.surface
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
    }
}
