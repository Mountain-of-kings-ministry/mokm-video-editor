import QtQuick
import QtQuick.Controls
import QtQuick.Controls.impl
import QtQuick.Layouts

Item {
    id: mediaBinWorkspace
    anchors.fill: parent

    SplitView {
        anchors.fill: parent
        orientation: Qt.Horizontal

        // Left sidebar: Folder tree
        Rectangle {
            SplitView.preferredWidth: 250
            SplitView.minimumWidth: 150
            color: Theme.found

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Theme.paddingMedium

                Text {
                    text: "Media Library"
                    color: Theme.sovereign
                    font: Theme.headerFont
                    Layout.fillWidth: true
                }
                
                // MOCK FOLDER TREE
                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: ["Master Bin", "Audio", "B-Roll", "Proxies", "Graphics"]
                    delegate: ItemDelegate {
                        width: parent.width
                        height: 36
                        contentItem: RowLayout {
                            IconImage {

                                color: Theme.textSecondary; source: "../icons/outline/folder.svg"
                                Layout.preferredWidth: 16
                                Layout.preferredHeight: 16
                            }
                            Text {
                                text: modelData
                                color: Theme.textPrimary
                                font: Theme.defaultFont
                                Layout.fillWidth: true
                            }
                        }
                    }
                }
            }
        }

        // Center: Media thumbnails
        Rectangle {
            SplitView.fillWidth: true
            color: Theme.surface

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Theme.paddingMedium

                // Filter / Search bar
                RowLayout {
                    Layout.fillWidth: true
                    TextField {
                        Layout.fillWidth: true
                        placeholderText: "Search media..."
                        color: Theme.textPrimary
                        background: Rectangle {
                            color: Theme.found
                            radius: Theme.radius
                        }
                    }
                }

                // Grid of media
                GridView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    cellWidth: 140
                    cellHeight: 120
                    clip: true
                    model: 20
                    delegate: Rectangle {
                        width: 130
                        height: 110
                        color: Theme.panel
                        border.color: index === 0 ? Theme.highlight : "transparent"
                        border.width: 2
                        radius: Theme.radius

                        ColumnLayout {
                            anchors.fill: parent
                            
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: Theme.surface
                                radius: Theme.radius
                                // Mock Thumbnail
                                IconImage {

                                    color: Theme.textSecondary; anchors.centerIn: parent
                                    source: "../icons/outline/video.svg"
                                    width: 32; height: 32
                                    opacity: 0.5
                                }
                                
                                // Proxy Status indicator
                                Rectangle {
                                    anchors.right: parent.right
                                    anchors.bottom: parent.bottom
                                    anchors.margins: 4
                                    width: 12; height: 12
                                    radius: 6
                                    color: index % 3 === 0 ? Theme.sovereign : 
                                           index % 3 === 1 ? Theme.glimmer : Theme.textDisabled
                                }
                            }
                            Text {
                                Layout.fillWidth: true
                                text: "Clip_" + (index + 1) + ".mp4"
                                color: Theme.textPrimary
                                font: Theme.smallFont
                                horizontalAlignment: Text.AlignHCenter
                                elide: Text.ElideRight
                            }
                        }
                    }
                }
            }
        }
        
        // Right sidebar: Metadata Inspector
        Rectangle {
            SplitView.preferredWidth: 300
            SplitView.minimumWidth: 200
            color: Theme.found

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Theme.paddingMedium

                Text {
                    text: "Metadata Inspector"
                    color: Theme.sovereign
                    font: Theme.headerFont
                }
                
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 150
                    color: Theme.panel
                    radius: Theme.radius
                    
                    IconImage {

                    
                        color: Theme.textSecondary; anchors.centerIn: parent
                        source: "../icons/outline/video.svg"
                        width: 48; height: 48
                    }
                }

                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    rowSpacing: 10
                    columnSpacing: 10

                    Text { text: "Resolution:"; color: Theme.textSecondary; font: Theme.smallFont }
                    Text { text: "3840 x 2160"; color: Theme.textPrimary; font: Theme.defaultFont }

                    Text { text: "Frame Rate:"; color: Theme.textSecondary; font: Theme.smallFont }
                    Text { text: "59.94 fps"; color: Theme.textPrimary; font: Theme.defaultFont }

                    Text { text: "Codec:"; color: Theme.textSecondary; font: Theme.smallFont }
                    Text { text: "H.265 10-bit"; color: Theme.textPrimary; font: Theme.defaultFont }
                    
                    Text { text: "Proxy:"; color: Theme.textSecondary; font: Theme.smallFont }
                    Text { text: "ProRes 422 Proxy"; color: Theme.sovereign; font: Theme.defaultFont }
                }

                Item { Layout.fillHeight: true } // Spacer
            }
        }
    }
}
