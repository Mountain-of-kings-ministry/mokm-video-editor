# MOKM Video Editor QML Frontend Walkthrough

We have successfully built the frontend architecture and all major requested UI components for the MOKM Video Editor using QML, Qt Quick Layouts, and the defined premium dark/gold theme.

## Architecture & Integration

All features were modularized into separate `.qml` files matching your folder structure:

1. **Theme Engine**: `src/ui/core/Theme.qml` handles global colors, typography, and geometry (margins, padding, corner radii). The color scheme defined in `ui_theme.md` (Sovereign `#FFD700`, Highlight `#FFCC10`, Glimmer `#E5B70A`, Panel `#4E5360`, Found `#343840`, Surface `#1A1B1F`) is now enforced system-wide.
2. **Main Navigation (`Main.qml`)**: Serves as the `ApplicationWindow`. It uses a `Loader` linked to a global side navigation rail to cleanly swap between the primary workspaces, ensuring smooth operation.
3. **Icons Support**: Set up dynamic references focusing on your Tabler icon SVG set located in `src/ui/icons/outline/`. 
4. **Dockability Concept**: Used `SplitView` components everywhere in the workspaces, allowing panes to be resized smoothly, which represents the foundation required for tear-off dockable windows.

## Workspaces Implemented

- **Media Bin**: Includes a folder tree side-panel, a mock metadata inspector, and a grid for media thumbnails with proxy indicators.
- **Video Editor (Timeline)**: A classic NLE environment with Source Monitor, Program Monitor (with proxy toggle mock), and a Multi-track timeline (Video/Audio tracks mock) plus a custom-drawn playhead.
- **Node Editor**: Features a `Grid` base canvas containing mock Node representations (Inputs, Color Correct, Blur, Outputs) with a floating Minimap and an integrated Node Library on the left.
- **Color Grading**: Features customized Mock Color Wheels (Lift, Gamma, Gain, Offset) and designated placeholders for real-time video scopes.
- **Audio Mixing**: Designed vertical sliders (Master/A1/A2 etc.) complete with mock peak and RMS meters, plus a VST3 / CLAP plugin inspector slot view.
- **Export Page**: Split layout containing the Render profile settings on the left and an active Render Queue mock on the right with progress bars.

## Floating Panels & Configuration

The requested floating components and dialogues were created:
- **Functional Panels**: Drafted implementations for the Attribute Inspector (with sliders/spinners), Keyframe Editor (with bezier path mocks using the Canvas API), Marker List, Effects Browser, and History Panel tracking undo actions.
- **Global Settings (Modals)**: Created standard `Popup` / `Dialog` equivalents for Project Settings, Application Preferences, Proxy Manager Dashboard, Plugin Manager, and Keyboard Shortcuts.
- *Testing note:* You can trigger the modals by clicking the Settings (gear) icon at the bottom of the navigation rail in `Main.qml`.

> [!TIP]
> The UI is purely frontend as requested. No actual file models, SQL queries, or FFmpeg C++ integration were added yet. You can build and run your codebase as-is to inspect the visual rendering and navigate the pages.
