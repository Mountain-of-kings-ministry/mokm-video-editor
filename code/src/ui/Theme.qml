pragma Singleton
import QtQuick

QtObject {
    // Core authority (Crown, Core Logic, Asset DB, Program Monitor)
    readonly property color sovereign: "#FFD700"

    // Active tools/nodes (Scopes, DAG Graph, OCIO, Marker List)
    readonly property color highlight: "#FFCC10"

    // Actions/Timeline (Edit Page, Keyframes, History Panel, Keyboard Map)
    readonly property color glimmer: "#E5B70A"

    // Component cards (Inspector, Effects Browser, Plugin Mgr)
    readonly property color panel: "#4E5360"

    // Base layers (Timeline background, Hardware Preferences, Proxy Dashboard, Rendering)
    readonly property color found: "#343840"

    // Deep space (Workspaces, Project Settings, Render Queue)
    readonly property color surface: "#1A1B1F"

    // Text colors
    readonly property color textPrimary: "#FFFFFF"
    readonly property color textSecondary: "#A0A0A0"
    readonly property color textDisabled: "#666666"

    // Generic geometry
    readonly property int radius: 6
    readonly property int paddingLarge: 20
    readonly property int paddingMedium: 10
    readonly property int paddingSmall: 5

    // Standard font
    readonly property font defaultFont: Qt.font({ family: "Inter", pixelSize: 13 })
    readonly property font defaultFontBold: Qt.font({ family: "Inter", pixelSize: 13, weight: Font.Bold })
    readonly property font headerFont: Qt.font({ family: "Inter", pixelSize: 18, weight: Font.Bold })
    readonly property font smallFont: Qt.font({ family: "Inter", pixelSize: 11 })
    readonly property font smallFontBold: Qt.font({ family: "Inter", pixelSize: 11, weight: Font.Bold })
}
