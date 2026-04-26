import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Mokm.Core 1.0
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
                icon.color: UndoManager.canUndo ? Theme.sovereign : Theme.textDisabled
                enabled: UndoManager.canUndo
                onClicked: UndoManager.undo()
            }
            ToolButton {
                icon.source: "../icons/outline/arrow-forward-up.svg"
                icon.color: UndoManager.canRedo ? Theme.sovereign : Theme.textDisabled
                enabled: UndoManager.canRedo
                onClicked: UndoManager.redo()
            }
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 2
            model: UndoManager.history
            delegate: Rectangle {
                id: historyItem
                width: parent.width
                height: 36
                color: Theme.panel
                radius: Theme.radius
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: Theme.paddingSmall
                    
                    Rectangle {
                        width: 8; height: 8; radius: 4
                        color: Theme.sovereign
                    }
                    
                    Text {
                        text: modelData
                        color: Theme.textPrimary
                        font: Theme.defaultFont
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}
