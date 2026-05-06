import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import QtMultimedia

Item {
    id: root

    AudioOutput { id: previewAudioOutput }

    MediaPlayer {
        id: previewMediaPlayer
        audioOutput: previewAudioOutput
        videoOutput: previewVideoOut
        autoPlay: false
    }

    // Preview viewport
    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: controlsBar.top
        color: "#000000"
        border.width: 1
        border.color: Theme.border
        clip: true

        VideoOutput {
            id: previewVideoOut
            anchors.fill: parent
        }

        Image {
            anchors.centerIn: parent
            source: "qrc:/icons/outline/player-play.svg"
            width: 48
            height: 48
            sourceSize: Qt.size(48, 48)
            opacity: timelinePlayer.isPlaying ? 0.0 : 0.15
            layer.enabled: true
            layer.effect: MultiEffect {
                colorization: 1.0
                colorizationColor: Theme.foreground
                brightness: 1.0
            }

            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }
        }

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 12
            width: tcText.width + 12
            height: 22
            radius: 4
            color: Qt.rgba(0, 0, 0, 0.6)

            Text {
                id: tcText
                anchors.centerIn: parent
                text: timelinePlayer.timecode
                color: Theme.primary
                font.pixelSize: 11
                font.family: "monospace"
            }
        }
    }

    // Playback controls bar
    Rectangle {
        id: controlsBar
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 40
        color: Theme.secondary

        RowLayout {
            anchors.centerIn: parent
            spacing: 16

            Rectangle {
                width: 28; height: 28; radius: 14; color: "transparent"
                Image { anchors.centerIn: parent; source: "qrc:/icons/outline/player-skip-back.svg"; width: 16; height: 16; sourceSize: Qt.size(16, 16); opacity: 0.5; layer.enabled: true; layer.effect: MultiEffect { colorization: 1.0; colorizationColor: Theme.foreground; brightness: 1.0 } }
                MouseArea { anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: timelinePlayer.skipToStart(); onEntered: parent.color = Theme.secondaryHover; onExited: parent.color = "transparent" }
            }

            Rectangle {
                width: 28; height: 28; radius: 14; color: "transparent"
                Image { anchors.centerIn: parent; source: "qrc:/icons/outline/player-track-prev.svg"; width: 16; height: 16; sourceSize: Qt.size(16, 16); opacity: 0.5; layer.enabled: true; layer.effect: MultiEffect { colorization: 1.0; colorizationColor: Theme.foreground; brightness: 1.0 } }
                MouseArea { anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: timelinePlayer.stepBackward(); onEntered: parent.color = Theme.secondaryHover; onExited: parent.color = "transparent" }
            }

            Rectangle {
                width: 36; height: 36; radius: 18; color: Theme.primary
                Image { anchors.centerIn: parent; source: timelinePlayer.isPlaying ? "qrc:/icons/outline/player-pause.svg" : "qrc:/icons/outline/player-play.svg"; width: 18; height: 18; sourceSize: Qt.size(18, 18); layer.enabled: true; layer.effect: MultiEffect { colorization: 1.0; colorizationColor: Theme.background; brightness: 1.0 } }
                MouseArea { anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: timelinePlayer.togglePlayPause(); onEntered: parent.color = Theme.primaryHover; onExited: parent.color = Theme.primary }
            }

            Rectangle {
                width: 28; height: 28; radius: 14; color: "transparent"
                Image { anchors.centerIn: parent; source: "qrc:/icons/outline/player-track-next.svg"; width: 16; height: 16; sourceSize: Qt.size(16, 16); opacity: 0.5; layer.enabled: true; layer.effect: MultiEffect { colorization: 1.0; colorizationColor: Theme.foreground; brightness: 1.0 } }
                MouseArea { anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: timelinePlayer.stepForward(); onEntered: parent.color = Theme.secondaryHover; onExited: parent.color = "transparent" }
            }

            Rectangle {
                width: 28; height: 28; radius: 14; color: "transparent"
                Image { anchors.centerIn: parent; source: "qrc:/icons/outline/player-skip-forward.svg"; width: 16; height: 16; sourceSize: Qt.size(16, 16); opacity: 0.5; layer.enabled: true; layer.effect: MultiEffect { colorization: 1.0; colorizationColor: Theme.foreground; brightness: 1.0 } }
                MouseArea { anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: timelinePlayer.skipToEnd(); onEntered: parent.color = Theme.secondaryHover; onExited: parent.color = "transparent" }
            }
        }
    }
}
