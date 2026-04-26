import QtQuick
import QtQuick.Controls
import QtQuick.Controls.impl
import QtQuick.Layouts
import "../core"

Item {
    id: colorGradingWorkspace
    anchors.fill: parent

    SplitView {
        anchors.fill: parent
        orientation: Qt.Vertical

        // Top half: Video Viewer & Scopes
        SplitView {
            SplitView.fillHeight: true
            orientation: Qt.Horizontal

            // Color Viewer
            Rectangle {
                SplitView.fillWidth: true
                color: Theme.found
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Theme.paddingSmall
                    
                    Text {
                        text: "Viewer"
                        color: Theme.sovereign
                        font: Theme.smallFont
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Theme.surface
                        
                        IconImage {

                        
                            color: Theme.textSecondary; anchors.centerIn: parent
                            source: "../icons/outline/color-filter.svg"
                            width: 64; height: 64
                            opacity: 0.3
                        }
                    }
                }
            }

            // Video Scopes
            Rectangle {
                SplitView.preferredWidth: 400
                color: Theme.found
                border.color: Theme.panel
                border.width: 1
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Theme.paddingSmall
                    
                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: "Video Scopes"
                            color: Theme.textPrimary
                            font: Theme.smallFont
                            Layout.fillWidth: true
                        }
                        ComboBox {
                            model: ["Waveform", "Parade", "Vectorscope", "Histogram"]
                            font: Theme.smallFont
                        }
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Theme.surface
                        
                        Text {
                            anchors.centerIn: parent
                            text: "[ Scope Graph Placeholder ]"
                            color: Theme.textSecondary
                            font: Theme.defaultFont
                        }
                    }
                }
            }
        }

        // Bottom half: Grading Wheels & Curves
        Rectangle {
            SplitView.preferredHeight: 300
            SplitView.minimumHeight: 200
            color: Theme.surface

            RowLayout {
                anchors.fill: parent
                anchors.margins: Theme.paddingMedium
                spacing: Theme.paddingLarge

                component ColorWheel: ColumnLayout {
                    property string title: "Wheel"
                    spacing: Theme.paddingSmall
                    
                    Text {
                        text: title
                        color: Theme.textPrimary
                        font: Theme.defaultFont
                        Layout.alignment: Qt.AlignHCenter
                    }
                    
                    Rectangle {
                        Layout.preferredWidth: 120
                        Layout.preferredHeight: 120
                        radius: 60
                        color: Theme.panel
                        border.color: Theme.found
                        border.width: 4
                        Layout.alignment: Qt.AlignHCenter
                        
                        // Center crosshair
                        Rectangle {
                            anchors.centerIn: parent
                            width: 10; height: 10
                            radius: 5
                            color: Theme.textPrimary
                        }
                    }
                    
                    // Value slider
                    Slider {
                        Layout.preferredWidth: 120
                        Layout.alignment: Qt.AlignHCenter
                        value: 0.5
                    }
                }

                Item { Layout.fillWidth: true } // spacer
                
                ColorWheel { title: "Lift" }
                ColorWheel { title: "Gamma" }
                ColorWheel { title: "Gain" }
                ColorWheel { title: "Offset" }
                
                Item { Layout.fillWidth: true } // spacer
            }
        }
    }
}
