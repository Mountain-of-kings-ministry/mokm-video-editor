import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// C++ integration — uncomment when bridging backend:
// import kingClass

import mokm_video_editor

Window {
    id: mainWindow
    width: 1280
    height: 800
    minimumWidth: 960
    minimumHeight: 600
    visible: true
    title: qsTr("MOKM Video Editor")

    color: Theme.background

    // C++ integration — uncomment when bridging backend:
    // SomeClass {
    //     id: someClass
    // }
    //
    // Connections {
    //     target: someClass
    //     onManagerChanged: { /* handle state change */ }
    // }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Sidebar navigation
        Sidebar {
            id: sidebar
            Layout.fillHeight: true

            onPageSelected: function (index) {
                contentStack.currentIndex = index;
            }
        }

        // Main content area
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            StackLayout {
                id: contentStack
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: 0

                MediaBinPage {}
                EditorPage {}
                NodeEditorPage {}
                AudioPage {}
                CompositorPage {}
                HistoryPage {}
                RendererPage {}
                SettingsPage {}
            }

            // Status bar
            StatusBar {
                Layout.fillWidth: true
                projectName: "MOKM Project"
            }
        }
    }
}
