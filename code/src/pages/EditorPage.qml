import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import QtMultimedia
import mokm_video_editor

Item {
    id: editorPage

    DockRoot {
        id: dockRoot
        anchors.fill: parent

        Component.onCompleted: loadDefaultLayout()

        onPanelClosed: function(panel) {
            panel.destroy()
        }

        onPanelFloated: function(panel) {
            var comp = Qt.createComponent("qrc:/qt/qml/mokm_video_editor/src/pages/components/docking/FloatingWindow.qml")
            if (comp.status === Component.Ready) {
                var win = comp.createObject(editorPage, {
                    "panelType": panel.panelType,
                    "width": 600,
                    "height": 400
                })

                win.closeRequested.connect(function() {
                    dockRoot.createPanel(win.panelType, dockRoot.content)
                    win.destroy()
                })

                win.show()
            }

            panel.destroy()
        }
    }
}
