import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../core"

Popup {
    id: shortcutMapperModal
    width: 600
    height: 500
    modal: true
    anchors.centerIn: Overlay.overlay ? Overlay.overlay : parent
    
    background: Rectangle {
        color: Theme.found
        border.color: Theme.panel
        border.width: 1
        radius: Theme.radius
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.paddingLarge
        
        RowLayout {
            Layout.fillWidth: true
            Text {
                text: "Keyboard Customization"
                color: Theme.textPrimary
                font: Theme.headerFont
                Layout.fillWidth: true
            }
            TextField {
                placeholderText: "Search shortcuts..."
                Layout.preferredWidth: 200
            }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.panel; Layout.bottomMargin: Theme.paddingMedium }

        // Table Header
        Rectangle {
            Layout.fillWidth: true
            height: 30
            color: Theme.surface
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: Theme.paddingSmall
                Text { text: "Action"; color: Theme.textSecondary; font: Theme.smallFontBold; Layout.fillWidth: true }
                Text { text: "Shortcut"; color: Theme.textSecondary; font: Theme.smallFontBold; Layout.preferredWidth: 150 }
            }
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: [
                { action: "Play / Pause", key: "Space" },
                { action: "Cut at Playhead", key: "Ctrl + K" },
                { action: "Undo", key: "Ctrl + Z" },
                { action: "Redo", key: "Ctrl + Shift + Z" },
                { action: "Add Marker", key: "M" }
            ]
            
            delegate: Rectangle {
                width: parent.width
                height: 40
                color: index % 2 === 0 ? Theme.panel : Theme.found
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: Theme.paddingSmall
                    Text { text: modelData.action; color: Theme.textPrimary; font: Theme.defaultFont; Layout.fillWidth: true }
                    
                    TextField {
                        text: modelData.key
                        Layout.preferredWidth: 150
                        color: Theme.highlight
                        font.family: "Monospace"
                        background: Rectangle { color: Theme.surface; radius: 4; border.color: Theme.panel }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Item { Layout.fillWidth: true }
            Button { text: "Reset to Defaults" }
            Button {
                text: "Close"
                onClicked: shortcutMapperModal.close()
            }
        }
    }
}
