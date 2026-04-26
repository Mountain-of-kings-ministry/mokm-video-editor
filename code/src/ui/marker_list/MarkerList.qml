import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: markerList
    width: 400
    height: 500
    color: Theme.found
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.paddingMedium

        RowLayout {
            Layout.fillWidth: true
            Text {
                text: "Markers"
                color: Theme.highlight
                font: Theme.headerFont
                Layout.fillWidth: true
            }
            TextField {
                placeholderText: "Search..."
                Layout.preferredWidth: 150
            }
        }

        // Table Header
        Rectangle {
            Layout.fillWidth: true
            height: 30
            color: Theme.panel
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: Theme.paddingSmall
                Text { text: "Color"; color: Theme.textSecondary; font: Theme.smallFont; Layout.preferredWidth: 50 }
                Text { text: "Timecode"; color: Theme.textSecondary; font: Theme.smallFont; Layout.preferredWidth: 100 }
                Text { text: "Name / Notes"; color: Theme.textSecondary; font: Theme.smallFont; Layout.fillWidth: true }
            }
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 2
            
            model: [
                { time: "00:01:23:14", name: "Start of VFX Sequence", color: "cyan" },
                { time: "00:03:00:00", name: "Audio Sync Point", color: "magenta" },
                { time: "00:05:45:10", name: "Fix color grade here", color: "yellow" }
            ]
            
            delegate: Rectangle {
                width: parent.width
                height: 40
                color: Theme.surface
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: Theme.paddingSmall
                    
                    Rectangle {
                        width: 16; height: 16; radius: 8
                        color: modelData.color
                        border.color: Theme.found
                        Layout.preferredWidth: 50
                    }
                    Text { text: modelData.time; color: Theme.textPrimary; font: Theme.smallFont; Layout.preferredWidth: 100 }
                    Text { text: modelData.name; color: Theme.textPrimary; font: Theme.defaultFont; Layout.fillWidth: true }
                }
            }
        }
    }
}
