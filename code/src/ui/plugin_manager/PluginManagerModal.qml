import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import untitled

Popup {
    id: pluginManagerModal
    width: 650
    height: 450
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
                text: "Plugin Manager"
                color: Theme.textPrimary
                font: Theme.headerFont
                Layout.fillWidth: true
            }
            Button {
                text: "Scan for Plugins"
                background: Rectangle { color: Theme.highlight; radius: Theme.radius }
                contentItem: Text { text: parent.text; color: Theme.surface; font.bold: true }
            }
            Button {
                text: "Close"
                onClicked: pluginManagerModal.close()
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
                Text { text: "Plugin Name"; color: Theme.textSecondary; font: Theme.smallFontBold; Layout.preferredWidth: 200 }
                Text { text: "Type"; color: Theme.textSecondary; font: Theme.smallFontBold; Layout.preferredWidth: 80 }
                Text { text: "Status"; color: Theme.textSecondary; font: Theme.smallFontBold; Layout.preferredWidth: 80 }
                Text { text: "Path"; color: Theme.textSecondary; font: Theme.smallFontBold; Layout.fillWidth: true }
            }
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: [
                { name: "MOKM Basic Reverb", type: "VST3", status: "Loaded", path: "/usr/lib/vst3/mokm_reverb.vst3" },
                { name: "Pro Compressor", type: "CLAP", status: "Loaded", path: "/home/david/.clap/procomp.clap" },
                { name: "Magic Glow", type: "OFX", status: "Error", path: "/usr/OFX/Plugins/glow.ofx.bundle" }
            ]
            
            delegate: Rectangle {
                width: parent.width
                height: 40
                color: index % 2 === 0 ? Theme.panel : Theme.found
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: Theme.paddingSmall
                    Text { text: modelData.name; color: Theme.textPrimary; font: Theme.defaultFont; Layout.preferredWidth: 200 }
                    Text { text: modelData.type; color: Theme.textSecondary; font: Theme.smallFont; Layout.preferredWidth: 80 }
                    Text { text: modelData.status; color: modelData.status === "Error" ? "red" : Theme.sovereign; font: Theme.smallFont; Layout.preferredWidth: 80 }
                    Text { text: modelData.path; color: Theme.textSecondary; font: Theme.smallFont; Layout.fillWidth: true; elide: Text.ElideMiddle }
                }
            }
        }
    }
}
