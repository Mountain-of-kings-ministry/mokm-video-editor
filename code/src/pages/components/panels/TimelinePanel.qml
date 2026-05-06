import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import mokm_video_editor

Rectangle {
    id: root
    color: Theme.background

    property bool autoScrollToPlayhead: true

    readonly property real pixelsPerFrame: timelinePlayer.zoomLevel / 10.0
    readonly property real headerWidth: 120
    readonly property real totalTimelineWidth: headerWidth + Math.max(trackModel.totalDurationFrames * pixelsPerFrame, root.width)
    readonly property real rulerHeight: 24
    readonly property real trackHeight: 48

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Timeline toolbar
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 32
            color: Theme.secondary

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 4
                anchors.rightMargin: 4
                spacing: 4

                Repeater {
                    model: [
                        { icon: "qrc:/icons/outline/cut.svg", tip: "Cut" },
                        { icon: "qrc:/icons/outline/arrows-move-horizontal.svg", tip: "Trim" },
                        { icon: "qrc:/icons/outline/separator.svg", tip: "Split" }
                    ]

                    Rectangle {
                        width: 24; height: 24; radius: 3; color: "transparent"
                        Image { anchors.centerIn: parent; source: modelData.icon; width: 14; height: 14; sourceSize: Qt.size(14, 14); opacity: 0.5; layer.enabled: true; layer.effect: MultiEffect { colorization: 1.0; colorizationColor: Theme.foreground; brightness: 1.0 } }
                        MouseArea { anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onEntered: parent.color = Theme.secondaryHover; onExited: parent.color = "transparent" }
                    }
                }

                Rectangle {
                    width: 24; height: 24; radius: 3
                    color: root.autoScrollToPlayhead ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.2) : "transparent"
                    Image { anchors.centerIn: parent; source: "qrc:/icons/outline/arrows-move.svg"; width: 14; height: 14; sourceSize: Qt.size(14, 14); opacity: root.autoScrollToPlayhead ? 0.9 : 0.5; layer.enabled: true; layer.effect: MultiEffect { colorization: 1.0; colorizationColor: root.autoScrollToPlayhead ? Theme.primary : Theme.foreground; brightness: 1.0 } }
                    MouseArea { anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: (mouse) => root.autoScrollToPlayhead = !root.autoScrollToPlayhead; onEntered: parent.color = Theme.secondaryHover; onExited: parent.color = root.autoScrollToPlayhead ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.2) : "transparent" }
                    ToolTip.visible: false; ToolTip.text: "Auto-scroll to playhead"
                }

                Item { Layout.fillWidth: true }

                Rectangle {
                    width: 24; height: 24; radius: 3; color: "transparent"
                    Row { anchors.centerIn: parent; spacing: 2
                        Image { anchors.verticalCenter: parent.verticalCenter; source: "qrc:/icons/outline/plus.svg"; width: 12; height: 12; sourceSize: Qt.size(12, 12); layer.enabled: true; layer.effect: MultiEffect { colorization: 1.0; colorizationColor: Theme.accent; brightness: 1.0 } }
                        Text { text: "V"; color: Theme.accent; font.pixelSize: 9; font.weight: Font.Medium; anchors.verticalCenter: parent.verticalCenter }
                    }
                    MouseArea { anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: (mouse) => trackModel.addVideoTrack(); onEntered: parent.color = Theme.secondaryHover; onExited: parent.color = "transparent" }
                }

                Rectangle {
                    width: 24; height: 24; radius: 3; color: "transparent"
                    Row { anchors.centerIn: parent; spacing: 2
                        Image { anchors.verticalCenter: parent.verticalCenter; source: "qrc:/icons/outline/plus.svg"; width: 12; height: 12; sourceSize: Qt.size(12, 12); layer.enabled: true; layer.effect: MultiEffect { colorization: 1.0; colorizationColor: Theme.success; brightness: 1.0 } }
                        Text { text: "A"; color: Theme.success; font.pixelSize: 9; font.weight: Font.Medium; anchors.verticalCenter: parent.verticalCenter }
                    }
                    MouseArea { anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: (mouse) => trackModel.addAudioTrack(); onEntered: parent.color = Theme.secondaryHover; onExited: parent.color = "transparent" }
                }

                Item { Layout.preferredWidth: 8 }

                Image { source: "qrc:/icons/outline/zoom-out.svg"; width: 12; height: 12; sourceSize: Qt.size(12, 12); opacity: 0.4; layer.enabled: true; layer.effect: MultiEffect { colorization: 1.0; colorizationColor: Theme.foreground; brightness: 1.0 }
                    MouseArea { anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: (mouse) => timelinePlayer.zoomLevel = Math.max(10, timelinePlayer.zoomLevel - 10); onEntered: parent.opacity = 0.7; onExited: parent.opacity = 0.4 } }

                Rectangle { Layout.preferredWidth: 60; Layout.preferredHeight: 3; radius: 2; color: Theme.muted
                    Rectangle { width: (timelinePlayer.zoomLevel / 200) * parent.width; height: parent.height; radius: 2; color: Theme.primary } }

                Image { source: "qrc:/icons/outline/zoom-in.svg"; width: 12; height: 12; sourceSize: Qt.size(12, 12); opacity: 0.4; layer.enabled: true; layer.effect: MultiEffect { colorization: 1.0; colorizationColor: Theme.foreground; brightness: 1.0 }
                    MouseArea { anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: (mouse) => timelinePlayer.zoomLevel = Math.min(200, timelinePlayer.zoomLevel + 10); onEntered: parent.opacity = 0.7; onExited: parent.opacity = 0.4 } }
            }
        }

        // Timeline content area
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            // Scrollable content
            Flickable {
                id: trackFlickable
                anchors.fill: parent
                contentWidth: root.totalTimelineWidth
                contentHeight: trackColumn.height + root.rulerHeight
                clip: true

                Connections {
                    target: timelinePlayer
                    function onPositionChanged() {
                        if (root.autoScrollToPlayhead && trackFlickable.contentWidth > trackFlickable.width) {
                            var playheadContentX = root.headerWidth + timelinePlayer.position * root.pixelsPerFrame
                            var viewLeft = trackFlickable.contentX
                            var viewRight = viewLeft + trackFlickable.width
                            if (playheadContentX > viewRight - 50 || playheadContentX < viewLeft) {
                                trackFlickable.contentX = playheadContentX - trackFlickable.width * 0.3
                            }
                        }
                    }
                }

                // Ruler
                TimelineRuler {
                    id: timelineRuler
                    x: root.headerWidth
                    y: 0
                    width: root.totalTimelineWidth - root.headerWidth
                    height: root.rulerHeight
                }

                // Track content
                Column {
                    id: trackColumn
                    x: root.headerWidth
                    y: root.rulerHeight
                    width: Math.max(trackFlickable.width, root.totalTimelineWidth - root.headerWidth)
                    spacing: 0

                    Repeater {
                        model: trackModel

                        TimelineTrack {
                            width: trackColumn.width
                            trackType: model.trackType
                            trackLocked: model.trackLocked
                            trackVisible: model.trackVisible
                            trackColor: model.trackColor
                            trackIndex: index

                            DropArea {
                                anchors.fill: parent
                                onEntered: (drop) => {
                                    if (drop.hasText) {
                                        parent.compatible = trackModel.isFileCompatibleWithTrack(drop.text, index)
                                    }
                                }
                                onExited: (drop) => {
                                    parent.compatible = true
                                }
                                onDropped: (drop) => {
                                    if (drop.hasText) {
                                        trackModel.importMedia(drop.text, index)
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Fixed header column
            Column {
                id: headerColumn
                width: root.headerWidth
                anchors.top: parent.top
                anchors.topMargin: root.rulerHeight
                anchors.bottom: parent.bottom
                spacing: 0

                Repeater {
                    model: trackModel

                    Rectangle {
                        width: root.headerWidth
                        height: root.trackHeight
                        color: Theme.secondary

                        Rectangle { width: 1; height: parent.height; anchors.right: parent.right; color: Theme.border }
                        Rectangle { width: parent.width; height: 1; anchors.bottom: parent.bottom; color: Theme.border; opacity: 0.4 }

                        RowLayout {
                            anchors.fill: parent; anchors.leftMargin: 8; anchors.rightMargin: 4; spacing: 4

                            Rectangle { width: 4; height: 20; radius: 2; color: model.trackColor; Layout.alignment: Qt.AlignVCenter }

                            Text { text: model.trackName; color: model.trackLocked ? Theme.muted : Theme.foreground; font.pixelSize: 11; Layout.fillWidth: true; Layout.alignment: Qt.AlignVCenter; elide: Text.ElideRight }

                            Rectangle { width: 20; height: 20; radius: 3; color: model.trackLocked ? Qt.rgba(Theme.warning.r, Theme.warning.g, Theme.warning.b, 0.2) : "transparent"; Layout.alignment: Qt.AlignVCenter
                                Image { anchors.centerIn: parent; source: model.trackLocked ? "qrc:/icons/outline/lock.svg" : "qrc:/icons/outline/lock-open.svg"; width: 12; height: 12; sourceSize: Qt.size(12, 12); layer.enabled: true; layer.effect: MultiEffect { colorization: 1.0; colorizationColor: model.trackLocked ? Theme.warning : Theme.muted; brightness: 1.0 } }
                                MouseArea { anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: (mouse) => trackModel.toggleLock(index); onEntered: parent.color = Theme.secondaryHover; onExited: parent.color = model.trackLocked ? Qt.rgba(Theme.warning.r, Theme.warning.g, Theme.warning.b, 0.2) : "transparent" }
                            }

                            Rectangle { width: 20; height: 20; radius: 3; color: !model.trackVisible ? Qt.rgba(Theme.error.r, Theme.error.g, Theme.error.b, 0.2) : "transparent"; Layout.alignment: Qt.AlignVCenter
                                Image { anchors.centerIn: parent; source: model.trackVisible ? "qrc:/icons/outline/eye.svg" : "qrc:/icons/outline/eye-off.svg"; width: 12; height: 12; sourceSize: Qt.size(12, 12); layer.enabled: true; layer.effect: MultiEffect { colorization: 1.0; colorizationColor: model.trackVisible ? Theme.muted : Theme.error; brightness: 1.0 } }
                                MouseArea { anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: (mouse) => trackModel.toggleVisible(index); onEntered: parent.color = Theme.secondaryHover; onExited: parent.color = !model.trackVisible ? Qt.rgba(Theme.error.r, Theme.error.g, Theme.error.b, 0.2) : "transparent" }
                            }
                        }
                    }
                }
            }

            // Fixed top-left corner
            Rectangle {
                width: root.headerWidth; height: root.rulerHeight; color: Theme.secondary
                Rectangle { width: 1; height: parent.height; anchors.right: parent.right; color: Theme.border }
                Rectangle { width: parent.width; height: 1; anchors.bottom: parent.bottom; color: Theme.border }
            }

            // Playhead overlay
            Rectangle {
                x: root.headerWidth + timelinePlayer.position * root.pixelsPerFrame - trackFlickable.contentX
                y: root.rulerHeight
                width: 2
                height: parent.height - root.rulerHeight
                color: Theme.primary
                opacity: 0.7
                z: 100

                Rectangle {
                    x: -4
                    width: 10; height: 8; color: Theme.primary; radius: 1
                    anchors.horizontalCenter: parent.horizontalCenter

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        drag.target: playheadDragHandle
                        drag.axis: Drag.XAxis
                        drag.minimumX: root.headerWidth - playheadOverlay.x - 4
                        drag.maximumX: root.width - playheadOverlay.x - 6

                        onPressed: (mouse) => playheadDragHandle.dragStartMouseX = mouse.x

                        onPositionChanged: (mouse) => {
                            var contentX = trackFlickable.contentX + playheadOverlay.x - root.headerWidth + (mouse.x - playheadDragHandle.dragStartMouseX)
                            var frame = Math.round(contentX / root.pixelsPerFrame)
                            timelinePlayer.position = Math.max(0, Math.min(trackModel.totalDurationFrames, frame))
                        }
                    }
                }

                // Invisible handle for dragging the entire playhead
                MouseArea {
                    id: playheadDragHandle
                    anchors.fill: parent
                    anchors.topMargin: 8
                    cursorShape: Qt.SplitHCursor
                    drag.axis: Drag.XAxis
                    drag.minimumX: -playheadOverlay.x + root.headerWidth
                    drag.maximumX: root.width - playheadOverlay.x

                    property real dragStartMouseX: 0

                    onPressed: (mouse) => dragStartMouseX = mouse.x

                    onPositionChanged: (mouse) => {
                        var contentX = trackFlickable.contentX + playheadOverlay.x - root.headerWidth + (mouse.x - dragStartMouseX)
                        var frame = Math.round(contentX / root.pixelsPerFrame)
                        timelinePlayer.position = Math.max(0, Math.min(trackModel.totalDurationFrames, frame))
                    }
                }
            }
        }

        // Empty state
        ColumnLayout {
            Layout.fillWidth: true; Layout.fillHeight: true; spacing: 12
            visible: trackModel.trackCount === 0

            Image { Layout.alignment: Qt.AlignHCenter; source: "qrc:/icons/outline/list.svg"; width: 32; height: 32; sourceSize: Qt.size(32, 32); opacity: 0.15; layer.enabled: true; layer.effect: MultiEffect { colorization: 1.0; colorizationColor: Theme.muted; brightness: 1.0 } }
            Text { Layout.alignment: Qt.AlignHCenter; text: "No tracks yet"; color: Theme.muted; font.pixelSize: 11 }
            Text { Layout.alignment: Qt.AlignHCenter; text: "Add video or audio tracks to begin"; color: Theme.muted; font.pixelSize: 9 }
        }
    }
}
