import QtQuick
import QtQuick.Controls
import QtQuick.Controls.impl
import QtQuick.Layouts
import Mokm.Timeline 1.0
import untitled

Item {
    id: videoEditorWorkspace
    anchors.fill: parent

    // Pixels per frame for timeline scaling
    property double pixelsPerFrame: 2.0

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
                            color: Theme.textSecondary
                            anchors.centerIn: parent
                            source: "../icons/outline/player-play.svg"
                            width: 64; height: 64
                            opacity: 0.3
                        }
                    }
                    // Transport controls
                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        ToolButton {
                            icon.source: "../icons/outline/player-skip-back.svg"
                            icon.color: Theme.textPrimary
                            onClicked: PlayheadController.goToStart()
                        }
                        ToolButton {
                            icon.source: PlayheadController.isPlaying ? "../icons/outline/player-pause.svg" : "../icons/outline/player-play.svg"
                            icon.color: Theme.textPrimary
                            onClicked: PlayheadController.togglePlayPause()
                        }
                        ToolButton {
                            icon.source: "../icons/outline/player-skip-forward.svg"
                            icon.color: Theme.textPrimary
                            onClicked: PlayheadController.goToEnd()
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
                            color: Theme.textSecondary
                            anchors.centerIn: parent
                            source: "../icons/outline/video.svg"
                            width: 64; height: 64
                            opacity: 0.3
                        }
                        
                        // Frame counter overlay
                        Text {
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            anchors.margins: 8
                            text: "Frame: " + PlayheadController.currentFrame
                            color: Theme.textSecondary
                            font: Theme.smallFont
                        }
                    }
                    // Transport controls
                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        ToolButton {
                            icon.source: "../icons/outline/player-skip-back.svg"
                            icon.color: Theme.textPrimary
                            onClicked: PlayheadController.stepBackward(10)
                        }
                        ToolButton {
                            icon.source: PlayheadController.isPlaying ? "../icons/outline/player-pause.svg" : "../icons/outline/player-play.svg"
                            icon.color: Theme.textPrimary
                            onClicked: PlayheadController.togglePlayPause()
                        }
                        ToolButton {
                            icon.source: "../icons/outline/player-skip-forward.svg"
                            icon.color: Theme.textPrimary
                            onClicked: PlayheadController.stepForward(10)
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
                                Text { 
                                    text: formatTimecode(PlayheadController.currentFrame, PlayheadController.fps)
                                    color: Theme.textSecondary
                                    font: Theme.smallFont
                                }
                                Item { Layout.fillWidth: true }
                                Text { text: "00:01:00:00"; color: Theme.textSecondary; font: Theme.smallFont }
                                Item { Layout.fillWidth: true }
                            }
                        }
                        
                        // Tracks - data-driven from TimelineModel
                        ScrollView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            
                            ColumnLayout {
                                width: parent.width
                                spacing: 2
                                
                                Repeater {
                                    model: TimelineModel
                                    
                                    delegate: RowLayout {
                                        width: parent.width
                                        height: model.height
                                        
                                        // Track header
                                        Rectangle {
                                            Layout.preferredWidth: 100
                                            Layout.fillHeight: true
                                            color: Theme.panel
                                            
                                            Text {
                                                anchors.centerIn: parent
                                                text: model.name
                                                color: Theme.textPrimary
                                                font: Theme.smallFontBold
                                            }
                                        }
                                        
                                        // Track content area with clips
                                        Rectangle {
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true
                                            color: Theme.surface
                                            
                                            // Nested Repeater for clips within this track
                                            Repeater {
                                                model: model.clips
                                                
                                                delegate: Rectangle {
                                                    x: startFrame * pixelsPerFrame
                                                    width: durationFrames * pixelsPerFrame
                                                    height: parent.height - 4
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    radius: 4
                                                    color: clipColor || (isAudio ? "#2E5B50" : Theme.glimmer)
                                                    border.color: Theme.highlight
                                                    border.width: 0
                                                    
                                                    // Clip label
                                                    Text {
                                                        anchors.centerIn: parent
                                                        text: mediaName || "Clip"
                                                        color: isAudio ? Theme.textPrimary : Theme.surface
                                                        font: Theme.smallFont
                                                        elide: Text.ElideRight
                                                        width: parent.width - 8
                                                        horizontalAlignment: Text.AlignHCenter
                                                    }
                                                    
                                                    MouseArea {
                                                        anchors.fill: parent
                                                        onClicked: {
                                                            console.log("Selected clip:", clipId, "on track:", trackIndex)
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
                    
                    // Playhead indicator - bound to PlayheadController
                    Rectangle {
                        x: 100 + (PlayheadController.currentFrame * pixelsPerFrame)
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

    // Timecode formatter helper
    function formatTimecode(frame, fps) {
        if (fps <= 0) fps = 24.0
        var totalSeconds = frame / fps
        var hours = Math.floor(totalSeconds / 3600)
        var minutes = Math.floor((totalSeconds % 3600) / 60)
        var seconds = Math.floor(totalSeconds % 60)
        var frames = Math.floor((totalSeconds - Math.floor(totalSeconds)) * fps)
        
        return pad(hours) + ":" + pad(minutes) + ":" + pad(seconds) + ":" + pad(frames)
    }
    
    function pad(n) {
        return n < 10 ? "0" + n : n
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
