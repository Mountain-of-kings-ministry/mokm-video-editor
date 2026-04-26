pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.impl
import QtQuick.Layouts
import QtQuick.Dialogs
import QtCore
import Mokm.Timeline 1.0
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

    FolderDialog {
        id: linkedFolderDialog
        title: "Link External Folder"
        onAccepted: MediaBinModel.addLinkedFolder(selectedFolder)
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
                        text: "Collections"
                        color: Theme.textSecondary; font: Theme.smallFontBold
                        Layout.fillWidth: true
                    }
                }

                ItemDelegate {
                    width: parent.width
                    highlighted: MediaBinModel.currentParentId === ""
                    onClicked: {
                        MediaBinModel.currentParentId = ""
                        MediaBinModel.searchText = ""
                    }
                    contentItem: RowLayout {
                        IconImage { source: "../icons/outline/database.svg"; color: Theme.sovereign; Layout.preferredWidth: 16; Layout.preferredHeight: 16 }
                        Text { text: "All Imports"; color: Theme.textPrimary; font: Theme.defaultFont; Layout.fillWidth: true }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: 10
                    Text {
                        text: "Linked Folders"
                        color: Theme.textSecondary; font: Theme.smallFontBold
                        Layout.fillWidth: true
                    }
                    ToolButton {
                        icon.source: "../icons/outline/plus.svg"
                        icon.height: 14; icon.width: 14
                        onClicked: linkedFolderDialog.open()
                    }
                }
                
                ListView {
                    id: linkedFoldersList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: MediaBinModel.linkedFolders
                    delegate: ItemDelegate {
                        id: lfDelegate
                        width: linkedFoldersList.width
                        required property var modelData
                        contentItem: RowLayout {
                            IconImage { source: "../icons/outline/folder.svg"; color: Theme.highlight; Layout.preferredWidth: 16; Layout.preferredHeight: 16 }
                            Text { text: lfDelegate.modelData.toString().split('/').pop() || lfDelegate.modelData; color: Theme.textPrimary; font: Theme.smallFont; Layout.fillWidth: true; elide: Text.ElideMiddle }
                            ToolButton {
                                icon.source: "../icons/outline/x.svg"; icon.height: 12; icon.width: 12
                                onClicked: MediaBinModel.removeLinkedFolder(lfDelegate.modelData)
                            }
                        }
                        onClicked: {
                            MediaBinModel.importFolder(lfDelegate.modelData)
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
                    spacing: 10
                    
                    // Filter segments
                    RowLayout {
                        spacing: 0
                        Repeater {
                            model: ["All", "Video", "Audio"]
                            ToolButton {
                                id: typeFilterBtn
                                required property var modelData
                                text: typeFilterBtn.modelData
                                checkable: true
                                checked: MediaBinModel.typeFilter === typeFilterBtn.modelData
                                onClicked: MediaBinModel.typeFilter = text
                                contentItem: Text {
                                    text: typeFilterBtn.text
                                    font: Theme.smallFontBold
                                    color: typeFilterBtn.checked ? Theme.sovereign : Theme.textSecondary
                                    horizontalAlignment: Text.AlignHCenter
                                }
                                background: Rectangle {
                                    color: typeFilterBtn.checked ? Theme.panel : "transparent"
                                    radius: 4
                                }
                            }
                        }
                    }

                    TextField {
                        Layout.fillWidth: true
                        placeholderText: "Search media..."
                        color: Theme.textPrimary
                        onTextChanged: MediaBinModel.searchText = text
                        background: Rectangle {
                            color: Theme.found
                            radius: Theme.radius
                        }
                    }
                    ToolButton {
                        icon.source: "../icons/outline/folder-plus.svg"
                        icon.color: Theme.sovereign
                        onClicked: MediaBinModel.createFolder("New Bin")
                        visible: MediaBinModel.searchText === ""
                    }
                    ToolButton {
                        icon.source: "../icons/outline/chevron-left.svg"
                        icon.color: Theme.textPrimary
                        visible: MediaBinModel.currentParentId !== ""
                        onClicked: MediaBinModel.currentParentId = ""
                        ToolTip.visible: hovered
                        ToolTip.text: "Back to Root"
                    }
                }

                // Grid area with Drop support
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    DropArea {
                        anchors.fill: parent
                        onDropped: (drop) => {
                            if (drop.hasUrls) {
                                for (var i = 0; i < drop.urls.length; ++i) {
                                    MediaBinModel.importMedia(drop.urls[i])
                                }
                            }
                        }
                    }

                    GridView {
                        id: mediaGrid
                        anchors.fill: parent
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
                                        visible: mediaDelegate.model.mediaType !== "Audio" && !mediaDelegate.model.isFolder
                                    }

                                    // Placeholder if no thumbnail
                                    IconImage {
                                        visible: mediaDelegate.model.isFolder || mediaDelegate.model.mediaType === "Audio"
                                        color: mediaDelegate.model.isFolder ? Theme.sovereign : Theme.textSecondary; anchors.centerIn: parent
                                        source: mediaDelegate.model.isFolder ? "../icons/outline/folder.svg" : (mediaDelegate.model.mediaType === "Audio" ? "../icons/outline/music.svg" : "../icons/outline/video.svg")
                                        width: 32; height: 32
                                        opacity: 0.8
                                    }
                                    
                                    // Proxy Status indicator
                                    Rectangle {
                                        anchors.right: parent.right
                                        anchors.bottom: parent.bottom
                                        anchors.margins: 4
                                        width: 10; height: 10
                                        radius: 5
                                        color: mediaDelegate.model.hasProxy ? Theme.glimmer : Theme.textDisabled
                                        visible: !mediaDelegate.model.isFolder
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
                                        visible: !mediaDelegate.model.isFolder
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
                                drag.target: mediaDelegate.model.isFolder ? null : dragProxy
                                
                                onPressed: {
                                    mediaBinWorkspace.selectedItem = MediaBinModel.getMediaById(mediaDelegate.model.id)
                                }
                                onDoubleClicked: {
                                    if (mediaDelegate.model.isFolder) {
                                        MediaBinModel.currentParentId = mediaDelegate.model.id
                                    }
                                }
                                
                                onReleased: {
                                    if (dragProxy.visible) {
                                        dragProxy.Drag.drop()
                                        dragProxy.x = 0
                                        dragProxy.y = 0
                                    }
                                }

                                Rectangle {
                                    id: dragProxy
                                    width: 130
                                    height: 110
                                    color: Theme.glimmer
                                    opacity: 0.5
                                    visible: dragArea.drag.active && !mediaDelegate.model.isFolder
                                    anchors.centerIn: parent
                                    
                                    Drag.active: dragArea.drag.active
                                    Drag.hotSpot: Qt.point(65, 55)
                                    Drag.mimeData: {
                                        "mediaId": mediaDelegate.model.id,
                                        "mediaName": mediaDelegate.model.filename,
                                        "mediaType": mediaDelegate.model.mediaType,
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
                        visible: mediaBinWorkspace.selectedItem !== null && mediaBinWorkspace.selectedItem.mediaType !== "Audio" && !mediaBinWorkspace.selectedItem.isFolder
                        source: mediaBinWorkspace.selectedItem ? "image://media-bin/" + mediaBinWorkspace.selectedItem.id : ""
                        fillMode: Image.PreserveAspectFit
                        asynchronous: true
                    }

                    IconImage {
                        visible: !mediaBinWorkspace.selectedItem || mediaBinWorkspace.selectedItem.mediaType === "Audio" || mediaBinWorkspace.selectedItem.isFolder
                        color: Theme.textSecondary; anchors.centerIn: parent
                        source: mediaBinWorkspace.selectedItem && mediaBinWorkspace.selectedItem.isFolder ? "../icons/outline/folder.svg" : (mediaBinWorkspace.selectedItem && mediaBinWorkspace.selectedItem.mediaType === "Audio" ? "../icons/outline/music.svg" : "../icons/outline/video.svg")
                        width: 48; height: 48
                    }
                }

                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    rowSpacing: 10
                    columnSpacing: 10
                    visible: mediaBinWorkspace.selectedItem !== null && !mediaBinWorkspace.selectedItem.isFolder

                    Text { text: "Resolution:"; color: Theme.textSecondary; font: Theme.smallFont }
                    Text { text: mediaBinWorkspace.selectedItem.resolution || "-"; color: Theme.textPrimary; font: Theme.defaultFont }

                    Text { text: "Frame Rate:"; color: Theme.textSecondary; font: Theme.smallFont }
                    Text { text: mediaBinWorkspace.selectedItem.frameRate || "-"; color: Theme.textPrimary; font: Theme.defaultFont }

                    Text { text: "Codec:"; color: Theme.textSecondary; font: Theme.smallFont }
                    Text { text: mediaBinWorkspace.selectedItem.codec || "-"; color: Theme.textPrimary; font: Theme.defaultFont }
                    
                    Text { text: "Bit Depth:"; color: Theme.textSecondary; font: Theme.smallFont }
                    Text { text: mediaBinWorkspace.selectedItem.bitDepth ? mediaBinWorkspace.selectedItem.bitDepth + "-bit" : "-"; color: Theme.textPrimary; font: Theme.defaultFont }

                    Text { text: "Proxy:"; color: Theme.textSecondary; font: Theme.smallFont }
                    Text { text: mediaBinWorkspace.selectedItem.hasProxy ? "Active" : "Original"; color: mediaBinWorkspace.selectedItem.hasProxy ? Theme.sovereign : Theme.textSecondary; font: Theme.defaultFont }
                }

                Item { Layout.fillHeight: true } // Spacer
            }
        }
    }
}
