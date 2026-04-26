import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../core"

Rectangle {
    id: attributeInspector
    width: 300
    height: 600
    color: Theme.found

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.paddingMedium

        Text {
            text: "Inspector"
            color: Theme.textPrimary
            font: Theme.headerFont
            Layout.fillWidth: true
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ColumnLayout {
                width: parent.width
                spacing: Theme.paddingMedium

                // Transform Group
                Rectangle {
                    Layout.fillWidth: true
                    height: 30
                    color: Theme.panel
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: Theme.paddingSmall
                        text: "Transform"
                        color: Theme.sovereign
                        font: Theme.smallFontBold
                    }
                }

                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    rowSpacing: Theme.paddingSmall
                    columnSpacing: Theme.paddingSmall

                    Text { text: "Zoom:"; color: Theme.textSecondary; font: Theme.smallFont }
                    Slider { Layout.fillWidth: true; value: 1.0; from: 0.1; to: 3.0 }

                    Text { text: "Position X:"; color: Theme.textSecondary; font: Theme.smallFont }
                    SpinBox { Layout.fillWidth: true; value: 0; from: -5000; to: 5000 }

                    Text { text: "Position Y:"; color: Theme.textSecondary; font: Theme.smallFont }
                    SpinBox { Layout.fillWidth: true; value: 0; from: -5000; to: 5000 }

                    Text { text: "Rotation:"; color: Theme.textSecondary; font: Theme.smallFont }
                    Slider { Layout.fillWidth: true; value: 0; from: -360; to: 360 }
                }

                // Cropping Group
                Rectangle {
                    Layout.fillWidth: true
                    height: 30
                    color: Theme.panel
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: Theme.paddingSmall
                        text: "Cropping"
                        color: Theme.textPrimary
                        font: Theme.smallFontBold
                    }
                }

                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    rowSpacing: Theme.paddingSmall
                    columnSpacing: Theme.paddingSmall

                    Text { text: "Crop Left:"; color: Theme.textSecondary; font: Theme.smallFont }
                    Slider { Layout.fillWidth: true; value: 0; from: 0; to: 100 }

                    Text { text: "Crop Right:"; color: Theme.textSecondary; font: Theme.smallFont }
                    Slider { Layout.fillWidth: true; value: 0; from: 0; to: 100 }
                }

                // Opacity Group
                Rectangle {
                    Layout.fillWidth: true
                    height: 30
                    color: Theme.panel
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: Theme.paddingSmall
                        text: "Composite"
                        color: Theme.textPrimary
                        font: Theme.smallFontBold
                    }
                }

                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    rowSpacing: Theme.paddingSmall
                    columnSpacing: Theme.paddingSmall

                    Text { text: "Opacity:"; color: Theme.textSecondary; font: Theme.smallFont }
                    Slider { Layout.fillWidth: true; value: 100; from: 0; to: 100 }

                    Text { text: "Blend Mode:"; color: Theme.textSecondary; font: Theme.smallFont }
                    ComboBox { Layout.fillWidth: true; model: ["Normal", "Add", "Multiply", "Screen", "Overlay"] }
                }
            }
        }
    }
}
