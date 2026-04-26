# Level 1 Implementation Plan — MOKM Video Editor

## Current State Analysis

### What Exists
- **UI Layer:** Fully mocked QML frontend with all 6 workspaces, panels, and modals using the dark/gold theme
- **Backend Skeleton:** `MokmProjectManager`, `MokmUndoManager`, `MediaBinModel`, `TimelineModel` — all singletons registered to QML
- **Build System:** CMake + Qt 6 QML module configured

### What's Missing for Level 1
- UI is **not connected** to backend models (mock data everywhere)
- `MediaBinModel` imports files but doesn't probe real metadata (no FFmpeg integration)
- `TimelineModel` has clips internally but **doesn't expose them to QML**
- No actual **video playback / frame decoding**
- No **editing operations** (cut, trim, razor, move clips)
- No **project serialization** for MediaBin/Timeline
- No **auto-save / crash recovery**
- `UndoManager` exists but **no undo commands** are implemented
- No **transition** system, **audio meters**, or **title tool**

---

## Phase A: FFmpeg Foundation & Media Probing (Week 1)
**Goal:** Real media metadata and thumbnail generation

| Task | File(s) | Details |
|------|---------|---------|
| A.1 FFmpeg CMake integration | `code/CMakeLists.txt`, `code/src/functions/ffmpeg_wrapper/CMakeLists.txt` | Find/link `libavcodec`, `libavformat`, `libavutil`, `libswscale` |
| A.2 `FFmpegMediaProbe` class | `code/src/functions/ffmpeg_wrapper/FFmpegMediaProbe.h/.cpp` | Probe resolution, duration, frame rate, codec, bit depth from any file |
| A.3 `FFmpegThumbnailer` class | `code/src/functions/ffmpeg_wrapper/FFmpegThumbnailer.h/.cpp` | Extract frame at 0s as QImage for bin thumbnails |
| A.4 Integrate probing into `MediaBinModel` | `MediaBinModel.cpp` | Replace mock metadata with real FFmpeg probes on `importMediaLocal()` |
| A.5 Add thumbnail role to `MediaBinModel` | `MediaBinModel.h/.cpp` | New `ThumbnailRole` returning `QImage` (convert to QVariant) |

---

## Phase B: Timeline Model Refactor — Expose Clips to QML (Week 1-2)
**Goal:** Timeline becomes data-driven

| Task | File(s) | Details |
|------|---------|---------|
| B.1 `TimelineClipModel` (nested) | `code/src/functions/timeline/TimelineClipModel.h/.cpp` | `QAbstractListModel` for clips within a track, exposed as `clips` property on each track |
| B.2 Refactor `TimelineModel` | `TimelineModel.h/.cpp` | Add `clips` role returning `QVariant` of `TimelineClipModel*`. Add `removeTrack()`, `moveClip()`, `trimClip()` |
| B.3 Connect VideoEditorWorkspace to real model | `VideoEditorWorkspace.qml` | Replace mock track rectangles with `Repeater` on `TimelineModel`, nested `Repeater` on `clips` |
| B.4 Playhead position model | `code/src/functions/timeline/PlayheadController.h/.cpp` | Singleton with `currentFrame`, `isPlaying`, `fps`. Drives playhead line + timecode display |

---

## Phase C: Core Editing Operations (Week 2-3)
**Goal:** Functional razor, trim, select, move

| Task | File(s) | Details |
|------|---------|---------|
| C.1 `AddClipCommand` (Undo) | `code/src/functions/core/commands/AddClipCommand.h/.cpp` | `QUndoCommand` that adds/removes clip from track |
| C.2 `RemoveClipCommand` (Undo) | `code/src/functions/core/commands/RemoveClipCommand.h/.cpp` | Undo-safe clip deletion |
| C.3 `MoveClipCommand` (Undo) | `code/src/functions/core/commands/MoveClipCommand.h/.cpp` | Change `startFrame` / `trackIndex` with undo |
| C.4 `TrimClipCommand` (Undo) | `code/src/functions/core/commands/TrimClipCommand.h/.cpp` | Adjust `sourceInFrame`, `sourceOutFrame`, `durationFrames` |
| C.5 `RazorTool` logic | `TimelineModel` slot `splitClipAtFrame(trackIndex, clipId, frame)` | Splits one clip into two adjacent clips at playhead |
| C.6 Tool palette state | `VideoEditorWorkspace.qml` | Bind tool buttons to `activeTool` property (Select, Razor, Trim) |
| C.7 Mouse interactions on clips | `VideoEditorWorkspace.qml` | Drag to move, edge-drag to trim, click+razor to split |

---

## Phase D: Project Serialization & Auto-Save (Week 3)
**Goal:** Projects are real and recoverable

