import QtQuick
import QtQuick.Effects

Item {
    id: root

    property bool horizontal: true
    property real splitPosition: 0.5
    property real minimumSize: 50
    readonly property int splitterSize: 2

    property alias firstSection: firstSectionItem
    property alias secondSection: secondSectionItem

    Item {
        id: firstSectionItem
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: horizontal ? parent.bottom : splitter.top
        anchors.right: horizontal ? splitter.left : parent.right
    }

    Rectangle {
        id: splitter
        color: splitMouse.containsMouse || splitMouse.pressed ? Theme.primary : Theme.border
        opacity: splitMouse.containsMouse || splitMouse.pressed ? 1.0 : 0.5

        x: horizontal ? (root.width - splitterSize) * splitPosition : 0
        y: horizontal ? 0 : (root.height - splitterSize) * splitPosition
        width: horizontal ? splitterSize : root.width
        height: horizontal ? root.height : splitterSize

        MouseArea {
            id: splitMouse
            anchors.centerIn: parent
            width: horizontal ? parent.width + 8 : parent.width
            height: horizontal ? parent.height : parent.height + 8
            hoverEnabled: true
            cursorShape: horizontal ? Qt.SplitHCursor : Qt.SplitVCursor

            property real startPos: 0
            property real startSplit: 0

            onPressed: (mouse) => {
                startPos = horizontal ? mouseX : mouseY
                startSplit = splitPosition
            }

            onPositionChanged: (mouse) => {
                if (!pressed) return
                var currentPos = horizontal ? mouseX : mouseY
                var totalSize = horizontal ? root.width : root.height
                if (totalSize <= 0) return

                var delta = currentPos - startPos
                var newSplit = startSplit + (delta / totalSize)

                var minFrac = root.minimumSize / totalSize
                newSplit = Math.max(minFrac, Math.min(1.0 - minFrac, newSplit))
                splitPosition = newSplit
            }
        }
    }

    Item {
        id: secondSectionItem
        anchors.top: horizontal ? parent.top : splitter.bottom
        anchors.left: horizontal ? splitter.right : parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }
}
