pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.impl
import QtQuick.Layouts
import Mokm.Timeline 1.0
import untitled

Item {
    id: videoEditorWorkspace
    anchors.fill: parent

    // Editor state
    property string activeTool: "pointer"
    property string selectedClipId: ""
    property int selectedTrackIndex: -1

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
                            model: [
                                { icon: "pointer.svg", tool: "pointer" },
                                { icon: "cut.svg", tool: "razor" },
                                { icon: "arrows-left-right.svg", tool: "slip" },
                                { icon: "magnet.svg", tool: "snap" }
                            ]
                            delegate: ToolButton {
                                icon.source: "../icons/outline/" + modelData.icon
                                icon.color: videoEditorWorkspace.activeTool === modelData.tool ? Theme.sovereign : Theme.textPrimary
                                background: Rectangle {
                                    color: videoEditorWorkspace.activeTool === modelData.tool ? Theme.panel : "transparent"
                                    radius: Theme.radius
                                }
                                onClicked: videoEditorWorkspace.activeTool = modelData.tool
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
                                    id: trackRepeater
                                    model: TimelineModel
                                    
                                    delegate: RowLayout {
                                        id: trackRow
                                        width: trackRepeater.width
                                        height: trackRow.model.height
                                        
                                        required property var model
                                        required property int index

                                        // Track header
                                        Rectangle {
                                            Layout.preferredWidth: 100
                                            Layout.fillHeight: true
                                            color: Theme.panel
                                            
                                            Text {
                                                anchors.centerIn: parent
                                                text: trackRow.model.name
                                                color: Theme.textPrimary
                                                font: Theme.smallFontBold
                                            }
                                        }
                                        
                                        // Track content area with clips
                                        Rectangle {
                                            id: trackContent
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true
                                            color: Theme.surface
                                            
                                            DropArea {
                                                anchors.fill: parent
                                                onDropped: (drop) => {
                                                    const mediaId = drop.getDataAsString("mediaId")
                                                    const mediaName = drop.getDataAsString("mediaName")
                                                    const durationSecs = parseFloat(drop.getDataAsString("durationSeconds") || "0")
                                                    const fps = PlayheadController.fps || 24.0
                                                    const durationFrames = durationSecs * fps
                                                    const dropFrame = Math.max(0, Math.floor(drop.x / videoEditorWorkspace.pixelsPerFrame))
                                                    
                                                    Mokm.Core.UndoManager.addClip(trackRow.index, mediaId, mediaName, dropFrame, durationFrames)
                                                }
                                            }

                                            // Nested Repeater for clips within this track
                                            Repeater {
                                                id: clipRepeater
                                                model: trackRow.model.clips
                                                
                                                delegate: Rectangle {
                                                    id: clipRect
                                                    
                                                    required property var model
                                                    
                                                    x: clipRect.model.startFrame * videoEditorWorkspace.pixelsPerFrame
                                                    width: clipRect.model.durationFrames * videoEditorWorkspace.pixelsPerFrame
                                                    height: trackContent.height - 4
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    radius: 4
                                                    color: clipRect.model.clipColor || (trackRow.model.isAudio ? "#2E5B50" : Theme.glimmer)
                                                    border.color: Theme.highlight
                                                    border.width: (videoEditorWorkspace.selectedClipId === clipRect.model.clipId) ? 2 : 0
                                                    
                                                    // Clip label
                                                    Text {
                                                        anchors.centerIn: parent
                                                        text: clipRect.model.mediaName || "Clip"
                                                        color: trackRow.model.isAudio ? Theme.textPrimary : Theme.surface
                                                        font: Theme.smallFont
                                                        elide: Text.ElideRight
                                                        width: clipRect.width - 8
                                                        horizontalAlignment: Text.AlignHCenter
                                                    }
                                                    
                                                    MouseArea {
                                                        id: clipMouseArea
                                                        anchors.fill: parent
                                                        
                                                        property double dragStartFrame: 0

                                                        onPressed: (mouse) => {
                                                            videoEditorWorkspace.selectedClipId = clipRect.model.clipId
                                                            videoEditorWorkspace.selectedTrackIndex = trackRow.index
                                                            dragStartFrame = clipRect.model.startFrame
                                                        }

                                                        onReleased: (mouse) => {
                                                            if (videoEditorWorkspace.activeTool === "pointer") {
                                                                const newFrame = Math.max(0, dragStartFrame + (mouse.x / videoEditorWorkspace.pixelsPerFrame))
                                                                if (Math.abs(newFrame - dragStartFrame) > 0.1) {
                                                                    Mokm.Core.UndoManager.moveClip(trackRow.index, trackRow.index, clipRect.model.clipId, newFrame)
                                                                }
                                                            } else if (videoEditorWorkspace.activeTool === "razor") {
                                                                const splitFrame = clipRect.model.startFrame + (mouse.x / videoEditorWorkspace.pixelsPerFrame)
                                                                Mokm.Core.UndoManager.splitClip(trackRow.index, clipRect.model.clipId, splitFrame)
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
