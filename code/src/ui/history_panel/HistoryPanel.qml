import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import untitled

Rectangle {
    id: historyPanel
    width: 250
    height: 400
    color: Theme.found

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.paddingMedium

        RowLayout {
            Layout.fillWidth: true
            
            Text {
                text: "History"
                color: Theme.textPrimary
                font: Theme.headerFont
                Layout.fillWidth: true
            }
            
            ToolButton {
                icon.source: "../icons/outline/arrow-back-up.svg"
                // Undo
            }
            ToolButton {
                icon.source: "../icons/outline/arrow-forward-up.svg"
                // Redo
            }
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 2
            
            model: [
                { action: "Open Project", isUndoable: false },
                { action: "Add Clip 'V1'", isUndoable: true },
                { action: "Split Clip", isUndoable: true },
                { action: "Apply Cross Dissolve", isUndoable: true },
                { action: "Change Offset (Color)", isUndoable: true }
            ]
            
            delegate: Rectangle {
                width: parent.width
                height: 36
                color: Theme.panel
                radius: Theme.radius
                
                // Highlight the current state (mock logic: last item)
                border.color: index === 4 ? Theme.glimmer : "transparent"
                border.width: 1
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: Theme.paddingSmall
                    
                    Rectangle {
                        width: 8; height: 8; radius: 4
                        color: Theme.surface
                    }
                    
                    Text {
                        text: modelData.action
                        color: Theme.textPrimary
                        font: Theme.defaultFont
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}
