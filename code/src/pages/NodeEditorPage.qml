import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import mokm_video_editor
import QtQuick.Effects

Item {
    id: nodeEditorPage

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        EditorToolBar {
            Layout.fillWidth: true

            Repeater {
                model: [
                    {
                        icon: "qrc:/icons/outline/plus.svg",
                        tip: "Add Node"
                    },
                    {
                        icon: "qrc:/icons/outline/link.svg",
                        tip: "Connect"
                    },
                    {
                        icon: "qrc:/icons/outline/trash.svg",
                        tip: "Delete"
                    }
                ]
                Rectangle {
                    width: 28
                    height: 28
                    radius: 4
                    color: "transparent"
                    Layout.alignment: Qt.AlignVCenter
                    Image {
                        anchors.centerIn: parent
                        source: modelData.icon
                        width: 16
                        height: 16
                        sourceSize: Qt.size(16, 16)
                        opacity: 0.5
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            colorization: 1.0
                            colorizationColor: modelData.tip === "Add Node" ? Theme.primary : (mouseArea.containsMouse ? Theme.foreground : "#8c8c8c")
                            brightness: 1.0
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: parent.color = Theme.secondaryHover
                        onExited: parent.color = "transparent"
                    }
                }
            }
            Item {
                Layout.fillWidth: true
            }
            Text {
                text: "Node Editor"
                color: Theme.mutedForeground
                font.pixelSize: 12
                Layout.alignment: Qt.AlignVCenter
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Theme.background
            clip: true

            // Dot grid
            Canvas {
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.clearRect(0, 0, width, height);
                    ctx.fillStyle = Qt.rgba(0.2, 0.2, 0.25, 0.3);
                    for (var x = 0; x < width; x += 30)
                        for (var y = 0; y < height; y += 30) {
                            ctx.beginPath();
                            ctx.arc(x, y, 1, 0, 2 * Math.PI);
                            ctx.fill();
                        }
                }
            }

            // Source Node
            Rectangle {
                x: 80
                y: 120
                width: 160
                height: 90
                radius: 8
                color: Theme.secondary
                border.width: 1
                border.color: Theme.border
                z: 2
                PanelHeader {
                    width: parent.width
                    title: "SOURCE"
                    anchors.top: parent.top
                    accentColor: Theme.success
                }
                Text {
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 8
                    text: "scene_01.mp4"
                    color: Theme.mutedForeground
                    font.pixelSize: 11
                }
                NodeSocket {
                    anchors.right: parent.right
                    anchors.rightMargin: -6
                    anchors.verticalCenter: parent.verticalCenter
                    isOutput: true
                    isConnected: true
                }
            }

            // Transform Node
            Rectangle {
                x: 340
                y: 100
                width: 160
                height: 90
                radius: 8
                color: Theme.secondary
                border.width: 1
                border.color: Theme.border
                z: 2
                PanelHeader {
                    width: parent.width
                    title: "TRANSFORM"
                    anchors.top: parent.top
                    accentColor: Theme.accent
                }
                Column {
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 8
                    spacing: 2
                    Text {
                        text: "Scale: 100%"
                        color: Theme.mutedForeground
                        font.pixelSize: 10
                    }
                    Text {
                        text: "Rotation: 0°"
                        color: Theme.mutedForeground
                        font.pixelSize: 10
                    }
                }
                NodeSocket {
                    anchors.left: parent.left
                    anchors.leftMargin: -6
                    anchors.verticalCenter: parent.verticalCenter
                    isConnected: true
                }
                NodeSocket {
                    anchors.right: parent.right
                    anchors.rightMargin: -6
                    anchors.verticalCenter: parent.verticalCenter
                    isOutput: true
                    isConnected: true
                }
            }

            // Color Node
            Rectangle {
                x: 340
                y: 260
                width: 160
                height: 90
                radius: 8
                color: Theme.secondary
                border.width: 1
                border.color: Theme.border
                z: 2
                PanelHeader {
                    width: parent.width
                    title: "COLOR GRADE"
                    anchors.top: parent.top
                    accentColor: Theme.warning
                }
                Column {
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 8
                    spacing: 2
                    Text {
                        text: "Lift: 0.0"
                        color: Theme.mutedForeground
                        font.pixelSize: 10
                    }
                    Text {
                        text: "Gamma: 1.0"
                        color: Theme.mutedForeground
                        font.pixelSize: 10
                    }
                }
                NodeSocket {
                    anchors.left: parent.left
                    anchors.leftMargin: -6
                    anchors.verticalCenter: parent.verticalCenter
                    isConnected: true
                    socketColor: Theme.warning
                }
                NodeSocket {
                    anchors.right: parent.right
                    anchors.rightMargin: -6
                    anchors.verticalCenter: parent.verticalCenter
                    isOutput: true
                    isConnected: true
                    socketColor: Theme.warning
                }
            }

            // Output Node
            Rectangle {
                x: 600
                y: 180
                width: 160
                height: 90
                radius: 8
                color: Theme.secondary
                border.width: 2
                border.color: Theme.primary
                z: 2
                PanelHeader {
                    width: parent.width
                    title: "OUTPUT"
                    anchors.top: parent.top
                    accentColor: Theme.primary
                }
                Text {
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 8
                    text: "1920×1080 • 24fps"
                    color: Theme.mutedForeground
                    font.pixelSize: 11
                }
                NodeSocket {
                    anchors.left: parent.left
                    anchors.leftMargin: -6
                    anchors.verticalCenter: parent.verticalCenter
                    isConnected: true
                    socketColor: Theme.primary
                }
            }
        }
    }
}
