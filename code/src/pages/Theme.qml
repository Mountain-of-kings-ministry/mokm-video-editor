pragma Singleton
import QtQuick 2.15

QtObject {
    // Base
    readonly property color background: '#0f0f0f'
    readonly property color foreground: "#f8fafc"

    // Primary (Gold)
    readonly property color primary: "#eab308"
    readonly property color primaryHover: "#ca8a04"

    // Accent (Slate blue-ish like shadcn default)
    readonly property color accent: "#3b82f6"
    readonly property color accentHover: "#2563eb"

    // // Secondary surfaces
    // readonly property color secondary: "#0f172a"
    // readonly property color secondaryHover: "#1e293b"

    // // Muted / subtle UI
    // readonly property color muted: "#334155"
    // readonly property color mutedForeground: "#94a3b8"

    // // Borders & input
    // readonly property color border: "#1e293b"
    // readonly property color input: "#0f0f0f"

    // Secondary surfaces (slightly lighter than background)
    readonly property color secondary: "#1a1a1a"
    readonly property color secondaryHover: "#262626"

    // Muted / subtle UI (mid tones)
    readonly property color muted: "#404040"
    readonly property color mutedForeground: "#a3a3a3"

    // Borders & input (in-between layers)
    readonly property color border: "#2e2e2e"
    readonly property color input: "#1a1a1a"

    // States
    readonly property color success: "#22c55e"
    readonly property color warning: "#f59e0b"
    readonly property color error: "#ef4444"
}
