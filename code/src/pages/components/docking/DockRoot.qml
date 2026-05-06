import QtQuick
import QtQuick.Layouts
import mokm_video_editor

Item {
    id: root

    property var layoutTree: null

    signal panelClosed(var panel)
    signal panelFloated(var panel)

    // Build layout from tree structure
    function buildLayout(tree) {
        // Clear existing children
        for (var i = content.children.length - 1; i >= 0; i--) {
            content.children[i].destroy()
        }

        if (!tree) return
        content.children = []
        buildNode(tree, content)
    }

    function buildNode(node, parent) {
        if (node.type === "panel") {
            return createPanel(node.panelType, parent)
        } else if (node.type === "split") {
            var split = createSplitNode(node.orientation, parent)
            var firstChild = buildNode(node.first, split)
            var secondChild = buildNode(node.second, split)

            // Set sizes based on split position
            if (node.orientation === "horizontal") {
                firstChild.Layout.fillWidth = false
                firstChild.Layout.fillHeight = true
                firstChild.Layout.preferredWidth = node.splitPosition * parent.width
                secondChild.Layout.fillWidth = true
                secondChild.Layout.fillHeight = true
            } else {
                firstChild.Layout.fillWidth = true
                firstChild.Layout.fillHeight = false
                firstChild.Layout.preferredHeight = node.splitPosition * parent.height
                secondChild.Layout.fillWidth = true
                secondChild.Layout.fillHeight = true
            }

            return split
        }
        return null
    }

    function createPanel(panelType, parent) {
        var component = Qt.createComponent("qrc:/qt/qml/mokm_video_editor/src/pages/components/docking/DockPanel.qml")
        if (component.status !== Component.Ready) {
            console.error("Failed to create DockPanel:", component.errorString())
            return null
        }

        var panel = component.createObject(parent, {
            "panelType": panelType,
            "Layout.fillWidth": true,
            "Layout.fillHeight": true
        })

        panel.closeRequested.connect(function(p) {
            root.panelClosed(p)
        })

        panel.floatRequested.connect(function(p) {
            root.panelFloated(p)
        })

        panel.typeChanged.connect(function(p, newType) {
            p.panelType = newType
            loadPanelContent(p)
        })

        loadPanelContent(panel)
        return panel
    }

    function createSplitNode(orientation, parent) {
        var qml = orientation === "horizontal" ?
            "import QtQuick.Layouts; RowLayout { anchors.fill: parent; spacing: 0 }" :
            "import QtQuick.Layouts; ColumnLayout { anchors.fill: parent; spacing: 0 }"

        return Qt.createQmlObject(qml, parent, "splitNode")
    }

    function loadPanelContent(panel) {
        // Clear existing content
        for (var i = panel.contentArea.children.length - 1; i >= 0; i--) {
            panel.contentArea.children[i].destroy()
        }

        var panelSources = [
            "qrc:/qt/qml/mokm_video_editor/src/pages/components/panels/PreviewPanel.qml",
            "qrc:/qt/qml/mokm_video_editor/src/pages/components/panels/MiniBin.qml",
            "qrc:/qt/qml/mokm_video_editor/src/pages/components/panels/PropertiesPanel.qml",
            "qrc:/qt/qml/mokm_video_editor/src/pages/components/panels/NodePanel.qml",
            "qrc:/qt/qml/mokm_video_editor/src/pages/components/panels/TimelinePanel.qml"
        ]

        var source = panelSources[panel.panelType]
        if (!source) return

        var comp = Qt.createComponent(source)
        if (comp.status === Component.Ready) {
            comp.createObject(panel.contentArea, {
                "anchors.fill": panel.contentArea
            })
        } else {
            console.error("Failed to load panel content:", comp.errorString())
        }
    }

    // Default layout: top [MiniBin | Preview | Properties], bottom [Timeline]
    function loadDefaultLayout() {
        var tree = {
            type: "split",
            orientation: "vertical",
            splitPosition: 0.65,
            first: {
                type: "split",
                orientation: "horizontal",
                splitPosition: 0.33,
                first: {
                    type: "panel",
                    panelType: DockManager.mediaBin
                },
                second: {
                    type: "split",
                    orientation: "horizontal",
                    splitPosition: 0.67,
                    first: {
                        type: "panel",
                        panelType: DockManager.preview
                    },
                    second: {
                        type: "panel",
                        panelType: DockManager.properties
                    }
                }
            },
            second: {
                type: "panel",
                panelType: DockManager.timeline
            }
        }

        buildLayout(tree)
    }

    Item {
        id: content
        anchors.fill: parent
    }
}
