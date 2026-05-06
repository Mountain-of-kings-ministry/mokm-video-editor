Development Plan for QML Advanced Docking System
Phase 1: Core Architecture & Data Modeling
The foundation must be a recursive data structure (C++ or JSON) that tracks the layout state.

Recursive Tree Model: Define a structure where a "Node" can be a Leaf (the actual tool/view) or a Parent (containing a SplitView with two or more child Nodes).

State Serialization: Create functions to save and load the layout tree to JSON, allowing the UI to persist between sessions.

Component Factory: Develop a Loader based system that instantiates specific tools (Timeline, Node Editor, Project Bin) based on a string ID in the model.

Phase 2: Visual Container Components
Instead of static layouts, create a single DockContainer component that handles all nesting.

Base DockTile: A component containing a TabBar and a StackLayout to manage multiple "tabs" within a single pane.

Recursive Splitter: A component that wraps SplitView. If a user splits a pane, the DockTile is replaced by a new SplitView containing the original tile and a new one.

Ghosting Overlay: A transparent layer that appears during drags to highlight "drop zones" (Top, Bottom, Left, Right, Center).

Phase 3: Drag and Drop Logic
This is the most complex phase, handling the physical movement of tabs.

Drag Initiation: Use a DragHandler on the TabBar buttons. When a drag starts, create a "Proxy" visual of the tab.

Drop Zone Detection: Use DropArea components inside the DockTile. Divide the tile into a 5-region grid (cross shape).

Center Drop: Adds the dragged item to the current TabBar.

Edge Drop (L/R/T/B): Triggers a "Split" event in the data model, inserting a new SplitView at that location.

Parent Re-parenting: Logic to remove the item from its old model position and insert it into the new one.

Phase 4: Modern Styling & UX
Refine the look to match the "Olive Video Editor" aesthetic.

Custom Splitter Handles: Style the SplitView handles to be thin, dark, and react to hover states.

Tab Styling: Implement close buttons (X), active/inactive states, and scrolling tab bars for when too many tools are docked together.

Floating Windows: Extend the drag logic so that dropping a tab outside the main window spawns a new Window QML type containing that tile.

Suggested Roadmap for AI Implementation
To build this effectively with an AI assistant, follow these steps in order:

Step 1: "Help me design a recursive C++ or QML JSON model that represents a nested SplitView layout with tabs."

Step 2: "Write a QML component called DockPane.qml that includes a custom TabBar and an area for content."

Step 3: "Create a DockContainer.qml that uses a Loader to recursively render the layout model using SplitView."

Step 4: "Implement the Drag-and-Drop logic to detect if a user is hovering over the top, bottom, or center of a DockPane."

Step 5: "Integrate the logic to update the data model when a drop is successful, causing the UI to re-render the new split."





########################
implimentation plan

# Advanced Docking System Implementation

This plan outlines the steps to upgrade the current QML docking system into an advanced, fully flexible docking layout similar to the Qt Advanced Docking System.

## Goal Description
Transform the existing basic panel layout into a robust docking system where panels can be rearranged in any direction (top, bottom, left, right) or grouped together as tabs (center). The system will dynamically split and collapse areas as panels are moved around or closed.

## User Review Required
> [!IMPORTANT]
> The advanced docking system requires changing how panels are stored in QML. Currently, each `DockPanel.qml` hosts exactly one view. Under the new design, `DockPanel.qml` will act as a **Dock Area** that can host *multiple* views using tabs.
> Please review the proposed split management (how areas automatically clean up when empty) and the UI interactions (how drop zones will appear over specific panels instead of the whole screen).

## Open Questions
> [!NOTE]
> 1. Do you want floating windows to also support multiple tabs? (The initial implementation will focus on single-tab floating windows to keep the scope manageable, but can be extended).
> 2. Should we preserve the current default layout on startup, or just load everything into a single tabbed area for testing? (I will preserve the existing layout structure by default).

## Proposed Changes

### `src/pages/components/docking`

#### [MODIFY] [DockPanel.qml](file:///home/david/Documents/projects/software/MOKM%20video-editor/code/src/pages/components/docking/DockPanel.qml)
- **Concept:** Convert to a tabbed container ("Dock Area").
- **Details:** 
  - Add a `property var panelTypes: []` array.
  - Replace the current custom header with `DockTabBar.qml`.
  - Use a `StackLayout` or multiple `Loader`s to show the active panel type's content while hiding the others.
  - Emit a new signal `tabFloated(int panelType)` when a tab is dragged out.

#### [MODIFY] [DockTabBar.qml](file:///home/david/Documents/projects/software/MOKM%20video-editor/code/src/pages/components/docking/DockTabBar.qml)
- **Concept:** Update data bindings and drag logic.
- **Details:**
  - Receive the `panelTypes` array from `DockPanel`.
  - Render tabs based on the array.
  - Add drag detection on individual tabs to initiate tearing off a tab into a floating window.

#### [MODIFY] [DockRoot.qml](file:///home/david/Documents/projects/software/MOKM%20video-editor/code/src/pages/components/docking/DockRoot.qml)
- **Concept:** The core layout manager.
- **Details:**
  - **Hit Testing:** Add a `getPanelAt(x, y)` function to recursively find which `DockPanel` the user is hovering over during a drag.
  - **Splitting:** Update `dockFloatingWindow` to accept a `targetPanel`. If the drop zone is Top/Bottom/Left/Right, split the `targetPanel`'s parent.
  - **Tab Grouping:** If the drop zone is Center, add the dropped panel type to `targetPanel.panelTypes`.
  - **Cleanup:** Add logic so when a `DockPanel` loses its last tab, it is destroyed and its `SplitContainer` merges the remaining section into the layout.

#### [MODIFY] [DockDropOverlay.qml](file:///home/david/Documents/projects/software/MOKM%20video-editor/code/src/pages/components/docking/DockDropOverlay.qml)
- **Concept:** Targeted drop zones.
- **Details:**
  - Instead of covering the whole `EditorPage`, bind its `x`, `y`, `width`, and `height` to the currently hovered `DockPanel` so the drop zones accurately represent where the panel will go.

#### [MODIFY] [FloatingWindow.qml](file:///home/david/Documents/projects/software/MOKM%20video-editor/code/src/pages/components/docking/FloatingWindow.qml)
- **Concept:** Update drag signals.
- **Details:**
  - Continuously emit mouse position during dragging so `EditorPage` can update the overlay target.

#### [MODIFY] [EditorPage.qml](file:///home/david/Documents/projects/software/MOKM%20video-editor/code/src/pages/EditorPage.qml)
- **Concept:** Coordinator.
- **Details:**
  - Connect `FloatingWindow`'s drag events to `DockRoot`'s hit testing to correctly position `DockDropOverlay`.
  - Trigger the docking action on release.

## Verification Plan
### Manual Verification
1. Launch the application.
2. Verify the default layout appears with 4 panels.
3. Tear off (float) a panel by dragging its tab or header.
4. Drag the floating window over another panel—ensure the drop overlay highlights *only* that panel.
5. Drop into the **Center** zone to verify it creates a tab group.
6. Drop into the **Left/Right/Top/Bottom** zones to verify it splits that specific panel correctly.
7. Close the last tab of a panel to verify the empty space is reclaimed by adjacent panels.