| Task | File(s) | Details |
|------|---------|---------|
| D.1 Serialize `MediaBinModel` | `MokmProjectManager.cpp` | Write `m_items` array to JSON (id, path, proxy status, metadata) |
| D.2 Serialize `TimelineModel` | `MokmProjectManager.cpp` | Write tracks + clips array to JSON |
| D.3 Deserialize both models | `MokmProjectManager.cpp` | Rebuild `MediaBinModel` and `TimelineModel` from JSON on load |
| D.4 Auto-save timer | `MokmProjectManager` | `QTimer` every 60s → `autoSave()` to `.mokm.autosave` file |
| D.5 Crash recovery prompt | `main.cpp` / `Main.qml` | On startup, check for `.mokm.autosave`; prompt user to recover |
| D.6 Recent projects list | `MokmProjectManager` | `QStringList` property, persisted to QSettings |

---

## Phase E: Basic Playback & Preview (Week 3-4)
**Goal:** See actual video frames

| Task | File(s) | Details |
|------|---------|---------|
| E.1 `FFmpegFrameReader` class | `code/src/functions/ffmpeg_wrapper/FFmpegFrameReader.h/.cpp` | Decode frame at specific timestamp → `AVFrame` → `QImage` |
| E.2 `PreviewRenderer` singleton | `code/src/functions/rendering/PreviewRenderer.h/.cpp` | Manages `FFmpegFrameReader` for source/program monitors, emits `frameReady(QImage)` |
| E.3 Connect to Source Monitor | `VideoEditorWorkspace.qml` | `Image` element displaying `PreviewRenderer.currentFrame` |
| E.4 Connect to Program Monitor | `VideoEditorWorkspace.qml` | Same, but driven by timeline playhead position |
| E.5 Transport controls | `VideoEditorWorkspace.qml` | Play/pause/seek buttons bound to `PlayheadController` |

---

## Phase F: Level 1 Polish — Transitions, Audio Meters, Title Tool (Week 4)
**Goal:** Complete the Core Tier feature set

| Task | File(s) | Details |
|------|---------|---------|
| F.1 Crossfade transition | `code/src/functions/video/TransitionEngine.h/.cpp` | Simple dissolve between two overlapping clips on same track |
| F.2 Audio peak meter widget | `code/src/ui/audio_editor/AudioMeterWidget.qml` | Vertical bar with peak hold, driven by mock audio levels (real FFT later) |
| F.3 Basic title generator | `code/src/functions/video/TitleGenerator.h/.cpp` | Renders text to `QImage` using `QPainter`, injectable as clip |
| F.4 Title tool UI | `VideoEditorWorkspace.qml` toolbar | Button to add title clip to selected track |
| F.5 History panel wiring | `HistoryPanel.qml` | Bind `ListView` to `UndoManager.stack` via `cleanIndex`, display action texts |
| F.6 Marker system | `code/src/functions/timeline/MarkerModel.h/.cpp` | Simple list of `{timecode, label, color}` bound to timeline ruler |

---

## Deliverables at End of Level 1

| Feature | Status After Plan |
|---------|-----------------|
| Multi-track timeline | ✅ Data-driven, QML-bound, add/remove tracks |
| Frame-accurate cutting | ✅ Razor tool splits clips with undo |
| Trimming | ✅ Edge-drag trim with undo |
| Media Bin | ✅ Real FFmpeg-probed metadata + thumbnails |
| Import/export formats | ✅ Any FFmpeg-readable format |
| Standard transitions | ✅ Crossfade dissolve |
| Audio level monitoring | ✅ Peak meter UI (real levels in Level 2) |
| Basic text/title | ✅ Add generated text clips to timeline |
| Playback/scrubbing | ✅ Source + Program monitors show real frames |
| Project save/load | ✅ Full serialization + auto-save + crash recovery |
| Undo/Redo | ✅ All editing actions are undoable |
| History panel | ✅ Visual undo stack |

---

## Files to Create/Modify Summary

### New C++ Classes (~15 files)
- `FFmpegMediaProbe`, `FFmpegThumbnailer`, `FFmpegFrameReader`
- `TimelineClipModel`, `PlayheadController`, `MarkerModel`
- `PreviewRenderer`, `TransitionEngine`, `TitleGenerator`
- `AddClipCommand`, `RemoveClipCommand`, `MoveClipCommand`, `TrimClipCommand`

### Modified C++ Classes (~4 files)
- `MediaBinModel` (add thumbnail role, real probing)
- `TimelineModel` (expose clips, add editing slots)
- `MokmProjectManager` (full serialization, auto-save)
- `main.cpp` (register new singletons)

### Modified QML Files (~6 files)
- `MediaBinWorkspace.qml` (bind to real model, show thumbnails)
- `VideoEditorWorkspace.qml` (bind timeline to model, tools, playback)
- `HistoryPanel.qml` (bind to undo stack)
- `AudioMixingWorkspace.qml` (add peak meters)

---

*Plan generated for MOKM Video Editor — Level 1 Core Tier*

