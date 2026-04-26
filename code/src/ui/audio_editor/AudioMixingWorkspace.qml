import QtQuick
import QtQuick.Controls
import QtQuick.Controls.impl
import QtQuick.Layouts
import "../core"

Item {
    id: audioMixingWorkspace
    anchors.fill: parent

    SplitView {
        anchors.fill: parent
        orientation: Qt.Horizontal

        // Left: Track Inspector / Plugins
        Rectangle {
            SplitView.preferredWidth: 300
            SplitView.minimumWidth: 200
            color: Theme.found

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Theme.paddingMedium

                Text {
                    text: "Track Inspector (A1)"
                    color: Theme.sovereign
                    font: Theme.headerFont
                    Layout.fillWidth: true
                }
                
                Rectangle {
                    Layout.fillWidth: true
                    height: 2
                    color: Theme.panel
                }
                
                Text {
                    text: "Audio Effects (VST3 / CLAP)"
                    color: Theme.textSecondary
                    font: Theme.smallFont
                    Layout.topMargin: Theme.paddingSmall
                }
                
                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: ["Dynamics Compressor", "Parametric EQ", "Noise Reduction (Mock)"]
                    delegate: Rectangle {
                        width: parent.width
                        height: 40
                        color: Theme.panel
                        radius: Theme.radius
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: Theme.paddingSmall
                            
                            IconImage {

                            
                                color: Theme.textSecondary; source: "../icons/outline/power.svg"
                                Layout.preferredWidth: 16
                                Layout.preferredHeight: 16
                            }
                            Text {
                                text: modelData
                                color: Theme.textPrimary
                                font: Theme.defaultFont
                                Layout.fillWidth: true
                            }
                            IconImage {

                                color: Theme.textSecondary; source: "../icons/outline/settings.svg"
                                Layout.preferredWidth: 16
                                Layout.preferredHeight: 16
                            }
                        }
                    }
                }
            }
        }

        // Center: Main Mixer
        Rectangle {
            SplitView.fillWidth: true
            color: Theme.surface

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Theme.paddingMedium

                Text {
                    text: "Master Mixer"
                    color: Theme.textPrimary
                    font: Theme.headerFont
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 2
                    
                    component MixerTrack: Rectangle {
                        property string trackName: "A1"
                        property bool isMaster: false
                        
                        Layout.preferredWidth: 100
                        Layout.fillHeight: true
                        color: Theme.found
                        border.color: isMaster ? Theme.sovereign : "transparent"
                        border.width: isMaster ? 1 : 0
                        
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Theme.paddingSmall
                            
                            Text {
                                text: trackName
                                color: isMaster ? Theme.sovereign : Theme.textPrimary
                                font: Theme.defaultFontBold
                                Layout.alignment: Qt.AlignHCenter
                            }
                            
                            // Mock Peak Meter
                            RowLayout {
                                Layout.fillHeight: true
                                Layout.alignment: Qt.AlignHCenter
                                spacing: 4
                                
                                Rectangle {
                                    width: 10; Layout.fillHeight: true; color: Theme.panel
                                    Rectangle { width: 10; height: parent.height * 0.7; anchors.bottom: parent.bottom; color: Theme.glimmer }
                                    Rectangle { width: 10; height: 5; anchors.bottom: parent.bottom; anchors.bottomMargin: parent.height * 0.75; color: "red" }
                                }
                                Rectangle {
                                    width: 10; Layout.fillHeight: true; color: Theme.panel
                                    Rectangle { width: 10; height: parent.height * 0.65; anchors.bottom: parent.bottom; color: Theme.glimmer }
                                    Rectangle { width: 10; height: 5; anchors.bottom: parent.bottom; anchors.bottomMargin: parent.height * 0.70; color: "red" }
                                }
                            }
                            
                            // Fader
                            Slider {
                                orientation: Qt.Vertical
                                Layout.preferredHeight: 150
                                Layout.alignment: Qt.AlignHCenter
                                value: 0.8
                            }
                            
                            RowLayout {
                                Layout.alignment: Qt.AlignHCenter
                                Button { text: "M"; font: Theme.smallFont }
                                Button { text: "S"; font: Theme.smallFont }
                            }
                        }
                    }
                    
                    MixerTrack { trackName: "A1" }
                    MixerTrack { trackName: "A2" }
                    MixerTrack { trackName: "A3" }
                    
                    Item { Layout.fillWidth: true } // spacer
                    
                    MixerTrack { trackName: "Master"; isMaster: true }
                }
            }
        }
    }
}
