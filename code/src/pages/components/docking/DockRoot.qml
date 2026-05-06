import QtQuick
import QtQuick.Layouts
import mokm_video_editor

Item {
    id: root

    signal panelClosed(var panel)
    signal panelFloated(var panel)

    function createPanel(panelType, parent) {
        var comp = Qt.createComponent("qrc:/qt/qml/mokm_video_editor/src/pages/components/docking/DockPanel.qml")
        if (comp.status !== Component.Ready) {
            console.error("Failed to create DockPanel:", comp.errorString())
            return null
        }

        var panel = comp.createObject(parent, {
            "panelType": panelType
        })

        panel.closeRequested.connect(function() { root.panelClosed(panel) })
        panel.floatRequested.connect(function() { root.panelFloated(panel) })

        return panel
    }

    function createSplit(horizontal, parent) {
        var comp = Qt.createComponent("qrc:/qt/qml/mokm_video_editor/src/pages/components/docking/SplitContainer.qml")
        if (comp.status !== Component.Ready) {
            console.error("Failed to create SplitContainer:", comp.errorString())
            return null
        }

        var split = comp.createObject(parent, {
            "horizontal": horizontal,
            "anchors.fill": parent
        })

        return split
    }

    function loadDefaultLayout() {
        while (content.children.length > 0) {
            content.children[0].destroy()
        }

        var mainSplit = createSplit(false, content)
        mainSplit.splitPosition = 0.65
        mainSplit.minimumSize = 100

        var topSplit = createSplit(true, mainSplit)
        topSplit.splitPosition = 0.25
        topSplit.minimumSize = 120

        var topRightSplit = createSplit(true, topSplit)
        topRightSplit.splitPosition = 0.65
        topRightSplit.minimumSize = 150

        var miniBin = createPanel(DockManager.mediaBin, topSplit)
        var preview = createPanel(DockManager.preview, topRightSplit)
        var properties = createPanel(DockManager.properties, topRightSplit)
        var timeline = createPanel(DockManager.timeline, mainSplit)

        topRightSplit.setItems(preview, properties)
        topSplit.setItems(miniBin, topRightSplit)
        mainSplit.setItems(topSplit, timeline)
    }

    Item {
        id: content
        anchors.fill: parent
    }
}
