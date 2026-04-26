import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.impl

Popup {
    id: proxyDashboard
    width: 600
    height: 400
    modal: false
    anchors.centerIn: Overlay.overlay ? Overlay.overlay : parent

    background: Rectangle {
        color: Theme.surface
        border.color: Theme.found
        border.width: 1
        radius: Theme.radius
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.paddingLarge

        RowLayout {
            Layout.fillWidth: true
            Text {
                text: "Proxy Manager Dashboard"
                color: Theme.textPrimary
                font: Theme.headerFont
                Layout.fillWidth: true
            }
            Button {
                text: "Close"
                onClicked: proxyDashboard.close()
            }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.found }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Theme.paddingSmall

            model: [
                { file: "MVI_0001.MP4", status: "Transcoding...", progress: 0.65 },
                { file: "MVI_0002.MP4", status: "Queued", progress: 0 },
                { file: "MVI_0003.MP4", status: "Done", progress: 1 }
            ]

            delegate: Rectangle {
                width: parent.width
                height: 50
                color: Theme.panel
                radius: Theme.radius

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: Theme.paddingSmall

                    IconImage {
                        color: Theme.textSecondary
                        source: "../icons/outline/video.svg"
                        Layout.preferredWidth: 24
                        Layout.preferredHeight: 24
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Text { text: modelData.file; color: Theme.textPrimary; font: Theme.smallFontBold }
                        ProgressBar {
                            Layout.fillWidth: true
                            value: modelData.progress
                            background: Rectangle { color: Theme.found; height: 4; radius: 2 }
                            contentItem: Item {
                                Rectangle {
                                    width: parent.width * modelData.progress
                                    height: 4
                                    radius: 2
                                    color: (modelData.progress === 1) ? Theme.sovereign : Theme.highlight
                                }
                            }
                        }
                    }

                    Text { text: modelData.status; color: Theme.textSecondary; font: Theme.smallFont; Layout.preferredWidth: 80 }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Button { text: "Pause All" }
            Button { text: "Clear Completed" }
            Item { Layout.fillWidth: true }
            Text { text: "Background Transcoder Running"; color: Theme.glimmer; font: Theme.smallFont }
        }
    }
}
