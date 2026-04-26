import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Popup {
    id: projectSettingsModal
    width: 500
    height: 400
    modal: true
    anchors.centerIn: Overlay.overlay ? Overlay.overlay : parent
    
    background: Rectangle {
        color: Theme.surface
        border.color: Theme.found
        border.width: 1
        radius: Theme.radius
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.paddingLarge
        
        Text {
            text: "Project Settings"
            color: Theme.textPrimary
            font: Theme.headerFont
            Layout.fillWidth: true
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.found; Layout.bottomMargin: Theme.paddingMedium }

        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: Theme.paddingMedium
            columnSpacing: Theme.paddingMedium

            Text { text: "Timeline Resolution:"; color: Theme.textSecondary; font: Theme.defaultFont }
            ComboBox { Layout.fillWidth: true; model: ["1920 x 1080 (HD)", "3840 x 2160 (4K UHD)", "4096 x 2160 (4K DCI)"] }

            Text { text: "Timeline Frame Rate:"; color: Theme.textSecondary; font: Theme.defaultFont }
            ComboBox { Layout.fillWidth: true; model: ["23.976 fps", "24 fps", "25 fps", "29.97 fps", "59.94 fps", "60 fps"] }

            Text { text: "Color Science:"; color: Theme.textSecondary; font: Theme.defaultFont }
            ComboBox { Layout.fillWidth: true; model: ["DaVinci YRGB", "ACEScct", "MOKM Basic Rec.709"] }

            Text { text: "Proxy Resolution:"; color: Theme.textSecondary; font: Theme.defaultFont }
            ComboBox { Layout.fillWidth: true; model: ["Half Resolution", "Quarter Resolution", "Fixed: 720p"] }
        }

        Item { Layout.fillHeight: true } // Spacer

        RowLayout {
            Layout.fillWidth: true
            Item { Layout.fillWidth: true }
            Button {
                text: "Cancel"
                onClicked: projectSettingsModal.close()
            }
            Button {
                text: "Save"
                background: Rectangle { color: Theme.sovereign; radius: Theme.radius }
                contentItem: Text { text: parent.text; color: Theme.surface; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                onClicked: projectSettingsModal.close()
            }
        }
    }
}
