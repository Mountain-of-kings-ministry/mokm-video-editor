# CMake Structure Setup - TODO

## Step 1 — Fix Root & Top-Level CMakeLists.txt
- [x] Fix root `CMakeLists.txt` QML path
- [x] Enhance `src/CMakeLists.txt` with target linking

## Step 2 — Fill Parent CMakeLists.txt
- [ ] `src/ui/CMakeLists.txt` — add all UI subdirectories
- [ ] `src/functions/CMakeLists.txt` — add all function subdirectories (fix missing animation)
- [ ] `src/third_party/CMakeLists.txt` — add placeholder structure

## Step 3 — Fill Existing Empty Leaf CMakeLists.txt
- [ ] `src/ui/audio_editor/CMakeLists.txt`
- [ ] `src/ui/color_grading_editor/CMakeLists.txt`
- [ ] `src/ui/export_page/CMakeLists.txt`
- [ ] `src/ui/node_editor/CMakeLists.txt`
- [ ] `src/ui/preferences/CMakeLists.txt`
- [ ] `src/ui/project_settings/CMakeLists.txt`
- [ ] `src/ui/proxy_manager/CMakeLists.txt`
- [ ] `src/ui/video_editor/CMakeLists.txt`
- [ ] `src/functions/animation/CMakeLists.txt`
- [ ] `src/functions/audio/CMakeLists.txt`
- [ ] `src/functions/nodes/CMakeLists.txt`
- [ ] `src/functions/plugins/CMakeLists.txt`
- [ ] `src/functions/video/CMakeLists.txt`

## Step 4 — Create Missing UI Folders + CMakeLists.txt + Readme
- [ ] `src/ui/media_bin/`
- [ ] `src/ui/timeline/`
- [ ] `src/ui/attribute_inspector/`
- [ ] `src/ui/keyframe_editor/`
- [ ] `src/ui/marker_list/`
- [ ] `src/ui/effects_browser/`
- [ ] `src/ui/history_panel/`
- [ ] `src/ui/plugin_manager/`
- [ ] `src/ui/keyboard_shortcuts/`

## Step 5 — Create Missing Function Folders + CMakeLists.txt + Readme
- [ ] `src/functions/core/`
- [ ] `src/functions/rendering/`
- [ ] `src/functions/database/`
- [ ] `src/functions/ffmpeg_wrapper/`
- [ ] `src/functions/proxy/`
- [ ] `src/functions/timeline/`

## Step 6 — Verify
- [ ] All directories linked in CMake graph
- [ ] No empty CMakeLists.txt remain

