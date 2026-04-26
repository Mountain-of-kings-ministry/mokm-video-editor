import QtQuick
import QtQuick.Controls
import QtQuick.Controls.impl
import QtQuick.Layouts
import untitled

Rectangle {
    id: effectsBrowser
    width: 300
    height: 500
    color: Theme.found

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.paddingMedium

        Text {
            text: "Effects Library"
            color: Theme.textPrimary
            font: Theme.headerFont
            Layout.fillWidth: true
        }

        TextField {
            placeholderText: "Search effects..."
            Layout.fillWidth: true
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
                spacing: Theme.paddingSmall

                component EffectCategory: ColumnLayout {
                    property string categoryName: "Category"
                    property var effectList: []
                    width: parent.width
                    spacing: 2
                    
                    Rectangle {
                        width: parent.width
                        height: 30
                        color: Theme.panel
                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: Theme.paddingSmall
                            IconImage {

                                color: Theme.textSecondary; source: "../icons/outline/folder.svg"
                                sourceSize.width: 16
                                sourceSize.height: 16
                            }
                            Text {
                                text: categoryName
                                color: Theme.textSecondary
                                font: Theme.smallFontBold
                            }
                        }
                    }
                    
                    Repeater {
                        model: effectList
                        delegate: ItemDelegate {
                            width: parent.width
                            height: 30
                            contentItem: RowLayout {
                                IconImage {

                                    color: Theme.textSecondary; source: "../icons/outline/wand.svg"
                                    sourceSize.width: 16
                                    sourceSize.height: 16
                                }
                                Text {
                                    text: modelData
                                    color: Theme.textPrimary
                                    font: Theme.defaultFont
                                }
                            }
                        }
                    }
                }

                EffectCategory {
                    categoryName: "Video Transitions"
                    effectList: ["Cross Dissolve", "Dip to Black", "Wipe"]
                }
                
                EffectCategory {
                    categoryName: "Video Effects (Frei0r)"
                    effectList: ["Gaussian Blur", "Sharpen", "Vignette"]
                }
                
                EffectCategory {
                    categoryName: "OpenFX"
                    effectList: ["Lens Flare", "Glow", "Chroma Key"]
                }
                
                EffectCategory {
                    categoryName: "Audio Transitions"
                    effectList: ["Constant Gain", "Constant Power"]
                }
            }
        }
    }
}
