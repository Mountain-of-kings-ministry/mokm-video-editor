import QtQuick

Item {
    id: root

    property bool horizontal: true
    property real splitPosition: 0.5
    property real minimumSize: 50
    readonly property int splitterSize: 2

    property Item firstItem: null
    property Item secondItem: null

    function setItems(first, second) {
        firstItem = first
        secondItem = second

        if (horizontal) {
            firstItem.anchors.top = root.top
            firstItem.anchors.left = root.left
            firstItem.anchors.bottom = root.bottom
            firstItem.anchors.right = splitter.left

            secondItem.anchors.top = root.top
            secondItem.anchors.left = splitter.right
            secondItem.anchors.right = root.right
            secondItem.anchors.bottom = root.bottom
        } else {
            firstItem.anchors.top = root.top
            firstItem.anchors.left = root.left
            firstItem.anchors.right = root.right
            firstItem.anchors.bottom = splitter.top

            secondItem.anchors.top = splitter.bottom
            secondItem.anchors.left = root.left
            secondItem.anchors.right = root.right
            secondItem.anchors.bottom = root.bottom
        }
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
            anchors.fill: parent
            anchors.margins: horizontal ? -4 : 0
            width: horizontal ? parent.width : parent.width + 8
            height: horizontal ? parent.height + 8 : parent.height
            hoverEnabled: true
            cursorShape: horizontal ? Qt.SplitHCursor : Qt.SplitVCursor

            property real startPos: 0
            property real startSplit: 0

            onPressed: {
                startPos = horizontal ? mouseX : mouseY
                startSplit = splitPosition
            }

            onPositionChanged: {
                if (!pressed) return
                var currentPos = horizontal ? mouseX : mouseY
                var totalSize = horizontal ? root.width : root.height
                var delta = currentPos - startPos
                var newSplit = startSplit + (delta / totalSize)

                var minFrac = root.minimumSize / totalSize
                newSplit = Math.max(minFrac, Math.min(1.0 - minFrac, newSplit))
                splitPosition = newSplit
            }
        }
    }
}
