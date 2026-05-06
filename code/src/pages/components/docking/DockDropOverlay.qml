import QtQuick

Item {
    id: root
    visible: active
    z: 1000

    property bool active: false
    property string hoveredZone: ""

    readonly property real zoneWidth: Math.min(width * 0.3, 120)
    readonly property real zoneHeight: Math.min(height * 0.3, 100)

    // Center zone (tab into existing)
    Rectangle {
        id: centerZone
        anchors.centerIn: parent
        width: root.width * 0.4
        height: root.height * 0.4
        color: root.hoveredZone === "center" ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.15) : Qt.rgba(Theme.foreground.r, Theme.foreground.g, Theme.foreground.b, 0.03)
        border.width: 2
        border.color: root.hoveredZone === "center" ? Theme.accent : Qt.rgba(Theme.foreground.r, Theme.foreground.g, Theme.foreground.b, 0.1)
        radius: 8
        opacity: root.active ? 1 : 0

        Behavior on opacity {
            NumberAnimation { duration: 100 }
        }

        Text {
            anchors.centerIn: parent
            text: "Tab"
            color: Theme.muted
            font.pixelSize: 12
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: root.hoveredZone = "center"
            onExited: if (root.hoveredZone === "center") root.hoveredZone = ""
        }
    }

    // Top zone
    Rectangle {
        id: topZone
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: root.zoneHeight
        color: root.hoveredZone === "top" ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.15) : Qt.rgba(Theme.foreground.r, Theme.foreground.g, Theme.foreground.b, 0.03)
        border.width: root.hoveredZone === "top" ? 2 : 0
        border.color: Theme.primary
        radius: root.hoveredZone === "top" ? 6 : 0

        Text {
            anchors.centerIn: parent
            text: "Dock Top"
            color: Theme.muted
            font.pixelSize: 11
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: root.hoveredZone = "top"
            onExited: if (root.hoveredZone === "top") root.hoveredZone = ""
        }
    }

    // Bottom zone
    Rectangle {
        id: bottomZone
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: root.zoneHeight
        color: root.hoveredZone === "bottom" ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.15) : Qt.rgba(Theme.foreground.r, Theme.foreground.g, Theme.foreground.b, 0.03)
        border.width: root.hoveredZone === "bottom" ? 2 : 0
        border.color: Theme.primary
        radius: root.hoveredZone === "bottom" ? 6 : 0

        Text {
            anchors.centerIn: parent
            text: "Dock Bottom"
            color: Theme.muted
            font.pixelSize: 11
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: root.hoveredZone = "bottom"
            onExited: if (root.hoveredZone === "bottom") root.hoveredZone = ""
        }
    }

    // Left zone
    Rectangle {
        id: leftZone
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: root.zoneWidth
        color: root.hoveredZone === "left" ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.15) : Qt.rgba(Theme.foreground.r, Theme.foreground.g, Theme.foreground.b, 0.03)
        border.width: root.hoveredZone === "left" ? 2 : 0
        border.color: Theme.primary
        radius: root.hoveredZone === "left" ? 6 : 0

        Text {
            anchors.centerIn: parent
            text: "Dock Left"
            color: Theme.muted
            font.pixelSize: 11
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: root.hoveredZone = "left"
            onExited: if (root.hoveredZone === "left") root.hoveredZone = ""
        }
    }

    // Right zone
    Rectangle {
        id: rightZone
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: root.zoneWidth
        color: root.hoveredZone === "right" ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.15) : Qt.rgba(Theme.foreground.r, Theme.foreground.g, Theme.foreground.b, 0.03)
        border.width: root.hoveredZone === "right" ? 2 : 0
        border.color: Theme.primary
        radius: root.hoveredZone === "right" ? 6 : 0

        Text {
            anchors.centerIn: parent
            text: "Dock Right"
            color: Theme.muted
            font.pixelSize: 11
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: root.hoveredZone = "right"
            onExited: if (root.hoveredZone === "right") root.hoveredZone = ""
        }
    }

    function contains(item, px, py) {
        if (!item) return false
        return px >= item.x && px <= item.x + item.width && py >= item.y && py <= item.y + item.height
    }

    function getZoneAt(px, py) {
        if (contains(centerZone, px, py)) return "center"
        if (contains(topZone, px, py)) return "top"
        if (contains(bottomZone, px, py)) return "bottom"
        if (contains(leftZone, px, py)) return "left"
        if (contains(rightZone, px, py)) return "right"
        return ""
    }

    function reset() {
        hoveredZone = ""
    }
}
