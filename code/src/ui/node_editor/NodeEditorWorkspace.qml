import QtQuick
import QtQuick.Controls
import QtQuick.Controls.impl
import QtQuick.Layouts

Item {
    id: nodeEditorWorkspace
    anchors.fill: parent

    SplitView {
        anchors.fill: parent
        orientation: Qt.Horizontal

        // Left sidebar: Node Library
        Rectangle {
            SplitView.preferredWidth: 250
            SplitView.minimumWidth: 150
            color: Theme.found

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Theme.paddingMedium

                Text {
                    text: "Node Library"
                    color: Theme.sovereign
                    font: Theme.headerFont
                    Layout.fillWidth: true
                }
                
                TextField {
                    Layout.fillWidth: true
                    placeholderText: "Search nodes..."
                    color: Theme.textPrimary
                    background: Rectangle {
                        color: Theme.surface
                        radius: Theme.radius
                    }
                }
                
                ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    
                    ColumnLayout {
                        width: parent.width
                        spacing: 2
                        
                        Repeater {
                            model: ["Generators", "Color", "Blur", "Transform", "Composite"]
                            delegate: ColumnLayout {
                                width: parent.width
                                spacing: 0
                                
                                Rectangle {
                                    width: parent.width
                                    height: 30
                                    color: Theme.panel
                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.left: parent.left
                                        anchors.leftMargin: Theme.paddingSmall
                                        text: modelData
                                        color: Theme.textSecondary
                                        font: Theme.smallFontBold
                                    }
                                }
                                
                                Repeater {
                                    model: 3
                                    delegate: ItemDelegate {
                                        width: parent.width
                                        height: 30
                                        contentItem: RowLayout {
                                            IconImage {

                                                color: Theme.textSecondary; source: "../icons/outline/box.svg"
                                                Layout.preferredWidth: 16
                                                Layout.preferredHeight: 16
                                                sourceSize.width: 16
                                                sourceSize.height: 16
                                            }
                                            Text {
                                                text: modelData + " Node " + (index + 1)
                                                color: Theme.textPrimary
                                                font: Theme.defaultFont
                                                Layout.fillWidth: true
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // Center: Node Canvas
        Rectangle {
            SplitView.fillWidth: true
            color: Theme.surface
            clip: true

            // Grid background
            Grid {
                anchors.fill: parent
                rows: parent.height / 30
                columns: parent.width / 30
                Repeater {
                    model: parent.rows * parent.columns
                    delegate: Rectangle {
                        width: 30; height: 30
                        color: "transparent"
                        border.color: Qt.rgba(255, 255, 255, 0.05)
                        border.width: 1
                    }
                }
            }

            // Mock Nodes
            component MockNode: Rectangle {
                property string title: "Node"
                property color headerColor: Theme.panel
                width: 140
                height: 80
                color: Theme.found
                radius: Theme.radius
                border.color: Theme.panel
                border.width: 2
                
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0
                    
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 24
                        color: parent.parent.headerColor
                        radius: Theme.radius
                        // square off bottom corners
                        Rectangle {
                            width: parent.width; height: 4
                            anchors.bottom: parent.bottom
                            color: parent.parent.parent.headerColor
                        }
                        
                        Text {
                            anchors.centerIn: parent
                            text: parent.parent.parent.title
                            color: Theme.textPrimary
                            font: Theme.smallFontBold
                        }
                    }
                    
                    Item { Layout.fillHeight: true }
                }
                
                // In port
                Rectangle {
                    width: 12; height: 12; radius: 6
                    color: Theme.surface; border.color: Theme.highlight; border.width: 2
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.margins: -6
                }
                // Out port
                Rectangle {
                    width: 12; height: 12; radius: 6
                    color: Theme.surface; border.color: Theme.highlight; border.width: 2
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.margins: -6
                }
            }

            MockNode {
                x: 100; y: 200
                title: "Media In"
                headerColor: Theme.highlight
            }
            MockNode {
                x: 350; y: 150
                title: "Color Correct"
            }
            MockNode {
                x: 350; y: 250
                title: "Gaussian Blur"
            }
            MockNode {
                x: 600; y: 200
                title: "Merge"
            }
            MockNode {
                x: 850; y: 200
                title: "Media Out"
                headerColor: Theme.sovereign
            }

            // Mini Map mock on top right
            Rectangle {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: Theme.paddingMedium
                width: 150
                height: 100
                color: Theme.found
                border.color: Theme.panel
                border.width: 1
                radius: Theme.radius
                opacity: 0.8
                
                Text {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.margins: Theme.paddingSmall
                    text: "Mini Map"
                    color: Theme.textSecondary
                    font: Theme.smallFont
                }
            }
        }
    }
}
