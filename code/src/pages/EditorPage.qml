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
            var winComp = Qt.createComponent("qrc:/qt/qml/mokm_video_editor/src/pages/components/docking/FloatingWindow.qml")
            if (winComp.status === Component.Ready) {
                var win = winComp.createObject(editorPage, {
                    "panelType": panel.panelType,
                    "width": 600,
                    "height": 400
                })

                win.closeRequested.connect(function() {
                    var panelComp = Qt.createComponent("qrc:/qt/qml/mokm_video_editor/src/pages/components/docking/DockPanel.qml")
                    if (panelComp.status === Component.Ready) {
                        var newPanel = panelComp.createObject(dockRoot, {
                            "panelType": win.panelType
                        })
                        dockRoot.loadPanelContent(newPanel)
                    }
                    win.destroy()
                })

                win.show()
            }

            panel.destroy()
        }
    }
}
