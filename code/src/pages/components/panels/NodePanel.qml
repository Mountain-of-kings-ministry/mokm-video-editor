import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import mokm_video_editor

Rectangle {
    id: root
    color: Theme.background

    property int selectedTrackIndex: -1
    property string selectedTrackName: ""

    // Node canvas area
    Flickable {
        id: nodeFlickable
        anchors.fill: parent
        clip: true
        contentWidth: Math.max(width, nodeCanvas.width)
        contentHeight: Math.max(height, nodeCanvas.height)

        Rectangle {
            id: nodeCanvas
            width: 2000
            height: 2000
            color: Theme.background

            // Grid pattern
            GridPattern {
                anchors.fill: parent
                gridSize: 20
            }

            // Node placeholder
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 16
                visible: root.selectedTrackIndex < 0

                Image {
                    Layout.alignment: Qt.AlignHCenter
                    source: "qrc:/icons/outline/box.svg"
                    width: 40
                    height: 40
                    sourceSize: Qt.size(40, 40)
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
                    text: "Select a track to edit nodes"
                    color: Theme.muted
                    font.pixelSize: 12
                }
            }

            // Node graph (shown when track selected)
            Item {
                anchors.fill: parent
                visible: root.selectedTrackIndex >= 0

                // Input node
                Rectangle {
                    x: 200
                    y: 300
                    width: 140
                    height: 80
                    radius: 6
                    color: Theme.secondary
                    border.width: 1
                    border.color: Theme.border

                    Text {
                        anchors.top: parent.top
                        anchors.topMargin: 6
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Input"
                        color: Theme.foreground
                        font.pixelSize: 10
                        font.weight: Font.Medium
                    }

                    Text {
                        anchors.centerIn: parent
                        text: root.selectedTrackName
                        color: Theme.primary
                        font.pixelSize: 11
                    }

                    // Output socket
                    NodeSocket {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        socketType: NodeSocket.Output
                    }
                }

                // Output node
                Rectangle {
                    x: 500
                    y: 300
                    width: 140
                    height: 80
                    radius: 6
                    color: Theme.secondary
                    border.width: 1
                    border.color: Theme.border

                    Text {
                        anchors.top: parent.top
                        anchors.topMargin: 6
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Output"
                        color: Theme.foreground
                        font.pixelSize: 10
                        font.weight: Font.Medium
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Timeline"
                        color: Theme.accent
                        font.pixelSize: 11
                    }

                    // Input socket
                    NodeSocket {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        socketType: NodeSocket.Input
                    }
                }
            }
        }
    }

    // Grid pattern component
    component GridPattern: Item {
        property int gridSize: 20

        Canvas {
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d")
                ctx.strokeStyle = Theme.border.toString()
                ctx.globalAlpha = 0.15
                ctx.lineWidth = 0.5

                for (var x = 0; x < width; x += gridSize) {
                    ctx.beginPath()
                    ctx.moveTo(x, 0)
                    ctx.lineTo(x, height)
                    ctx.stroke()
                }

                for (var y = 0; y < height; y += gridSize) {
                    ctx.beginPath()
                    ctx.moveTo(0, y)
                    ctx.lineTo(width, y)
                    ctx.stroke()
                }
            }
        }
    }
}
