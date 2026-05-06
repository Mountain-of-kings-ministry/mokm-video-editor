import QtQuick

MouseArea {
    id: root

    property string orientation: "horizontal"
    property real splitPosition: 0.5
    property real minimumSize: 50

    hoverEnabled: true
    cursorShape: orientation === "horizontal" ? Qt.SplitHCursor : Qt.SplitVCursor

    // Size based on orientation
    width: orientation === "horizontal" ? 2 : parent.width
    height: orientation === "horizontal" ? parent.height : 2

    Rectangle {
        anchors.fill: parent
        color: root.containsMouse ? Theme.primary : Theme.border
        opacity: root.containsMouse ? 1.0 : 0.5
    }

    property real startPos: 0
    property real startSplit: 0

    onPressed: {
        startPos = orientation === "horizontal" ? mouse.x : mouse.y
        startSplit = splitPosition

        // Get parent total size
        if (orientation === "horizontal") {
            startPos = root.mapToItem(parent.parent, mouse.x, mouse.y).x
        } else {
            startPos = root.mapToItem(parent.parent, mouse.x, mouse.y).y
        }
    }

    onPositionChanged: {
        if (!pressed) return

        var currentPos = orientation === "horizontal" ?
            root.mapToItem(parent.parent, mouse.x, mouse.y).x :
            root.mapToItem(parent.parent, mouse.x, mouse.y).y

        var parentSize = orientation === "horizontal" ? parent.parent.width : parent.parent.height
        var delta = currentPos - startPos
        var newSplit = startSplit + (delta / parentSize)

        // Clamp with minimum sizes
        var firstMin = minimumSize / parentSize
        var secondMin = minimumSize / parentSize
        newSplit = Math.max(firstMin, Math.min(1.0 - secondMin, newSplit))

        splitPosition = newSplit
    }
}
