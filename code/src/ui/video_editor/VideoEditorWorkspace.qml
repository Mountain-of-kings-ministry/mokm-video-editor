import QtQuick
import QtQuick.Controls
import QtQuick.Controls.impl
import QtQuick.Layouts
import "../core"

Item {
    id: videoEditorWorkspace
    anchors.fill: parent

    SplitView {
        anchors.fill: parent
        orientation: Qt.Vertical

        // Top half: Monitors
        SplitView {
            SplitView.fillHeight: true
            orientation: Qt.Horizontal

            // Source Monitor
            Rectangle {
                SplitView.fillWidth: true
                color: Theme.found
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Theme.paddingSmall

                    Text {
                        text: "Source Monitor"
                        color: Theme.textSecondary
                        font: Theme.smallFont
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Theme.surface
                        
                        IconImage {

                        
                            color: Theme.textSecondary; anchors.centerIn: parent
                            source: "../icons/outline/player-play.svg"
                            width: 64; height: 64
                            opacity: 0.3
                        }
                    }
                    // Transport controls
                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        Repeater {
                            model: ["player-skip-back.svg", "player-play.svg", "player-skip-forward.svg"]
                            delegate: ToolButton {
                                icon.source: "../icons/outline/" + modelData
                                icon.color: Theme.textPrimary
                            }
                        }
                    }
                }
            }

            // Program Monitor
            Rectangle {
                SplitView.fillWidth: true
                color: Theme.found
                
                border.color: Theme.sovereign
                border.width: 1
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Theme.paddingSmall

                    RowLayout {
                        Text {
                            text: "Program Monitor"
                            color: Theme.sovereign
                            font: Theme.smallFont
                            Layout.fillWidth: true
                        }
                        // Proxy Toggle Indicator
                        Rectangle {
                            width: 60
                            height: 20
                            radius: 10
                            color: Theme.sovereign
                            Text {
                                anchors.centerIn: parent
                                text: "PROXY"
                                color: Theme.surface
                                font: Theme.smallFontBold
                            }
                        }
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Theme.surface
                        
                        IconImage {

                        
                            color: Theme.textSecondary; anchors.centerIn: parent
                            source: "../icons/outline/video.svg"
                            width: 64; height: 64
                            opacity: 0.3
                        }
                    }
                    // Transport controls
                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        Repeater {
                            model: ["player-skip-back.svg", "player-play.svg", "player-skip-forward.svg"]
                            delegate: ToolButton {
                                icon.source: "../icons/outline/" + modelData
                                icon.color: Theme.textPrimary
                            }
                        }
                    }
                }
            }
        }

        // Bottom half: Toolbar + Timeline
        Rectangle {
            SplitView.preferredHeight: 300
            SplitView.minimumHeight: 150
            color: Theme.surface

            RowLayout {
                anchors.fill: parent
                spacing: 0

                // Tool Palette
                Rectangle {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 40
                    color: Theme.found
                    
                    ColumnLayout {
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.topMargin: Theme.paddingMedium
                        
                        Repeater {
                            model: ["pointer.svg", "cut.svg", "arrows-left-right.svg", "magnet.svg"]
                            delegate: ToolButton {
                                icon.source: "../icons/outline/" + modelData
                                icon.color: index === 0 ? Theme.highlight : Theme.textPrimary
                                background: Rectangle {
                                    color: index === 0 ? Theme.panel : "transparent"
                                    radius: Theme.radius
                                }
                            }
                        }
                    }
                }

                // Timeline
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Theme.found
                    
                    ColumnLayout {
                        anchors.fill: parent
                        
                        // Time ruler
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 30
                            color: Theme.panel
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 100
                                Text { text: "00:00:00:00"; color: Theme.textSecondary; font: Theme.smallFont }
                                Item { Layout.fillWidth: true }
                                Text { text: "00:01:00:00"; color: Theme.textSecondary; font: Theme.smallFont }
                                Item { Layout.fillWidth: true }
                            }
                        }
                        
                        // Tracks
                        ScrollView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            
                            ColumnLayout {
                                width: parent.width
                                spacing: 2
                                
                                // Video Track 2
                                RowLayout {
                                    width: parent.width; height: 50
                                    Rectangle { width: 100; height: parent.height; color: Theme.panel; Text { text:"V2"; anchors.centerIn:parent; color:Theme.textPrimary }}
                                    Rectangle { Layout.fillWidth: true; height: parent.height; color: Theme.surface
                                        Rectangle { x: 200; width: 150; height: parent.height-4; anchors.verticalCenter: parent.verticalCenter; radius: 4; color: Theme.glimmer; border.color: Theme.highlight; Text { text:"Title"; anchors.centerIn:parent; color:Theme.surface }}
                                    }
                                }
                                // Video Track 1
                                RowLayout {
                                    width: parent.width; height: 50
                                    Rectangle { width: 100; height: parent.height; color: Theme.panel; Text { text:"V1"; anchors.centerIn:parent; color:Theme.textPrimary }}
                                    Rectangle { Layout.fillWidth: true; height: parent.height; color: Theme.surface
                                        Rectangle { x: 50; width: 300; height: parent.height-4; anchors.verticalCenter: parent.verticalCenter; radius: 4; color: Theme.glimmer; Text { text:"Main Clip.mp4"; anchors.centerIn:parent; color:Theme.surface }}
                                        Rectangle { x: 350; width: 250; height: parent.height-4; anchors.verticalCenter: parent.verticalCenter; radius: 4; color: Qt.darker(Theme.glimmer, 1.2); Text { text:"B-Roll 1.mp4"; anchors.centerIn:parent; color:Theme.surface }}
                                    }
                                }
                                // Audio Track 1
                                RowLayout {
                                    width: parent.width; height: 50
                                    Rectangle { width: 100; height: parent.height; color: Theme.panel; Text { text:"A1"; anchors.centerIn:parent; color:Theme.textPrimary }}
                                    Rectangle { Layout.fillWidth: true; height: parent.height; color: Theme.surface
                                        Rectangle { x: 50; width: 300; height: parent.height-4; anchors.verticalCenter: parent.verticalCenter; radius: 4; color: "#2E5B50"; Text { text:"Main Clip Audio"; anchors.centerIn:parent; color:Theme.textPrimary }}
                                        Rectangle { x: 350; width: 250; height: parent.height-4; anchors.verticalCenter: parent.verticalCenter; radius: 4; color: "#2E5B50"; Text { text:"B-Roll 1 Audio"; anchors.centerIn:parent; color:Theme.textPrimary }}
                                    }
                                }
                            }
                        }
                    }
                    
                    // Playhead indicator
                    Rectangle {
                        x: 180
                        y: 0
                        width: 2
                        height: parent.height
                        color: Theme.highlight
                        
                        Polygon {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                            vertices: [
                                { x: -8, y: 0 },
                                { x: 8, y: 0 },
                                { x: 8, y: 10 },
                                { x: 0, y: 18 },
                                { x: -8, y: 10 }
                            ]
                            color: Theme.highlight
                        }
                    }
                }
            }
        }
    }

    // Dummy Polygon for Playhead triangle
    component Polygon: Canvas {
        id: canvas
        width: 16
        height: 18
        property var vertices: []
        property color color: "red"
        onPaint: {
            var ctx = getContext("2d");
            ctx.fillStyle = color;
            ctx.beginPath();
            if(vertices.length > 0) {
                ctx.moveTo(vertices[0].x + width/2, vertices[0].y);
                for(var i=1; i<vertices.length; i++){
                    ctx.lineTo(vertices[i].x + width/2, vertices[i].y);
                }
            }
            ctx.closePath();
            ctx.fill();
        }
    }
}
