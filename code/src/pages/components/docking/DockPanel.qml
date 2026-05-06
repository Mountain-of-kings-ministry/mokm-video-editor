import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import mokm_video_editor

Rectangle {
    id: root
    color: Theme.background
    border.width: 1
    border.color: Theme.border
    radius: 4

    property var panelTypes: []
    property int activeIndex: -1
    property bool isFloating: false

    property bool _isReady: false

    Component.onCompleted: {
        _isReady = true
        syncPanels()
    }

    // Compatibility for existing createPanel calls temporarily
    property int panelType: -1
    onPanelTypeChanged: {
        if (panelType >= 0 && panelTypes.length === 0) {
            panelTypes = [panelType]
            activeIndex = 0
        }
    }

    signal closeRequested()
    signal floatRequested(int panelType, point dragStart)
    signal empty()

    readonly property var panelSources: [
        "qrc:/qt/qml/mokm_video_editor/src/pages/components/panels/PreviewPanel.qml",
        "qrc:/qt/qml/mokm_video_editor/src/pages/components/panels/MiniBin.qml",
        "qrc:/qt/qml/mokm_video_editor/src/pages/components/panels/PropertiesPanel.qml",
        "qrc:/qt/qml/mokm_video_editor/src/pages/components/panels/NodePanel.qml",
        "qrc:/qt/qml/mokm_video_editor/src/pages/components/panels/TimelinePanel.qml"
    ]

    property var panelInstances: []

    onPanelTypesChanged: {
        if (_isReady) syncPanels()
    }

    onActiveIndexChanged: {
        if (_isReady) updateVisibility()
    }

    function syncPanels() {
        if (!contentAreaItem) return
        var newInstances = []
        for (var i = 0; i < panelTypes.length; i++) {
            var type = panelTypes[i]
            var existing = null
            for (var j = 0; j < panelInstances.length; j++) {
                if (panelInstances[j] && panelInstances[j].type === type) {
                    existing = panelInstances[j]
                    panelInstances.splice(j, 1)
                    break
                }
            }
            if (existing) {
                newInstances.push(existing)
            } else {
                var source = panelSources[type]
                if (source) {
                    var comp = Qt.createComponent(source)
                    if (comp.status === Component.Ready) {
                        var obj = comp.createObject(contentAreaItem, {
                            "visible": false
                        })
                        if (obj) {
                            obj.anchors.fill = contentAreaItem
                            newInstances.push({ obj: obj, type: type })
                        }
                    } else {
                        console.error("Failed to load panel:", comp.errorString())
                    }
                }
            }
        }

        for (var k = 0; k < panelInstances.length; k++) {
            if (panelInstances[k] && panelInstances[k].obj) {
                panelInstances[k].obj.destroy()
            }
        }

        panelInstances = newInstances

        if (activeIndex >= panelTypes.length) {
            activeIndex = panelTypes.length - 1
        } else if (activeIndex < 0 && panelTypes.length > 0) {
            activeIndex = 0
        }

        updateVisibility()
        
        if (panelTypes.length === 0) {
            root.empty()
        }
    }

    function updateVisibility() {
        for (var i = 0; i < panelInstances.length; i++) {
            if (panelInstances[i] && panelInstances[i].obj) {
                panelInstances[i].obj.visible = (i === root.activeIndex)
            }
        }
    }

    function addPanel(type) {
        var types = panelTypes.slice()
        if (types.indexOf(type) === -1) {
            types.push(type)
            panelTypes = types
            activeIndex = types.length - 1
        } else {
            activeIndex = types.indexOf(type)
        }
    }

    function removePanel(index) {
        var types = panelTypes.slice()
        if (index >= 0 && index < types.length) {
            types.splice(index, 1)
            panelTypes = types
        }
    }

    DockTabBar {
        id: tabBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        panels: root.panelTypes
        activeIndex: root.activeIndex

        onTabClicked: function(index) {
            root.activeIndex = index
        }
        onTabClosed: function(index) {
            root.removePanel(index)
        }
        onTabDragged: function(index, dragStart) {
            var type = root.panelTypes[index]
            root.removePanel(index)
            root.floatRequested(type, dragStart)
        }
    }

    Item {
        id: contentAreaItem
        anchors.top: tabBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        clip: true
    }
}
