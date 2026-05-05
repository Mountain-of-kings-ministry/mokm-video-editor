import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import QtMultimedia
import mokm_video_editor

Rectangle {
    id: previewPanel

    property string fileName: ""
    property string filePath: ""
    property string fileType: "unknown"
    property string fileSize: ""
    property string duration: ""
    property string resolution: ""

    color: Theme.secondary

    function formatTime(ms) {
        if (ms <= 0) return "00:00";
        let totalSec = Math.floor(ms / 1000);
        let min = Math.floor(totalSec / 60);
        let sec = totalSec % 60;
        return String(min).padStart(2, '0') + ":" + String(sec).padStart(2, '0');
    }

    function doSeek(pos) {
        if (mediaPlayer.duration > 0) {
            let target = Math.max(0, Math.min(pos, mediaPlayer.duration));
            mediaPlayer.position = target;
        }
    }

    AudioOutput { id: audioOutput }

    MediaPlayer {
        id: mediaPlayer
        audioOutput: audioOutput
        videoOutput: videoOut
        source: previewPanel.filePath !== "" && previewPanel.fileType !== "image" ? "file://" + previewPanel.filePath : ""
        autoPlay: false
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        PanelHeader {
            Layout.fillWidth: true
            title: "PREVIEW"
        }

        // Preview viewport
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 8
            radius: 6
            color: "#000000"
            clip: true

            // Video playback
            VideoOutput {
                id: videoOut
                anchors.fill: parent
                visible: previewPanel.fileType === "video"
            }

            // Video overlay controls
            ColumnLayout {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 8
                spacing: 6
                visible: previewPanel.fileType === "video"

                // Progress bar (clickable)
                Rectangle {
                    id: videoSeekBar
                    Layout.fillWidth: true
                    Layout.preferredHeight: 6
                    radius: 3
                    color: Qt.rgba(1, 1, 1, 0.15)

                    Rectangle {
                        width: mediaPlayer.duration > 0 ? (mediaPlayer.position / mediaPlayer.duration) * parent.width : 0
                        height: parent.height
                        radius: 3
                        color: Theme.primary
                    }

                    Rectangle {
                        x: mediaPlayer.duration > 0 ? (mediaPlayer.position / mediaPlayer.duration) * videoSeekBar.width - 4 : 0
                        y: -2
                        width: 10
                        height: 10
                        radius: 5
                        color: Theme.primary
                        visible: mediaPlayer.duration > 0

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            drag.target: parent
                            drag.axis: Drag.XAxis
                            drag.minimumX: 0
                            drag.maximumX: videoSeekBar.width - parent.width

                            onPositionChanged: {
                                let ratio = (parent.x + 4) / videoSeekBar.width;
                                previewPanel.doSeek(ratio * mediaPlayer.duration);
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onPressed: (mouse) => {
                            previewPanel.doSeek((mouse.x / width) * mediaPlayer.duration);
                        }
                    }
                }

                // Play controls row
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Rectangle {
                        id: vidPlayBtn
                        width: 36
                        height: 36
                        radius: 18
                        color: Qt.rgba(1, 1, 1, 0.15)

                        Image {
                            anchors.centerIn: parent
                            source: mediaPlayer.playbackState === MediaPlayer.PlayingState ? "qrc:/icons/outline/player-pause.svg" : "qrc:/icons/outline/player-play.svg"
                            width: 18
                            height: 18
                            sourceSize: Qt.size(18, 18)
                            layer.enabled: true
                            layer.effect: MultiEffect {
                                colorization: 1.0
                                colorizationColor: "#ffffff"
                                brightness: 1.0
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (mediaPlayer.playbackState === MediaPlayer.PlayingState)
                                    mediaPlayer.pause();
                                else
                                    mediaPlayer.play();
                            }
                        }
                    }

                    Text {
                        text: formatTime(mediaPlayer.position) + " / " + formatTime(mediaPlayer.duration)
                        color: "#ffffff"
                        font.pixelSize: 11
                        font.family: "monospace"
                    }

                    Item { Layout.fillWidth: true }

                    Image {
                        source: "qrc:/icons/outline/volume.svg"
                        width: 14
                        height: 14
                        sourceSize: Qt.size(14, 14)
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            colorization: 1.0
                            colorizationColor: "#ffffff"
                            brightness: 1.0
                        }
                    }

                    Rectangle {
                        id: vidVolBar
                        width: 60
                        height: 4
                        radius: 2
                        color: Qt.rgba(1, 1, 1, 0.2)

                        Rectangle {
                            width: audioOutput.volume * parent.width
                            height: parent.height
                            radius: 2
                            color: "#ffffff"
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onPressed: (mouse) => {
                                audioOutput.volume = Math.max(0, Math.min(1, mouse.x / width));
                            }
                        }
                    }
                }
            }

            // Image preview
            Image {
                anchors.fill: parent
                anchors.margins: 8
                fillMode: Image.PreserveAspectFit
                source: previewPanel.fileType === "image" && previewPanel.filePath !== "" ? "file://" + previewPanel.filePath : ""
                visible: previewPanel.fileType === "image" && previewPanel.filePath !== ""
            }

            // Audio playback
            ColumnLayout {
                anchors.centerIn: parent
                anchors.margins: 24
                spacing: 16
                visible: previewPanel.fileType === "audio"

                // Album art / waveform area
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 120
                    radius: 8
                    color: Qt.rgba(1, 1, 1, 0.08)
                    border.color: Theme.border
                    border.width: 1
                    clip: true

                    // Static waveform visualization
                    Row {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottomMargin: 16
                        anchors.leftMargin: 24
                        anchors.rightMargin: 24
                        spacing: 2
                        height: 40

                        Rectangle { width: 3; height: 12; radius: 1.5; color: Theme.primary; opacity: 0.3 }
                        Rectangle { width: 3; height: 18; radius: 1.5; color: Theme.primary; opacity: 0.35 }
                        Rectangle { width: 3; height: 24; radius: 1.5; color: Theme.primary; opacity: 0.4 }
                        Rectangle { width: 3; height: 16; radius: 1.5; color: Theme.primary; opacity: 0.3 }
                        Rectangle { width: 3; height: 28; radius: 1.5; color: Theme.primary; opacity: 0.45 }
                        Rectangle { width: 3; height: 32; radius: 1.5; color: Theme.primary; opacity: 0.5 }
                        Rectangle { width: 3; height: 20; radius: 1.5; color: Theme.primary; opacity: 0.35 }
                        Rectangle { width: 3; height: 36; radius: 1.5; color: Theme.primary; opacity: 0.55 }
                        Rectangle { width: 3; height: 28; radius: 1.5; color: Theme.primary; opacity: 0.45 }
                        Rectangle { width: 3; height: 40; radius: 1.5; color: Theme.primary; opacity: 0.6 }
                        Rectangle { width: 3; height: 34; radius: 1.5; color: Theme.primary; opacity: 0.5 }
                        Rectangle { width: 3; height: 22; radius: 1.5; color: Theme.primary; opacity: 0.4 }
                        Rectangle { width: 3; height: 38; radius: 1.5; color: Theme.primary; opacity: 0.55 }
                        Rectangle { width: 3; height: 30; radius: 1.5; color: Theme.primary; opacity: 0.45 }
                        Rectangle { width: 3; height: 18; radius: 1.5; color: Theme.primary; opacity: 0.3 }
                        Rectangle { width: 3; height: 26; radius: 1.5; color: Theme.primary; opacity: 0.4 }
                        Rectangle { width: 3; height: 32; radius: 1.5; color: Theme.primary; opacity: 0.5 }
                        Rectangle { width: 3; height: 20; radius: 1.5; color: Theme.primary; opacity: 0.35 }
                        Rectangle { width: 3; height: 14; radius: 1.5; color: Theme.primary; opacity: 0.25 }
                        Rectangle { width: 3; height: 22; radius: 1.5; color: Theme.primary; opacity: 0.4 }
                        Rectangle { width: 3; height: 30; radius: 1.5; color: Theme.primary; opacity: 0.45 }
                        Rectangle { width: 3; height: 16; radius: 1.5; color: Theme.primary; opacity: 0.3 }
                        Rectangle { width: 3; height: 24; radius: 1.5; color: Theme.primary; opacity: 0.4 }
                        Rectangle { width: 3; height: 36; radius: 1.5; color: Theme.primary; opacity: 0.55 }
                        Rectangle { width: 3; height: 28; radius: 1.5; color: Theme.primary; opacity: 0.45 }
                        Rectangle { width: 3; height: 18; radius: 1.5; color: Theme.primary; opacity: 0.3 }
                        Rectangle { width: 3; height: 22; radius: 1.5; color: Theme.primary; opacity: 0.4 }
                        Rectangle { width: 3; height: 34; radius: 1.5; color: Theme.primary; opacity: 0.5 }
                        Rectangle { width: 3; height: 26; radius: 1.5; color: Theme.primary; opacity: 0.4 }
                        Rectangle { width: 3; height: 20; radius: 1.5; color: Theme.primary; opacity: 0.35 }
                        Rectangle { width: 3; height: 14; radius: 1.5; color: Theme.primary; opacity: 0.25 }
                        Rectangle { width: 3; height: 18; radius: 1.5; color: Theme.primary; opacity: 0.3 }
                        Rectangle { width: 3; height: 26; radius: 1.5; color: Theme.primary; opacity: 0.4 }
                        Rectangle { width: 3; height: 32; radius: 1.5; color: Theme.primary; opacity: 0.5 }
                        Rectangle { width: 3; height: 22; radius: 1.5; color: Theme.primary; opacity: 0.4 }
                        Rectangle { width: 3; height: 16; radius: 1.5; color: Theme.primary; opacity: 0.3 }
                        Rectangle { width: 3; height: 28; radius: 1.5; color: Theme.primary; opacity: 0.45 }
                        Rectangle { width: 3; height: 34; radius: 1.5; color: Theme.primary; opacity: 0.5 }
                        Rectangle { width: 3; height: 20; radius: 1.5; color: Theme.primary; opacity: 0.35 }
                        Rectangle { width: 3; height: 14; radius: 1.5; color: Theme.primary; opacity: 0.25 }
                        Rectangle { width: 3; height: 18; radius: 1.5; color: Theme.primary; opacity: 0.3 }
                        Rectangle { width: 3; height: 24; radius: 1.5; color: Theme.primary; opacity: 0.4 }
                        Rectangle { width: 3; height: 30; radius: 1.5; color: Theme.primary; opacity: 0.45 }
                        Rectangle { width: 3; height: 22; radius: 1.5; color: Theme.primary; opacity: 0.4 }
                        Rectangle { width: 3; height: 16; radius: 1.5; color: Theme.primary; opacity: 0.3 }
                        Rectangle { width: 3; height: 20; radius: 1.5; color: Theme.primary; opacity: 0.35 }
                        Rectangle { width: 3; height: 28; radius: 1.5; color: Theme.primary; opacity: 0.45 }
                        Rectangle { width: 3; height: 18; radius: 1.5; color: Theme.primary; opacity: 0.3 }
                        Rectangle { width: 3; height: 12; radius: 1.5; color: Theme.primary; opacity: 0.25 }
                        Rectangle { width: 3; height: 16; radius: 1.5; color: Theme.primary; opacity: 0.3 }

                        // Progress fill overlay
                        Rectangle {
                            width: mediaPlayer.duration > 0 ? (mediaPlayer.position / mediaPlayer.duration) * parent.width : 0
                            height: parent.height
                            color: Theme.primary
                            opacity: 0.25
                        }
                    }

                    // Clickable seek overlay
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onPressed: (mouse) => {
                            let ratio = mouse.x / width;
                            previewPanel.doSeek(ratio * mediaPlayer.duration);
                        }
                    }
                }

                // Audio timeline seek bar
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    Text {
                        Layout.alignment: Qt.AlignRight
                        text: formatTime(mediaPlayer.position) + " / " + formatTime(mediaPlayer.duration)
                        color: Theme.mutedForeground
                        font.pixelSize: 11
                        font.family: "monospace"
                    }

                    Rectangle {
                        id: audioSeekBar
                        Layout.fillWidth: true
                        Layout.preferredHeight: 6
                        radius: 3
                        color: Qt.rgba(1, 1, 1, 0.15)

                        Rectangle {
                            width: mediaPlayer.duration > 0 ? (mediaPlayer.position / mediaPlayer.duration) * parent.width : 0
                            height: parent.height
                            radius: 3
                            color: Theme.primary
                        }

                        Rectangle {
                            x: mediaPlayer.duration > 0 ? (mediaPlayer.position / mediaPlayer.duration) * audioSeekBar.width - 5 : 0
                            y: -2
                            width: 10
                            height: 10
                            radius: 5
                            color: Theme.primary
                            visible: mediaPlayer.duration > 0

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                drag.target: parent
                                drag.axis: Drag.XAxis
                                drag.minimumX: 0
                                drag.maximumX: audioSeekBar.width - parent.width

                                onPositionChanged: {
                                    let ratio = (parent.x + 5) / audioSeekBar.width;
                                    previewPanel.doSeek(ratio * mediaPlayer.duration);
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onPressed: (mouse) => {
                                previewPanel.doSeek((mouse.x / width) * mediaPlayer.duration);
                            }
                        }
                    }
                }

                // Audio controls
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 16

                    // Back 10s
                    Rectangle {
                        id: audioBackBtn
                        width: 36
                        height: 36
                        radius: 18
                        color: Qt.rgba(1, 1, 1, 0.1)

                        Image {
                            anchors.centerIn: parent
                            source: "qrc:/icons/outline/player-skip-back.svg"
                            width: 16
                            height: 16
                            sourceSize: Qt.size(16, 16)
                            layer.enabled: true
                            layer.effect: MultiEffect {
                                colorization: 1.0
                                colorizationColor: "#ffffff"
                                brightness: 1.0
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                previewPanel.doSeek(Math.max(0, mediaPlayer.position - 10000));
                            }
                        }
                    }

                    // Play/Pause
                    Rectangle {
                        id: audioPlayBtn
                        width: 44
                        height: 44
                        radius: 22
                        color: Theme.primary

                        Image {
                            anchors.centerIn: parent
                            source: mediaPlayer.playbackState === MediaPlayer.PlayingState ? "qrc:/icons/outline/player-pause.svg" : "qrc:/icons/outline/player-play.svg"
                            width: 20
                            height: 20
                            sourceSize: Qt.size(20, 20)
                            layer.enabled: true
                            layer.effect: MultiEffect {
                                colorization: 1.0
                                colorizationColor: Theme.background
                                brightness: 1.0
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (mediaPlayer.playbackState === MediaPlayer.PlayingState)
                                    mediaPlayer.pause();
                                else
                                    mediaPlayer.play();
                            }
                        }
                    }

                    // Forward 10s
                    Rectangle {
                        id: audioFwdBtn
                        width: 36
                        height: 36
                        radius: 18
                        color: Qt.rgba(1, 1, 1, 0.1)

                        Image {
                            anchors.centerIn: parent
                            source: "qrc:/icons/outline/player-skip-forward.svg"
                            width: 16
                            height: 16
                            sourceSize: Qt.size(16, 16)
                            layer.enabled: true
                            layer.effect: MultiEffect {
                                colorization: 1.0
                                colorizationColor: "#ffffff"
                                brightness: 1.0
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                previewPanel.doSeek(Math.min(mediaPlayer.duration, mediaPlayer.position + 10000));
                            }
                        }
                    }
                }

                // Volume control
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 8

                    Image {
                        source: "qrc:/icons/outline/volume.svg"
                        width: 14
                        height: 14
                        sourceSize: Qt.size(14, 14)
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            colorization: 1.0
                            colorizationColor: Theme.mutedForeground
                            brightness: 1.0
                        }
                    }

                    Rectangle {
                        id: audioVolBar
                        width: 80
                        height: 4
                        radius: 2
                        color: Qt.rgba(1, 1, 1, 0.2)

                        Rectangle {
                            width: audioOutput.volume * parent.width
                            height: parent.height
                            radius: 2
                            color: Theme.primary
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onPressed: (mouse) => {
                                audioOutput.volume = Math.max(0, Math.min(1, mouse.x / width));
                            }
                        }
                    }
                }
            }

            // Empty state
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 12
                visible: previewPanel.fileType === "unknown" || previewPanel.filePath === ""

                Image {
                    Layout.alignment: Qt.AlignHCenter
                    source: "qrc:/icons/outline/file.svg"
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
                    text: "Select a file to preview"
                    color: Theme.muted
                    font.pixelSize: 12
                }
            }
        }

        // File info section
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: fileInfoLayout.height + 16
            color: Theme.background

            ColumnLayout {
                id: fileInfoLayout
                anchors.fill: parent
                anchors.margins: 8
                spacing: 8

                RowLayout {
                    spacing: 8

                    Image {
                        source: {
                            if (previewPanel.fileType === "video") return "qrc:/icons/outline/video.svg";
                            if (previewPanel.fileType === "audio") return "qrc:/icons/outline/music.svg";
                            if (previewPanel.fileType === "image") return "qrc:/icons/outline/photo.svg";
                            return "qrc:/icons/outline/file.svg";
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
                        text: previewPanel.fileName || "No file selected"
                        color: Theme.foreground
                        font.pixelSize: 11
                        font.weight: Font.Medium
                        elide: Text.ElideMiddle
                    }
                }

                RowLayout {
                    spacing: 8
                    visible: previewPanel.fileSize !== ""

                    Image {
                        source: "qrc:/icons/outline/file-info.svg"
                        width: 14
                        height: 14
                        sourceSize: Qt.size(14, 14)
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            colorization: 1.0
                            colorizationColor: Theme.mutedForeground
                            brightness: 1.0
                        }
                    }

                    Text {
                        text: "Size: " + previewPanel.fileSize
                        color: Theme.mutedForeground
                        font.pixelSize: 10
                    }
                }

                RowLayout {
                    spacing: 8
                    visible: previewPanel.duration !== ""

                    Image {
                        source: "qrc:/icons/outline/clock.svg"
                        width: 14
                        height: 14
                        sourceSize: Qt.size(14, 14)
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            colorization: 1.0
                            colorizationColor: Theme.mutedForeground
                            brightness: 1.0
                        }
                    }

                    Text {
                        text: "Duration: " + previewPanel.duration
                        color: Theme.mutedForeground
                        font.pixelSize: 10
                    }
                }

                RowLayout {
                    spacing: 8
                    visible: previewPanel.resolution !== ""

                    Image {
                        source: "qrc:/icons/outline/resize.svg"
                        width: 14
                        height: 14
                        sourceSize: Qt.size(14, 14)
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            colorization: 1.0
                            colorizationColor: Theme.mutedForeground
                            brightness: 1.0
                        }
                    }

                    Text {
                        text: "Resolution: " + previewPanel.resolution
                        color: Theme.mutedForeground
                        font.pixelSize: 10
                    }
                }
            }
        }
    }
}
