import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../core"

Rectangle {
    id: keyframeEditor
    width: 600
    height: 300
    color: Theme.surface
    border.color: Theme.panel
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Toolbar
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            color: Theme.found
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: Theme.paddingSmall
                
                Text {
                    text: "Keyframe Editor (Zoom)"
                    color: Theme.sovereign
                    font: Theme.smallFontBold
                }
                
                Item { Layout.fillWidth: true }
                
                ToolButton { icon.source: "../icons/outline/focus-2.svg" }
                ToolButton { icon.source: "../icons/outline/chart-dots.svg" }
                ToolButton { icon.source: "../icons/outline/line.svg" }
            }
        }

        // Graph Area
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Theme.surface
            clip: true

            // Grid lines
            Grid {
                anchors.fill: parent
                rows: parent.height / 20
                columns: parent.width / 40
                Repeater {
                    model: parent.rows * parent.columns
                    delegate: Rectangle {
                        width: 40; height: 20
                        color: "transparent"
                        border.color: Qt.rgba(255, 255, 255, 0.05)
                        border.width: 1
                    }
                }
            }

            // Mock Bezier Curve Path
            Canvas {
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.strokeStyle = Theme.glimmer;
                    ctx.lineWidth = 2;
                    ctx.beginPath();
                    ctx.moveTo(0, height);
                    ctx.bezierCurveTo(width * 0.3, height, width * 0.5, height * 0.2, width, height * 0.2);
                    ctx.stroke();
                    
                    // Draw keyframe nodes
                    ctx.fillStyle = Theme.highlight;
                    ctx.beginPath();
                    ctx.arc(0, height, 5, 0, 2 * Math.PI);
                    ctx.fill();
                    
                    ctx.beginPath();
                    ctx.arc(width * 0.5, height * 0.2, 5, 0, 2 * Math.PI);
                    ctx.fill();
                    
                    ctx.beginPath();
                    ctx.arc(width, height * 0.2, 5, 0, 2 * Math.PI);
                    ctx.fill();
                }
                Component.onCompleted: requestPaint()
            }
        }
    }
}
