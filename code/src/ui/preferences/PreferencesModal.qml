import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import untitled

Popup {
    id: preferencesModal
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

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Categories Sidebar
        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: 150
            color: Theme.surface
            
            ListView {
                anchors.fill: parent
                model: ["System", "Memory & GPU", "User & UI", "Media Storage", "Audio I/O"]
                delegate: ItemDelegate {
                    width: parent.width
                    text: modelData
                    font: Theme.defaultFont
                    contentItem: Text {
                        text: modelData
                        color: index === 1 ? Theme.sovereign : Theme.textPrimary
                    }
                    background: Rectangle {
                        color: index === 1 ? Theme.found : "transparent"
                    }
                }
            }
        }

        // Settings Content
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Theme.paddingLarge

                Text {
                    text: "Memory & GPU"
                    color: Theme.textPrimary
                    font: Theme.headerFont
                }
                
                Rectangle { Layout.fillWidth: true; height: 1; color: Theme.panel; Layout.bottomMargin: Theme.paddingMedium }
                
                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    rowSpacing: Theme.paddingMedium
                    columnSpacing: Theme.paddingMedium

                    Text { text: "GPU Processing Mode:"; color: Theme.textSecondary; font: Theme.defaultFont }
                    ComboBox { Layout.fillWidth: true; model: ["Auto", "CUDA", "OpenCL", "Metal"] }

                    Text { text: "Hardware Decoding:"; color: Theme.textSecondary; font: Theme.defaultFont }
                    CheckBox { text: "Use NVENC / VAAPI"; checked: true }

                    Text { text: "Limit System Memory:"; color: Theme.textSecondary; font: Theme.defaultFont }
                    RowLayout {
                        Layout.fillWidth: true
                        Slider { Layout.fillWidth: true; value: 16; from: 4; to: 32 }
                        Text { text: "16 GB"; color: Theme.textPrimary }
                    }
                }
                
                Item { Layout.fillHeight: true } // Spacer

                RowLayout {
                    Layout.fillWidth: true
                    Item { Layout.fillWidth: true }
                    Button { text: "Cancel"; onClicked: preferencesModal.close() }
                    Button { 
                        text: "Save"
                        background: Rectangle { color: Theme.sovereign; radius: Theme.radius }
                        contentItem: Text { text: parent.text; color: Theme.surface; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                        onClicked: preferencesModal.close() 
                    }
                }
            }
        }
    }
}
