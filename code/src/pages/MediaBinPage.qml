import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQuick.Effects
import mokm_video_editor

Item {
    id: mediaBinPage

    property int selectedFileIndex: -1
    property int selectedFolderIndex: -1
    property int viewMode: 0

    function updateViewModeGridBtnColor() {
        return gridMouse.containsMouse ? Theme.secondaryHover : (mediaBinPage.viewMode === 0 ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.12) : "transparent");
    }
    function updateViewModeListBtnColor() {
        return listMouse.containsMouse ? Theme.secondaryHover : (mediaBinPage.viewMode === 1 ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.12) : "transparent");
    }

    Component.onCompleted: {
        folderModel.addSystemMediaFolders();
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Toolbar
        EditorToolBar {
            Layout.fillWidth: true

            // Current directory path
            Text {
                Layout.alignment: Qt.AlignVCenter
                text: {
                    let path = mediaFileModel.currentDirectory.toString().replace("file://", "");
                    if (!path) return "All Media";
                    let parts = path.split("/");
                    return parts.length > 3 ? "..." + parts.slice(-3).join("/") : path;
                }
                color: Theme.mutedForeground
                font.pixelSize: 11
                elide: Text.ElideMiddle
            }

            Item {
                Layout.preferredWidth: 12
            }

            // Search field
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 26
                radius: 4
                color: Theme.input
                border.color: Theme.border
                border.width: 1

                Row {
                    anchors.fill: parent
                    anchors.margins: 4
                    spacing: 6

                    Image {
                        anchors.verticalCenter: parent.verticalCenter
                        source: "qrc:/icons/outline/search.svg"
                        width: 14
                        height: 14
                        sourceSize: Qt.size(14, 14)
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
                        font.pixelSize: 12
                        color: Theme.foreground
                        placeholderText: "Search media..."
                        placeholderTextColor: Theme.muted

                        onTextChanged: {
                            mediaFileModel.setFilterText(text);
                        }
                    }
                }
            }

            Item {
                Layout.preferredWidth: 6
            }

            // Extension filter dropdown
            Rectangle {
                id: filterBtn
                width: 80
                height: 26
                radius: 4
                color: Theme.input
                border.color: Theme.border
                border.width: 1
                Layout.alignment: Qt.AlignVCenter

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 6
                    spacing: 4

                    Text {
                        id: filterLabel
                        text: extensionMenu.currentText
                        color: Theme.foreground
                        font.pixelSize: 11
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }

                    Image {
                        source: "qrc:/icons/outline/chevron-down.svg"
                        width: 12
                        height: 12
                        sourceSize: Qt.size(12, 12)
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
                    id: filterMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: extensionMenu.popup()
                }

                Binding {
                    target: filterBtn
                    property: "color"
                    value: filterMouse.containsMouse ? Theme.secondaryHover : Theme.input
                    when: true
                }

                Menu {
                    id: extensionMenu

                    property string currentText: "All"

                    MenuItem {
                        text: "All"
                        onTriggered: {
                            extensionMenu.currentText = text;
                            mediaFileModel.setFilterType("all");
                        }
                    }
                    MenuItem {
                        text: "Video"
                        onTriggered: {
                            extensionMenu.currentText = text;
                            mediaFileModel.setFilterType("video");
                        }
                    }
                    MenuItem {
                        text: "Audio"
                        onTriggered: {
                            extensionMenu.currentText = text;
                            mediaFileModel.setFilterType("audio");
                        }
                    }
                    MenuItem {
                        text: "Image"
                        onTriggered: {
                            extensionMenu.currentText = text;
                            mediaFileModel.setFilterType("image");
                        }
                    }
                }
            }

            Item {
                Layout.preferredWidth: 8
            }

            // Grid view toggle
            Rectangle {
                id: gridToggle
                width: 28
                height: 28
                radius: 4
                color: mediaBinPage.viewMode === 0 ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.12) : "transparent"
                Layout.alignment: Qt.AlignVCenter

                Image {
                    anchors.centerIn: parent
                    source: "qrc:/icons/outline/layout-grid.svg"
                    width: 16
                    height: 16
                    sourceSize: Qt.size(16, 16)
                    opacity: mediaBinPage.viewMode === 0 ? 0.9 : 0.4
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        colorization: 1.0
                        colorizationColor: Theme.primary
                        brightness: 1.0
                    }
                }

                MouseArea {
                    id: gridMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: mediaBinPage.viewMode = 0
                }

                Binding {
                    target: gridToggle
                    property: "color"
                    value: gridMouse.containsMouse ? Theme.secondaryHover : (mediaBinPage.viewMode === 0 ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.12) : "transparent")
                    when: true
                }
            }

            // List view toggle
            Rectangle {
                id: listToggle
                width: 28
                height: 28
                radius: 4
                color: mediaBinPage.viewMode === 1 ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.12) : "transparent"
                Layout.alignment: Qt.AlignVCenter

                Image {
                    anchors.centerIn: parent
                    source: "qrc:/icons/outline/list.svg"
                    width: 16
                    height: 16
                    sourceSize: Qt.size(16, 16)
                    opacity: mediaBinPage.viewMode === 1 ? 0.9 : 0.4
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        colorization: 1.0
                        colorizationColor: Theme.primary
                        brightness: 1.0
                    }
                }

                MouseArea {
                    id: listMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: mediaBinPage.viewMode = 1
                }

                Binding {
                    target: listToggle
                    property: "color"
                    value: listMouse.containsMouse ? Theme.secondaryHover : (mediaBinPage.viewMode === 1 ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.12) : "transparent")
                    when: true
                }
            }

            Item {
                Layout.preferredWidth: 8
            }

            // Import button
            Rectangle {
                width: 80
                height: 26
                radius: 4
                color: Theme.primary
                Layout.alignment: Qt.AlignVCenter

                Row {
                    anchors.centerIn: parent
                    spacing: 4

                    Image {
                        anchors.verticalCenter: parent.verticalCenter
                        source: "qrc:/icons/outline/plus.svg"
                        width: 14
                        height: 14
                        sourceSize: Qt.size(14, 14)
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            colorization: 1.0
                            colorizationColor: Theme.background
                            brightness: 1.0
                        }
                    }

                    Text {
                        text: "Import"
                        color: Theme.background
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        anchors.verticalCenter: parent.verticalCenter
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
            }
        }

        // Content area
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // Left panel - Folder tree
            Rectangle {
                Layout.preferredWidth: 200
                Layout.fillHeight: true
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

                    PanelHeader {
                        Layout.fillWidth: true
                        title: "FOLDERS"
                    }

                    // Add folder button
                    Rectangle {
                        id: addFolderBtn
                        Layout.fillWidth: true
                        Layout.preferredHeight: 32
                        color: "transparent"

                        RowLayout {
                            anchors.centerIn: parent
                            spacing: 6

                            Image {
                                source: "qrc:/icons/outline/plus.svg"
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
                                text: "Add Folder"
                                color: Theme.primary
                                font.pixelSize: 11
                                font.weight: Font.Medium
                            }
                        }

                        MouseArea {
                            id: addFolderMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: folderDialog.open()
                        }

                        Binding {
                            target: addFolderBtn
                            property: "color"
                            value: addFolderMouse.containsMouse ? Theme.secondaryHover : "transparent"
                            when: true
                        }
                    }

                    ListView {
                        id: folderListView
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.margins: 4
                        clip: true
                        spacing: 1

                        model: folderModel

                        delegate: Rectangle {
                            id: folderDelegate
                            width: folderListView.width - 8
                            height: 32
                            radius: 4
                            color: mediaBinPage.selectedFolderIndex === index ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.12) : "transparent"

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 8
                                anchors.rightMargin: 4
                                spacing: 6

                                Image {
                                    source: model.isSuperFolder ? "qrc:/icons/outline/layers-intersect.svg" : "qrc:/icons/outline/folder.svg"
                                    width: 16
                                    height: 16
                                    sourceSize: Qt.size(16, 16)
                                    layer.enabled: true
                                    layer.effect: MultiEffect {
                                        colorization: 1.0
                                        colorizationColor: model.isSuperFolder ? Theme.accent : Theme.primary
                                        brightness: 1.0
                                    }
                                }

                                Text {
                                    text: model.folderName
                                    color: mediaBinPage.selectedFolderIndex === index ? Theme.primary : Theme.foreground
                                    font.pixelSize: 11
                                    Layout.fillWidth: true
                                    elide: Text.ElideMiddle
                                }

                                // Three-dot menu
                                Rectangle {
                                    id: folderDotBtn
                                    width: 20
                                    height: 20
                                    radius: 3
                                    color: "transparent"
                                    visible: !model.isSuperFolder

                                    Image {
                                        anchors.centerIn: parent
                                        source: "qrc:/icons/outline/dots-vertical.svg"
                                        width: 14
                                        height: 14
                                        sourceSize: Qt.size(14, 14)
                                        opacity: 0.5
                                        layer.enabled: true
                                        layer.effect: MultiEffect {
                                            colorization: 1.0
                                            colorizationColor: Theme.mutedForeground
                                            brightness: 1.0
                                        }
                                    }

                                    MouseArea {
                                        id: folderDotMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            folderContextMenu.folderIndex = index;
                                            folderContextMenu.folderPath = model.folderPath;
                                            folderContextMenu.popup();
                                        }
                                        onEntered: folderDotBtn.color = Theme.secondaryHover
                                        onExited: folderDotBtn.color = "transparent"
                                    }
                                }
                            }

                            MouseArea {
                                id: folderMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    mediaBinPage.selectedFileIndex = -1;
                                    mediaBinPage.selectedFolderIndex = index;
                                    if (model.isSuperFolder) {
                                        mediaFileModel.browseDirectories(model.childPaths);
                                    } else {
                                        mediaFileModel.browseDirectory(folderModel.getFolderUrlAt(index));
                                    }
                                }

                                Binding {
                                    target: folderDelegate
                                    property: "color"
                                    value: {
                                        if (mediaBinPage.selectedFolderIndex === index)
                                            return Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.12);
                                        if (folderMouse.containsMouse)
                                            return Theme.secondaryHover;
                                        return "transparent";
                                    }
                                    when: true
                                }
                            }
                        }
                    }
                }
            }

            // Middle panel - File browser
            Rectangle {
                id: fileBrowserPanel
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: mediaBinPage.selectedFileIndex >= 0 ? parent.width * 0.5 : parent.width - 200
                color: Theme.background

                Rectangle {
                    visible: mediaBinPage.selectedFileIndex >= 0
                    width: 1
                    height: parent.height
                    anchors.right: parent.right
                    color: Theme.border
                }

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0

                    PanelHeader {
                        Layout.fillWidth: true
                        title: "FILES"
                        accentColor: Theme.accent
                    }

                    // Grid view
                    GridView {
                        id: fileView
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.margins: 8
                        cellWidth: 130
                        cellHeight: 110
                        clip: true
                        visible: mediaBinPage.viewMode === 0

                        model: mediaFileModel

                        delegate: Rectangle {
                            id: gridFileCard
                            width: 122
                            height: 102
                            radius: 6
                            color: mediaBinPage.selectedFileIndex === index ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.15) : Theme.secondary
                            border.width: 1
                            border.color: mediaBinPage.selectedFileIndex === index ? Theme.primary : Theme.border

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 4
                                spacing: 4

                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 58
                                    radius: 4
                                    color: Theme.background

                                    Image {
                                        anchors.centerIn: parent
                                        source: {
                                            if (model.fileType === "video") return "qrc:/icons/outline/video.svg";
                                            if (model.fileType === "audio") return "qrc:/icons/outline/music.svg";
                                            return "qrc:/icons/outline/photo.svg";
                                        }
                                        width: 20
                                        height: 20
                                        sourceSize: Qt.size(20, 20)
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
                                        anchors.margins: 3
                                        width: durationText.width + 6
                                        height: 14
                                        radius: 2
                                        color: Qt.rgba(0, 0, 0, 0.7)

                                        Text {
                                            id: durationText
                                            anchors.centerIn: parent
                                            text: model.duration
                                            color: Theme.foreground
                                            font.pixelSize: 8
                                        }
                                    }
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: model.fileName
                                    color: Theme.foreground
                                    font.pixelSize: 10
                                    elide: Text.ElideMiddle
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }

                            MouseArea {
                                id: gridFileMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    mediaBinPage.selectedFileIndex = index;
                                    previewPanel.fileName = model.fileName;
                                    previewPanel.filePath = model.filePath;
                                    previewPanel.fileType = model.fileType;
                                    previewPanel.fileSize = model.fileSize;
                                    previewPanel.duration = model.duration;
                                    previewPanel.resolution = model.resolution;
                                }

                                onPressed: (mouse) => {
                                    mediaBinPage.selectedFileIndex = index;
                                    previewPanel.fileName = model.fileName;
                                    previewPanel.filePath = model.filePath;
                                    previewPanel.fileType = model.fileType;
                                    previewPanel.fileSize = model.fileSize;
                                    previewPanel.duration = model.duration;
                                    previewPanel.resolution = model.resolution;

                                    if (mouse.button === Qt.RightButton) {
                                        contextMenu.fileIndex = index;
                                        contextMenu.filePath = model.filePath;
                                        contextMenu.fileName = model.fileName;
                                        contextMenu.fileType = model.fileType;
                                        contextMenu.popup();
                                        mouse.accepted = true;
                                    }
                                }

                                Binding {
                                    target: gridFileCard
                                    property: "color"
                                    value: {
                                        if (mediaBinPage.selectedFileIndex === index)
                                            return Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.15);
                                        if (gridFileMouse.containsMouse)
                                            return Qt.lighter(Theme.secondary, 1.1);
                                        return Theme.secondary;
                                    }
                                    when: true
                                }
                            }
                        }
                    }

                    // List view
                    ListView {
                        id: listView
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.margins: 4
                        clip: true
                        visible: mediaBinPage.viewMode === 1
                        spacing: 1

                        model: mediaFileModel

                        delegate: Rectangle {
                            id: listFileCard
                            width: ListView.view.width
                            height: 32
                            radius: 4
                            color: "transparent"

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 6
                                spacing: 8

                                Image {
                                    Layout.alignment: Qt.AlignVCenter
                                    source: {
                                        if (model.fileType === "video") return "qrc:/icons/outline/video.svg";
                                        if (model.fileType === "audio") return "qrc:/icons/outline/music.svg";
                                        return "qrc:/icons/outline/photo.svg";
                                    }
                                    width: 16
                                    height: 16
                                    sourceSize: Qt.size(16, 16)
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
                                    font.pixelSize: 11
                                    elide: Text.ElideMiddle
                                }

                                Text {
                                    text: model.fileSize
                                    color: Theme.mutedForeground
                                    font.pixelSize: 10
                                }

                                Text {
                                    visible: model.duration !== ""
                                    text: model.duration
                                    color: Theme.mutedForeground
                                    font.pixelSize: 10
                                }
                            }

                            MouseArea {
                                id: listFileMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    mediaBinPage.selectedFileIndex = index;
                                    previewPanel.fileName = model.fileName;
                                    previewPanel.filePath = model.filePath;
                                    previewPanel.fileType = model.fileType;
                                    previewPanel.fileSize = model.fileSize;
                                    previewPanel.duration = model.duration;
                                    previewPanel.resolution = model.resolution;
                                }

                                onPressed: (mouse) => {
                                    if (mouse.button === Qt.RightButton) {
                                        mediaBinPage.selectedFileIndex = index;
                                        contextMenu.fileIndex = index;
                                        contextMenu.filePath = model.filePath;
                                        contextMenu.fileName = model.fileName;
                                        contextMenu.fileType = model.fileType;
                                        contextMenu.popup();
                                        mouse.accepted = true;
                                    }
                                }

                                Binding {
                                    target: listFileCard
                                    property: "color"
                                    value: {
                                        if (mediaBinPage.selectedFileIndex === index)
                                            return Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.15);
                                        if (listFileMouse.containsMouse)
                                            return Theme.secondaryHover;
                                        return "transparent";
                                    }
                                    when: true
                                }
                            }
                        }
                    }
                }

                // Empty state overlay (outside ColumnLayout)
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 16
                    visible: mediaFileModel.rowCount() === 0

                    Image {
                        Layout.alignment: Qt.AlignHCenter
                        source: "qrc:/icons/outline/folder-open.svg"
                        width: 48
                        height: 48
                        sourceSize: Qt.size(48, 48)
                        opacity: 0.2
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            colorization: 1.0
                            colorizationColor: Theme.muted
                            brightness: 1.0
                        }
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: "No media files found"
                        color: Theme.muted
                        font.pixelSize: 13
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: "Click Import to add files"
                        color: Theme.muted
                        font.pixelSize: 11
                    }
                }
            }

            // Right panel - Preview
            MediaPreviewPanel {
                id: previewPanel
                Layout.fillHeight: true
                Layout.preferredWidth: mediaBinPage.selectedFileIndex >= 0 ? parent.width * 0.35 : 0
                visible: mediaBinPage.selectedFileIndex >= 0

                Behavior on Layout.preferredWidth {
                    NumberAnimation { duration: 200 }
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
            mediaFileModel.addFiles([selectedFile.toString().replace("file://", "")]);
        }
    }

    // Folder dialog for adding custom folders
    FolderDialog {
        id: folderDialog
        title: "Add Media Folder"
        onAccepted: {
            folderModel.addFolder(selectedFolder.toString().replace("file://", ""));
        }
    }

    // Context menu for files
    Menu {
        id: contextMenu

        property int fileIndex: -1
        property string filePath: ""
        property string fileName: ""
        property string fileType: ""

        MenuItem {
            text: "Preview"
            onTriggered: {
                mediaBinPage.selectedFileIndex = contextMenu.fileIndex;
                previewPanel.fileName = contextMenu.fileName;
                previewPanel.filePath = contextMenu.filePath;
                previewPanel.fileType = contextMenu.fileType;
            }
        }

        MenuSeparator {}

        Menu {
            title: "Import to Track"

            MenuItem {
                text: "Add to New Track"
                onTriggered: {
                    if (contextMenu.fileType === "audio") {
                        trackModel.addAudioTrack();
                        trackModel.importMediaToTrack(contextMenu.filePath, trackModel.trackCount - 1);
                    } else {
                        trackModel.addVideoTrack();
                        trackModel.importMediaToTrack(contextMenu.filePath, trackModel.trackCount - 1);
                    }
                }
            }

            MenuSeparator {}

            Repeater {
                model: trackModel

                MenuItem {
                    text: trackName + " (" + trackType + ")"
                    onTriggered: {
                        trackModel.importMediaToTrack(contextMenu.filePath, index);
                    }
                }
            }
        }
    }

    // Context menu for folders
    Menu {
        id: folderContextMenu

        property int folderIndex: -1
        property string folderPath: ""

        MenuItem {
            text: "Browse"
            onTriggered: {
                mediaBinPage.selectedFileIndex = -1;
                mediaBinPage.selectedFolderIndex = folderContextMenu.folderIndex;
                mediaFileModel.browseDirectory(folderModel.getFolderUrlAt(folderContextMenu.folderIndex));
            }
        }

        MenuItem {
            text: "Remove"
            onTriggered: {
                folderModel.removeFolder(folderContextMenu.folderIndex);
            }
        }
    }
}
