import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import mokm_video_editor

Item {
    id: root

    signal panelClosed(var panel)
    signal panelFloated(int panelType, point dragStart)

    property var floatingWindows: []

    function createPanel(panelType, parentItem) {
        var comp = Qt.createComponent("qrc:/qt/qml/mokm_video_editor/src/pages/components/docking/DockPanel.qml")
        if (comp.status !== Component.Ready) {
            console.error("Failed to create DockPanel:", comp.errorString())
            return null
        }

        var panel = comp.createObject(parentItem, {
            "panelType": panelType
        })
        if (panel) panel.anchors.fill = parentItem

        panel.empty.connect(function() { root.removePanel(panel) })
        panel.floatRequested.connect(function(type, dragStart) { root.panelFloated(type, dragStart) })

        return panel
    }

    function createSplit(horizontal, parentItem) {
        var comp = Qt.createComponent("qrc:/qt/qml/mokm_video_editor/src/pages/components/docking/SplitContainer.qml")
        if (comp.status !== Component.Ready) {
            console.error("Failed to create SplitContainer:", comp.errorString())
            return null
        }

        var split = comp.createObject(parentItem, {
            "horizontal": horizontal
        })
        if (split) split.anchors.fill = parentItem

        return split
    }

    function loadDefaultLayout() {
        while (content.children.length > 0) {
            content.children[0].destroy()
        }

        var mainSplit = createSplit(false, content)
        var topSplit = createSplit(true, mainSplit.firstSection)
        var rightSplit = createSplit(true, topSplit.secondSection)

        createPanel(DockManager.mediaBin, topSplit.firstSection)
        createPanel(DockManager.preview, rightSplit.firstSection)
        createPanel(DockManager.properties, rightSplit.secondSection)
        createPanel(DockManager.timeline, mainSplit.secondSection)

        Qt.callLater(function() {
            mainSplit.splitPosition = 0.65
            topSplit.splitPosition = 0.25
            rightSplit.splitPosition = 0.65
        })
    }

    function findPanelAt(item, px, py) {
        if (!item || !item.visible) return null
        
        var mapped = root.mapToItem(item, px, py)
        if (mapped.x < 0 || mapped.x > item.width || mapped.y < 0 || mapped.y > item.height) {
            return null
        }

        if (item.hasOwnProperty("panelTypes")) {
            return item
        }

        for (var i = item.children.length - 1; i >= 0; i--) {
            var child = item.children[i]
            var found = findPanelAt(child, px, py)
            if (found) return found
        }
        
        return null
    }

    function getPanelAt(px, py) {
        return findPanelAt(content, px, py)
    }

    function removePanel(panel) {
        if (!panel) return
        var parentSection = panel.parent
        if (parentSection && parentSection.parent && parentSection.parent.hasOwnProperty("splitPosition")) {
            var splitContainer = parentSection.parent
            var otherSection = (parentSection === splitContainer.firstSection) ? splitContainer.secondSection : splitContainer.firstSection
            
            var childToKeep = otherSection.children.length > 0 ? otherSection.children[0] : null
            var splitParent = splitContainer.parent
            
            if (childToKeep) {
                childToKeep.parent = splitParent
                childToKeep.anchors.fill = splitParent
            }
            splitContainer.destroy()
        }
        panel.destroy()
    }

    function dockFloatingWindow(win, zone, targetPanel) {
        if (!win) return
        var panelType = win.panelType
        
        if (zone === "center" && targetPanel) {
            targetPanel.addPanel(panelType)
            win.close()
            win.destroy()
            return
        }

        if (!targetPanel) {
            targetPanel = findFirstPanel(content)
            if (!targetPanel) {
                createPanel(panelType, content)
                win.close()
                win.destroy()
                return
            }
        }

        var parentSection = targetPanel.parent
        var isHorizontal = (zone === "left" || zone === "right")
        var isFirst = (zone === "left" || zone === "top")

        var newSplit = createSplit(isHorizontal, parentSection)
        targetPanel.parent = null 

        if (isFirst) {
            createPanel(panelType, newSplit.firstSection)
            targetPanel.parent = newSplit.secondSection
            targetPanel.anchors.fill = newSplit.secondSection
            Qt.callLater(function() { newSplit.splitPosition = 0.3 })
        } else {
            targetPanel.parent = newSplit.firstSection
            targetPanel.anchors.fill = newSplit.firstSection
            createPanel(panelType, newSplit.secondSection)
            Qt.callLater(function() { newSplit.splitPosition = 0.7 })
        }
        
        win.close()
        win.destroy()
    }

    function findFirstPanel(item) {
        if (!item) return null
        if (item.hasOwnProperty("panelTypes")) return item
        for (var i = 0; i < item.children.length; i++) {
            var found = findFirstPanel(item.children[i])
            if (found) return found
        }
        return null
    }

    Item {
        id: content
        anchors.fill: parent
    }
}
