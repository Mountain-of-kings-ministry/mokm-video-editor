pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.impl
import QtQuick.Layouts
import QtQuick.Dialogs
import Mokm.Database 1.0
import untitled

Item {
    id: mediaBinWorkspace
    anchors.fill: parent

    property var selectedItem: null

    FileDialog {
        id: importDialog
        title: "Import Media"
        currentFolder: StandardPaths.writableLocation(StandardPaths.MoviesLocation)
        fileMode: FileDialog.OpenFiles
        onAccepted: {
            for (var i = 0; i < selectedFiles.length; ++i) {
                MediaBinModel.importMedia(selectedFiles[i])
            }
        }
    }

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

                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        text: "Media Library"
                        color: Theme.sovereign
                        font: Theme.headerFont
                        Layout.fillWidth: true
                    }
                    ToolButton {
                        icon.source: "../icons/outline/plus.svg"
                        icon.color: Theme.sovereign
                        onClicked: importDialog.open()
                        ToolTip.visible: hovered
                        ToolTip.text: "Import Media"
                    }
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
                    id: mediaGrid
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    cellWidth: 140
                    cellHeight: 120
                    clip: true
                    model: MediaBinModel
                    delegate: Rectangle {
                        id: mediaDelegate
                        width: 130
                        height: 110
                        
                        required property var model
                        
                        color: mediaBinWorkspace.selectedItem && mediaBinWorkspace.selectedItem.id === mediaDelegate.model.id ? Theme.found : Theme.panel
                        border.color: mediaBinWorkspace.selectedItem && mediaBinWorkspace.selectedItem.id === mediaDelegate.model.id ? Theme.sovereign : "transparent"
                        border.width: 1
                        radius: Theme.radius

                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 4
                            
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: Theme.surface
                                radius: Theme.radius
                                clip: true

                                Image {
                                    anchors.fill: parent
                                    source: "image://media-bin/" + mediaDelegate.model.id
                                    fillMode: Image.PreserveAspectCrop
                                    asynchronous: true
                                    visible: mediaDelegate.model.mediaType !== "Audio"
                                }

                                // Placeholder if no thumbnail
                                IconImage {
                                    visible: mediaDelegate.model.mediaType === "Audio" || (status === Image.Error && mediaDelegate.model.mediaType !== "Audio")
                                    color: Theme.textSecondary; anchors.centerIn: parent
                                    source: mediaDelegate.model.mediaType === "Audio" ? "../icons/outline/music.svg" : "../icons/outline/video.svg"
                                    width: 32; height: 32
                                    opacity: 0.5
                                }
                                
                                // Proxy Status indicator
                                Rectangle {
                                    anchors.right: parent.right
                                    anchors.bottom: parent.bottom
                                    anchors.margins: 4
                                    width: 10; height: 10
                                    radius: 5
                                    color: mediaDelegate.model.hasProxy ? Theme.glimmer : Theme.textDisabled
                                }

                                // Duration overlay
                                Rectangle {
                                    anchors.left: parent.left
                                    anchors.bottom: parent.bottom
                                    anchors.margins: 4
                                    width: durText.width + 8
                                    height: 16
                                    color: "#AA000000"
                                    radius: 2
                                    Text {
                                        id: durText
                                        anchors.centerIn: parent
                                        text: mediaDelegate.model.duration
                                        color: "white"
                                        font: Theme.smallFont
                                    }
                                }
                            }
                            Text {
                                Layout.fillWidth: true
                                text: mediaDelegate.model.filename
                                color: Theme.textPrimary
                                font: Theme.smallFont
                                horizontalAlignment: Text.AlignHCenter
                                elide: Text.ElideMiddle
                            }
                        }

                        MouseArea {
                            id: dragArea
                            anchors.fill: parent
                            drag.target: dragProxy
                            onPressed: {
                                mediaBinWorkspace.selectedItem = MediaBinModel.getMediaById(mediaDelegate.model.id)
                            }
                            
                            onReleased: {
                                dragProxy.Drag.drop()
                                dragProxy.x = 0
                                dragProxy.y = 0
                            }

                            Rectangle {
                                id: dragProxy
                                width: 130
                                height: 110
                                color: Theme.glimmer
                                opacity: 0.5
                                visible: dragArea.drag.active
                                anchors.centerIn: parent
                                Drag.active: dragArea.drag.active
                                Drag.hotSpot.x: width / 2
                                Drag.hotSpot.y: height / 2
                                Drag.mimeData: {
                                    "mediaId": mediaDelegate.model.id,
                                    "mediaName": mediaDelegate.model.filename,
                                    "mediaType": mediaDelegate.model.mediaType,
                                    "duration": mediaDelegate.model.duration,
                                    "durationSeconds": mediaDelegate.model.durationSeconds
                                }
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: mediaDelegate.model.filename
                                    color: "white"
                                    font: Theme.smallFont
                                }
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
                
                Text {
                    text: mediaBinWorkspace.selectedItem ? mediaBinWorkspace.selectedItem.filename : "No item selected"
                    color: Theme.textPrimary
                    font: Theme.defaultFontBold
                    elide: Text.ElideMiddle
                    Layout.fillWidth: true
                }
                
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 180
                    color: Theme.panel
                    radius: Theme.radius
                    clip: true
                    
                    Image {
                        anchors.fill: parent
                        visible: mediaBinWorkspace.selectedItem !== null && mediaBinWorkspace.selectedItem.mediaType !== "Audio"
                        source: mediaBinWorkspace.selectedItem ? "image://media-bin/" + mediaBinWorkspace.selectedItem.id : ""
                        fillMode: Image.PreserveAspectFit
                        asynchronous: true
                    }

                    IconImage {
                        visible: !mediaBinWorkspace.selectedItem || mediaBinWorkspace.selectedItem.mediaType === "Audio"
                        color: Theme.textSecondary; anchors.centerIn: parent
                        source: mediaBinWorkspace.selectedItem && mediaBinWorkspace.selectedItem.mediaType === "Audio" ? "../icons/outline/music.svg" : "../icons/outline/video.svg"
                        width: 48; height: 48
                    }
                }

                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    rowSpacing: 10
                    columnSpacing: 10
                    visible: mediaBinWorkspace.selectedItem !== null

                    Text { text: "Resolution:"; color: Theme.textSecondary; font: Theme.smallFont }
                    Text { text: mediaBinWorkspace.selectedItem ? mediaBinWorkspace.selectedItem.resolution : "-"; color: Theme.textPrimary; font: Theme.defaultFont }

                    Text { text: "Frame Rate:"; color: Theme.textSecondary; font: Theme.smallFont }
                    Text { text: mediaBinWorkspace.selectedItem ? mediaBinWorkspace.selectedItem.frameRate : "-"; color: Theme.textPrimary; font: Theme.defaultFont }

                    Text { text: "Codec:"; color: Theme.textSecondary; font: Theme.smallFont }
                    Text { text: mediaBinWorkspace.selectedItem ? mediaBinWorkspace.selectedItem.codec : "-"; color: Theme.textPrimary; font: Theme.defaultFont }
                    
                    Text { text: "Bit Depth:"; color: Theme.textSecondary; font: Theme.smallFont }
                    Text { text: mediaBinWorkspace.selectedItem ? mediaBinWorkspace.selectedItem.bitDepth + "-bit" : "-"; color: Theme.textPrimary; font: Theme.defaultFont }

                    Text { text: "Proxy:"; color: Theme.textSecondary; font: Theme.smallFont }
                    Text { text: mediaBinWorkspace.selectedItem && mediaBinWorkspace.selectedItem.hasProxy ? "Active" : "Original"; color: mediaBinWorkspace.selectedItem && mediaBinWorkspace.selectedItem.hasProxy ? Theme.sovereign : Theme.textSecondary; font: Theme.defaultFont }
                }

                Item { Layout.fillHeight: true } // Spacer
            }
        }
    }
}
