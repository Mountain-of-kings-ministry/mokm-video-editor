# MOKM Video Editor — QML UI Build Tasks

## Module Rename
- [x] Update `CMakeLists.txt` URI from `learConnection_2` to `mokm_video_editor`
- [x] Update `main.cpp` module load
- [x] Update `SplashScreen.qml` import
- [x] Update `Main.qml` import

## Components
- [x] `SidebarButton.qml`
- [x] `Sidebar.qml`
- [x] `ToolBar.qml`
- [x] `PanelHeader.qml`
- [x] `StatusBar.qml`
- [x] `TimelineRuler.qml`
- [x] `TimelineTrack.qml`
- [x] `NodeSocket.qml`

## Pages
- [x] `Main.qml` (rewrite as shell with sidebar + StackLayout)
- [x] `MediaBinPage.qml`
- [x] `EditorPage.qml`
- [x] `NodeEditorPage.qml`
- [x] `AudioPage.qml`
- [x] `CompositorPage.qml`
- [x] `HistoryPage.qml`
- [x] `RendererPage.qml`
- [x] `SettingsPage.qml`

## Build Config
- [x] Update `CMakeLists.txt` to register all new QML files

## Verification
- [x] Build completes successfully (62/62 steps, exit code 0)
