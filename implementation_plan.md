# MOKM Video Editor — Complete QML UI Implementation

Build all QML page shells and reusable components for the MOKM Video Editor, using the existing `Theme.qml` color system and tabler icon set from `qrc:/icons/outline/`.

## Proposed Changes

### Architecture Overview

```
Main.qml                    ← Main window with thin sidebar + StackLayout
├── components/
│   ├── SidebarButton.qml   ← Icon-only nav button (hover / active states)
│   ├── Sidebar.qml         ← Vertical icon strip
│   ├── ToolBar.qml         ← Reusable top toolbar row
│   ├── PanelHeader.qml     ← Section header with title
│   ├── StatusBar.qml       ← Bottom status info bar
│   ├── TimelineRuler.qml   ← Time ruler with markers
│   ├── TimelineTrack.qml   ← Single track row (clip blocks)
│   └── NodeSocket.qml      ← Node connection point
├── MediaBinPage.qml        ← File bin workspace
├── EditorPage.qml          ← Video editor with preview + timeline
├── NodeEditorPage.qml      ← Node-based compositing canvas
├── AudioPage.qml           ← Audio editor workspace
├── CompositorPage.qml      ← Compositor / effects page
├── HistoryPage.qml         ← History manager (list + node views)
├── RendererPage.qml        ← Render queue / export page
└── SettingsPage.qml        ← Settings list + options panel
```

---

### Component Layer (`code/src/pages/components/`)

#### [NEW] SidebarButton.qml
- Icon-only button (24×24 icon inside 48×48 hit-area)
- Properties: `iconSource`, `isActive`, `toolTipText`
- States: default (`Theme.secondary`), hovered (`Theme.secondaryHover`), active (left gold accent bar + `Theme.primary` tint on icon)
- Uses `Image` with `source: "qrc:/icons/outline/..."` and a colored overlay for active/hover

#### [NEW] Sidebar.qml
- Thin vertical bar (width ≈ 52px), background `Theme.background`
- `ColumnLayout` of `SidebarButton` items, one per page
- Icons chosen (all tabler outline):
  | Page | Icon |
  |------|------|
  | Media Bin | `folder.svg` |
  | Editor | `video.svg` |
  | Node Editor | `topology-star-3.svg` |
  | Audio | `music.svg` |
  | Compositor | `layers-subtract.svg` |
  | History | `history.svg` |
  | Renderer | `device-desktop.svg` |
  | Settings | `settings.svg` |
- Emits `pageSelected(int index)` signal → drives `StackLayout.currentIndex`

#### [NEW] ToolBar.qml
- Horizontal bar (height ≈ 36px), background `Theme.secondary`, border-bottom `Theme.border`
- Slot `default property alias content` for page-specific tool buttons

#### [NEW] PanelHeader.qml
- Small label row with `title` property, `Theme.mutedForeground` text, optional left colored accent

#### [NEW] StatusBar.qml
- Bottom 28px bar, `Theme.secondary` background, shows project info / playback position

#### [NEW] TimelineRuler.qml
- Horizontal ruler with tick marks drawn via `Canvas` or `Repeater`, `Theme.muted` lines, `Theme.mutedForeground` labels

#### [NEW] TimelineTrack.qml
- Row representing a timeline track, contains placeholder clip rectangles with rounded corners, colored with `Theme.accent` / `Theme.primary`

#### [NEW] NodeSocket.qml
- Small circle (input/output port) used in node editor, colored `Theme.accent`

---

### Page Layer (`code/src/pages/`)

#### [MODIFY] Main.qml
- Complete rewrite as the application shell
- Layout: `RowLayout` → `Sidebar` (left) + `StackLayout` (right, fills remaining space)
- StackLayout pages indexed 0–7 matching sidebar buttons
- Window title: `"MOKM Effector"`
- `flags: Qt.Window` (normal window)
- Remove old test content (`SomeClass`, `Connections`, test button)

