import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQuick.Effects
import mokm_video_editor

Rectangle {
    id: root
    color: Theme.background

    property int selectedFileIndex: -1
    property int selectedFolderIndex: -1
    property int viewMode: 0
    property int fileCount: 0
    property bool showFolders: width >= 300

    signal mediaDropped(string filePath, string fileType)

    Component.onCompleted: {
        folderModel.addSystemMediaFolders()
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Toolbar
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 32
            color: Theme.secondary

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 4
                anchors.rightMargin: 4
                spacing: 4

                // Search field
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 22
                    radius: 3
                    color: Theme.input
                    border.color: Theme.border
                    border.width: 1

                    Row {
                        anchors.fill: parent
                        anchors.margins: 3
                        spacing: 4

                        Image {
                            anchors.verticalCenter: parent.verticalCenter
                            source: "qrc:/icons/outline/search.svg"
                            width: 12
                            height: 12
                            sourceSize: Qt.size(12, 12)
                            opacity: 0.5
                            layer.enabled: true
                            layer.effect: MultiEffect {
                                colorization: 1.0
                                colorizationColor: Theme.primary
                                brightness: 1.0
                            }
                        }

                        TextField {
                            id: searchField
                            height: parent.height
                            Layout.fillWidth: true
                            background: Rectangle { color: "transparent" }
                            font.pixelSize: 10
                            color: Theme.foreground
                            placeholderText: "Search..."
                            placeholderTextColor: Theme.muted

                            onTextChanged: mediaFileModel.setFilterText(text)
                        }
                    }
                }

                // Extension filter
                Rectangle {
                    id: filterBtn
                    width: 60
                    height: 22
                    radius: 3
                    color: Theme.input
                    border.color: Theme.border
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 4
                        spacing: 2

                        Text {
                            text: extensionMenu.currentText
                            color: Theme.foreground
                            font.pixelSize: 9
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }

                        Image {
                            source: "qrc:/icons/outline/chevron-down.svg"
                            width: 10
                            height: 10
                            sourceSize: Qt.size(10, 10)
                            Layout.alignment: Qt.AlignVCenter
                            layer.enabled: true
                            layer.effect: MultiEffect {
                                colorization: 1.0
                                colorizationColor: Theme.mutedForeground
                                brightness: 1.0
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: extensionMenu.popup()
                    }

                    Menu {
                        id: extensionMenu
                        property string currentText: "All"

                        MenuItem { text: "All"; onTriggered: { extensionMenu.currentText = text; mediaFileModel.setFilterType("all") } }
                        MenuItem { text: "Video"; onTriggered: { extensionMenu.currentText = text; mediaFileModel.setFilterType("video") } }
                        MenuItem { text: "Audio"; onTriggered: { extensionMenu.currentText = text; mediaFileModel.setFilterType("audio") } }
                        MenuItem { text: "Image"; onTriggered: { extensionMenu.currentText = text; mediaFileModel.setFilterType("image") } }
                    }
                }

                // Import button
                Rectangle {
                    width: 22
                    height: 22
                    radius: 3
                    color: Theme.primary

                    Image {
                        anchors.centerIn: parent
                        source: "qrc:/icons/outline/plus.svg"
                        width: 12
                        height: 12
                        sourceSize: Qt.size(12, 12)
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            colorization: 1.0
                            colorizationColor: Theme.background
                            brightness: 1.0
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: fileDialog.open()
                        onEntered: parent.color = Theme.primaryHover
                        onExited: parent.color = Theme.primary
                    }

                    ToolTip.visible: false
                    ToolTip.text: "Import media"
                }

                // Grid view toggle
                Rectangle {
                    width: 22
                    height: 22
                    radius: 3
                    color: root.viewMode === 0 ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.12) : "transparent"

                    Image {
                        anchors.centerIn: parent
                        source: "qrc:/icons/outline/layout-grid.svg"
                        width: 12
                        height: 12
                        sourceSize: Qt.size(12, 12)
                        opacity: root.viewMode === 0 ? 0.9 : 0.4
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            colorization: 1.0
                            colorizationColor: Theme.primary
                            brightness: 1.0
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.viewMode = 0
                    }
                }

                // List view toggle
                Rectangle {
                    width: 22
                    height: 22
                    radius: 3
                    color: root.viewMode === 1 ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.12) : "transparent"

                    Image {
                        anchors.centerIn: parent
                        source: "qrc:/icons/outline/list.svg"
                        width: 12
                        height: 12
                        sourceSize: Qt.size(12, 12)
                        opacity: root.viewMode === 1 ? 0.9 : 0.4
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            colorization: 1.0
                            colorizationColor: Theme.primary
                            brightness: 1.0
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.viewMode = 1
                    }
                }
            }
        }

        // Content area
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // Left panel - Folder tree
            Rectangle {
                Layout.preferredWidth: root.showFolders ? 140 : 0
                Layout.fillHeight: true
                visible: root.showFolders
                clip: true

                Behavior on Layout.preferredWidth {
                    NumberAnimation { duration: 150 }
                }

                color: Theme.secondary

                Rectangle {
                    width: 1
                    height: parent.height
                    anchors.right: parent.right
                    color: Theme.border
                }

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0

                    // Add folder button
                    Rectangle {
                        id: addFolderBtn
                        Layout.fillWidth: true
                        Layout.preferredHeight: 26
                        color: "transparent"

                        RowLayout {
                            anchors.centerIn: parent
                            spacing: 4

                            Image {
                                source: "qrc:/icons/outline/plus.svg"
                                width: 12
                                height: 12
                                sourceSize: Qt.size(12, 12)
                                layer.enabled: true
                                layer.effect: MultiEffect {
                                    colorization: 1.0
                                    colorizationColor: Theme.primary
                                    brightness: 1.0
                                }
                            }

                            Text {
                                text: "Add Folder"
                                color: Theme.primary
                                font.pixelSize: 9
                                font.weight: Font.Medium
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: folderDialog.open()
                            onEntered: parent.color = Theme.secondaryHover
                            onExited: parent.color = "transparent"
                        }
                    }

                    ListView {
                        id: folderListView
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.margins: 2
                        clip: true
                        spacing: 1

                        model: folderModel

                        delegate: Rectangle {
                            id: folderDelegate
                            width: folderListView.width - 4
                            height: 26
                            radius: 3
                            color: root.selectedFolderIndex === index ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.12) : "transparent"

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 4
                                anchors.rightMargin: 2
                                spacing: 4

                                Image {
                                    source: model.isSuperFolder ? "qrc:/icons/outline/layers-intersect.svg" : "qrc:/icons/outline/folder.svg"
                                    width: 12
                                    height: 12
                                    sourceSize: Qt.size(12, 12)
                                    layer.enabled: true
                                    layer.effect: MultiEffect {
                                        colorization: 1.0
                                        colorizationColor: model.isSuperFolder ? Theme.accent : Theme.primary
                                        brightness: 1.0
                                    }
                                }

                                Text {
                                    text: model.folderName
                                    color: root.selectedFolderIndex === index ? Theme.primary : Theme.foreground
                                    font.pixelSize: 9
                                    Layout.fillWidth: true
                                    elide: Text.ElideMiddle
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    root.selectedFileIndex = -1
                                    root.selectedFolderIndex = index
                                    if (model.isSuperFolder) {
                                        mediaFileModel.browseDirectories(model.childPaths)
                                    } else {
                                        mediaFileModel.browseDirectory(folderModel.getFolderUrlAt(index))
                                    }
                                }
                                onEntered: parent.color = root.selectedFolderIndex === index ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.12) : Theme.secondaryHover
                                onExited: parent.color = root.selectedFolderIndex === index ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.12) : "transparent"
                            }
                        }
                    }
                }
            }

            // File browser
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Theme.background

                // Grid view
                GridView {
                    id: fileView
                    anchors.fill: parent
                    anchors.margins: 6
                    cellWidth: 100
                    cellHeight: 90
                    clip: true
                    visible: root.viewMode === 0

                    model: mediaFileModel

                    onCountChanged: root.fileCount = mediaFileModel.rowCount()

                    delegate: Rectangle {
                        id: gridFileCard
                        width: 92
                        height: 82
                        radius: 4
                        color: root.selectedFileIndex === index ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.15) : Theme.secondary
                        border.width: 1
                        border.color: root.selectedFileIndex === index ? Theme.primary : Theme.border

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 3
                            spacing: 2

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 44
                                radius: 3
                                color: Theme.background

                                Image {
                                    anchors.centerIn: parent
                                    source: {
                                        if (model.fileType === "video") return "qrc:/icons/outline/video.svg"
                                        if (model.fileType === "audio") return "qrc:/icons/outline/music.svg"
                                        return "qrc:/icons/outline/photo.svg"
                                    }
                                    width: 16
                                    height: 16
                                    sourceSize: Qt.size(16, 16)
                                    opacity: 0.3
                                    layer.enabled: true
                                    layer.effect: MultiEffect {
                                        colorization: 1.0
                                        colorizationColor: Theme.primary
                                        brightness: 1.0
                                    }
                                }

                                Rectangle {
                                    visible: model.duration !== ""
                                    anchors.right: parent.right
                                    anchors.bottom: parent.bottom
                                    anchors.margins: 2
                                    width: durationText.width + 4
                                    height: 12
                                    radius: 2
                                    color: Qt.rgba(0, 0, 0, 0.7)

                                    Text {
                                        id: durationText
                                        anchors.centerIn: parent
                                        text: model.duration
                                        color: Theme.foreground
                                        font.pixelSize: 7
                                    }
                                }
                            }

                            Text {
                                Layout.fillWidth: true
                                text: model.fileName
                                color: Theme.foreground
                                font.pixelSize: 8
                                elide: Text.ElideMiddle
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }

                        // Drag support
                        Drag.active: fileMouse.drag.active
                        Drag.hotSpot.x: width / 2
                        Drag.hotSpot.y: height / 2
                        Drag.mimeData: { "text/plain": model.filePath }

                        MouseArea {
                            id: fileMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            cursorShape: Qt.PointingHandCursor
                            drag.axis: Drag.XAndYAxis
                            drag.threshold: 16

                            onClicked: (mouse) => {
                                if (mouse.button === Qt.LeftButton) {
                                    root.selectedFileIndex = index
                                } else if (mouse.button === Qt.RightButton) {
                                    root.selectedFileIndex = index
                                    contextMenu.fileIndex = index
                                    contextMenu.filePath = model.filePath
                                    contextMenu.fileName = model.fileName
                                    contextMenu.fileType = model.fileType
                                    contextMenu.popup()
                                }
                            }

                            onEntered: {
                                if (root.selectedFileIndex !== index)
                                    gridFileCard.color = Qt.lighter(Theme.secondary, 1.1)
                            }
                            onExited: {
                                if (root.selectedFileIndex !== index)
                                    gridFileCard.color = Theme.secondary
                            }
                        }
                    }
                }

                // List view
                ListView {
                    id: listView
                    anchors.fill: parent
                    anchors.margins: 4
                    clip: true
                    visible: root.viewMode === 1
                    spacing: 1

                    model: mediaFileModel

                    delegate: Rectangle {
                        id: listFileCard
                        width: ListView.view.width
                        height: 28
                        radius: 3
                        color: root.selectedFileIndex === index ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.15) : "transparent"

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 4
                            spacing: 6

                            Image {
                                Layout.alignment: Qt.AlignVCenter
                                source: {
                                    if (model.fileType === "video") return "qrc:/icons/outline/video.svg"
                                    if (model.fileType === "audio") return "qrc:/icons/outline/music.svg"
                                    return "qrc:/icons/outline/photo.svg"
                                }
                                width: 14
                                height: 14
                                sourceSize: Qt.size(14, 14)
                                layer.enabled: true
                                layer.effect: MultiEffect {
                                    colorization: 1.0
                                    colorizationColor: Theme.primary
                                    brightness: 1.0
                                }
                            }

                            Text {
                                Layout.fillWidth: true
                                text: model.fileName
                                color: Theme.foreground
                                font.pixelSize: 10
                                elide: Text.ElideMiddle
                            }

                            Text {
                                text: model.fileSize
                                color: Theme.mutedForeground
                                font.pixelSize: 8
                            }

                            Text {
                                visible: model.duration !== ""
                                text: model.duration
                                color: Theme.mutedForeground
                                font.pixelSize: 8
                            }
                        }

                        Drag.active: listMouse.drag.active
                        Drag.hotSpot.x: width / 2
                        Drag.hotSpot.y: height / 2
                        Drag.mimeData: { "text/plain": model.filePath }

                        MouseArea {
                            id: listMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            cursorShape: Qt.PointingHandCursor
                            drag.axis: Drag.XAndYAxis
                            drag.threshold: 16

                            onClicked: (mouse) => {
                                if (mouse.button === Qt.LeftButton) {
                                    root.selectedFileIndex = index
                                } else if (mouse.button === Qt.RightButton) {
                                    root.selectedFileIndex = index
                                    contextMenu.fileIndex = index
                                    contextMenu.filePath = model.filePath
                                    contextMenu.fileName = model.fileName
                                    contextMenu.fileType = model.fileType
                                    contextMenu.popup()
                                }
                            }

                            onEntered: {
                                if (root.selectedFileIndex !== index)
                                    listFileCard.color = Theme.secondaryHover
                            }
                            onExited: {
                                if (root.selectedFileIndex !== index)
                                    listFileCard.color = "transparent"
                            }
                        }
                    }
                }

                // Empty state overlay
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 12
                    visible: root.fileCount === 0

                    Image {
                        Layout.alignment: Qt.AlignHCenter
                        source: "qrc:/icons/outline/folder-open.svg"
                        width: 32
                        height: 32
                        sourceSize: Qt.size(32, 32)
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
                        text: "No media files"
                        color: Theme.muted
                        font.pixelSize: 11
                    }
                }
            }
        }
    }

    // File dialog for importing
    FileDialog {
        id: fileDialog
        title: "Import Media Files"
        nameFilters: [
            "Media files (*.mp4 *.avi *.mkv *.mov *.wmv *.flv *.webm *.mp3 *.wav *.aac *.flac *.ogg *.png *.jpg *.jpeg *.gif *.bmp *.svg *.webp)",
            "Video files (*.mp4 *.avi *.mkv *.mov *.wmv *.flv *.webm)",
            "Audio files (*.mp3 *.wav *.aac *.flac *.ogg)",
            "Image files (*.png *.jpg *.jpeg *.gif *.bmp *.svg *.webp)",
            "All files (*)"
        ]
        onAccepted: {
            mediaFileModel.addFiles([selectedFile.toString().replace("file://", "")])
            if (root.selectedFolderIndex >= 0) {
                mediaFileModel.setFilterText("")
                mediaFileModel.setFilterType("all")
            }
        }
    }

    // Folder dialog for adding custom folders
    FolderDialog {
        id: folderDialog
        title: "Add Media Folder"
        onAccepted: folderModel.addFolder(selectedFolder.toString().replace("file://", ""))
    }

    // Context menu for files
    Menu {
        id: contextMenu
        property int fileIndex: -1
        property string filePath: ""
        property string fileName: ""
        property string fileType: ""

        MenuItem {
            text: "Add to New Track"
            onTriggered: {
                if (contextMenu.fileType === "audio") {
                    trackModel.addAudioTrack()
                    trackModel.importMediaToTrack(contextMenu.filePath, trackModel.trackCount - 1)
                } else {
                    trackModel.addVideoTrack()
                    trackModel.importMediaToTrack(contextMenu.filePath, trackModel.trackCount - 1)
                }
            }
        }

        MenuSeparator {}

        Repeater {
            model: trackModel
            MenuItem {
                text: trackName + " (" + trackType + ")"
                onTriggered: trackModel.importMediaToTrack(contextMenu.filePath, index)
            }
        }
    }
}
