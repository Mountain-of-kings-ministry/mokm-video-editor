import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import QtMultimedia
import mokm_video_editor

Item {
    id: editorPage

    property var dragWindow: null

    DockRoot {
        id: dockRoot
        anchors.fill: parent

        Component.onCompleted: loadDefaultLayout()

        onPanelClosed: function(panel) {
            panel.destroy()
        }

        onPanelFloated: function(type, dragStart) {
            var comp = Qt.createComponent("qrc:/qt/qml/mokm_video_editor/src/pages/components/docking/FloatingWindow.qml")
            if (comp.status === Component.Ready) {
                var win = comp.createObject(editorPage, {
                    "panelType": type,
                    "width": 600,
                    "height": 400
                })

                var gPos = dockRoot.mapToGlobal(dragStart.x, dragStart.y)
                win.x = gPos.x - win.width / 2
                win.y = gPos.y - 10

                win.dockModeStarted.connect(function() {
                    editorPage.dragWindow = win
                    dropOverlay.active = true
                    dropOverlay.reset()
                })

                win.dockDragged.connect(function(screenX, screenY) {
                    var localPos = dockRoot.mapFromGlobal(screenX, screenY)
                    var targetPanel = dockRoot.getPanelAt(localPos.x, localPos.y)
                    
                    if (targetPanel) {
                        var panelPos = dockRoot.mapFromItem(targetPanel, 0, 0)
                        dropOverlay.x = panelPos.x
                        dropOverlay.y = panelPos.y
                        dropOverlay.width = targetPanel.width
                        dropOverlay.height = targetPanel.height
                        dropOverlay.visible = true
                        
                        var localDropPos = dropOverlay.mapFromGlobal(screenX, screenY)
                        dropOverlay.hoveredZone = dropOverlay.getZoneAt(localDropPos.x, localDropPos.y)
                    } else {
                        dropOverlay.visible = false
                        dropOverlay.hoveredZone = ""
                    }
                })

                win.dockModeEnded.connect(function() {
                    dropOverlay.active = false
                    if (editorPage.dragWindow && dropOverlay.hoveredZone !== "") {
                        var localPos = dockRoot.mapFromGlobal(win.lastDragX, win.lastDragY)
                        var targetPanel = dockRoot.getPanelAt(localPos.x, localPos.y)
                        dockRoot.dockFloatingWindow(editorPage.dragWindow, dropOverlay.hoveredZone, targetPanel)
                    }
                    editorPage.dragWindow = null
                })

                win.closeRequested.connect(function() {
                    win.destroy()
                })

                win.show()
            }
        }
    }

    DockDropOverlay {
        id: dropOverlay
        active: false
    }
}