#### [NEW] MediaBinPage.qml — *Design ref: window_system.svg (top section)*
- **Without preview**: Two-panel split
  - Left panel: Folder tree list (`ListView` with folder icons)
  - Right panel: File grid/list view (switchable via toolbar toggle)
- **With preview**: Three-panel split adds a right preview pane
- Top toolbar: search, view-mode toggle (grid/list), import button
- Files shown as thumbnail cards (grid) or rows (list)

#### [NEW] EditorPage.qml — *Design ref: window_system.svg (middle section)*
- Top half: Video preview area (dark rectangle with playback controls beneath)
- Bottom half: Timeline with ruler + multiple tracks
- Toolbar above timeline: cut, trim, split, snap, zoom icons

#### [NEW] NodeEditorPage.qml — *Design ref: window_system.svg (node editor section)*
- Full canvas area for node graph (dark background with subtle grid)
- Top toolbar with node tools
- Placeholder nodes: Source, Transform, Color, Output — connected by bezier curves (drawn in `Canvas`)
- Each node is a rounded `Rectangle` with `PanelHeader`, input/output `NodeSocket` items

#### [NEW] AudioPage.qml — *Design ref: audio_system.svg*
- Left panel: Video preview (small) + timeline/automation view below
- Right panel: Swappable between:
  - **Graph & Plugin list**: Volume sliders, plugin chain
  - **Automation graph**: Keyframe curve editor placeholder
  - **Node view**: Audio effects node graph
- Track volume sliders with master volume

#### [NEW] CompositorPage.qml — *Derived from README (Advanced Compositing)*
- Similar structure to Node Editor but focused on compositing layers
- Layer stack on left, canvas/preview on right
- Toolbar: blend modes, masking tools, transform

#### [NEW] HistoryPage.qml — *Design ref: history_system.svg + window_system.svg (history section)*
- Two view modes (toggled via toolbar):
  - **List view**: Simple action list with timestamps (rows with time + description)
  - **Node view**: Non-destructive node-based history tree
- Top toolbar with view-type toggle, undo/redo buttons
- Tracks history per-track for non-destructive fallback

#### [NEW] RendererPage.qml — *Design ref: rendering_system.svg + window_system.svg (renderer section)*
- Left panel: Task/queue list (render jobs with status)
- Right panel: Current render info — file details, progress bar, time remaining, proxy metadata cards
- Bottom: Destination path selector

#### [NEW] SettingsPage.qml — *Design ref: settings_system.svg*
- Left panel: Settings category list (General, Proxy, Playback, Plugins, Shortcuts, etc.)
- Right panel: Settings options for selected category
- Proxy section shows:
  - Current proxy queue with metadata cards (codec, resolution, bit depth)
  - Auto-import toggle
  - Processing time stamp and range

---

### Design Tokens & Style Rules

| Element | Value |
|---------|-------|
| Sidebar width | 52px |
| Sidebar icon size | 24px |
| Toolbar height | 36px |
| StatusBar height | 28px |
| Border radius (panels) | 8px |
| Border radius (buttons) | 6px |
| Font family | System default (Qt) |
| Font size (labels) | 13px |
| Font size (headers) | 15px |
| Spacing (panel gaps) | 2px |
| All colors | via `Theme.*` singleton |

---

## Open Questions

> [!IMPORTANT]
> 1. **C++ backend removal**: The current `Main.qml` imports `kingClass` and `learConnection_2` — should I keep those imports as stubs, or strip them entirely since this is UI-only?
> 2. **QML module path**: The `Theme.qml` singleton is accessed via `learConnection_2` module. Should I keep the same module URI or rename it to something like `mokm.ui`?
> 3. **Icon verification**: I'm selecting icons from the tabler outline set already in `resources.qrc`. If any specific icon names are wrong (e.g., `topology-star-3.svg`), I'll adjust. Want me to list all icon choices first?

---

## Verification Plan

### Manual Verification
- Build and run the application (`cmake --build` + execute)
- Navigate all sidebar pages and verify each renders
- Check hover/active states on sidebar buttons
- Verify Theme colors are consistently applied
- Screenshot each page for visual review
