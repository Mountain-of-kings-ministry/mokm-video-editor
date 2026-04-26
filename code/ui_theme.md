![alt text](image.png)

# --- THEME DEFINITIONS (Direct from Brand Image) ---
COLOR_SOVEREIGN="#FFD700"  # Core authority (Crown, Core Logic, Asset DB, Program Monitor)
COLOR_HIGHLIGH="#FFCC10"    # Active tools/nodes (Scopes, DAG Graph, OCIO, Marker List)
COLOR_GLIMMER="#E5B70A"    # Actions/Timeline (Edit Page, Keyframes, History Panel, Keyboard Map)
COLOR_PANEL="#4E5360"      # Component cards (Inspector, Effects Browser, Plugin Mgr)
COLOR_FOUND="#343840"      # Base layers (Timeline background, Hardware Preferences, Proxy Dashboard, Rendering)
COLOR_SURFACE="#1A1B1F"    # Deep space (Workspaces, Project Settings, Render Queue)

"media_bin"          # Base components
    "timeline"           # Action/Timeline
    "attribute_inspector" # Functional panel
    "keyframe_editor"    # Action/Timeline
    "marker_list"        # Active tool/list
    "effects_browser"    # Functional panel
    "history_panel"      # Action/Timeline
    "plugin_manager"     # Functional panel
    "keyboard_shortcuts"  # Action/Timeline

    # Define color mapping for UI (Default to surface, then specify)
declare -A ui_colors
ui_colors["timeline"]=$COLOR_GLIMMER
ui_colors["keyframe_editor"]=$COLOR_GLIMMER
ui_colors["history_panel"]=$COLOR_GLIMMER
ui_colors["keyboard_shortcuts"]=$COLOR_GLIMMER
ui_colors["marker_list"]=$COLOR_HIGHLIGH

func_colors["core"]=$COLOR_SOVEREIGN
func_colors["database"]=$COLOR_FOUND
func_colors["rendering"]=$COLOR_FOUND
func_colors["ffmpeg_wrapper"]=$COLOR_SOVEREIGN
func_colors["proxy"]=$COLOR_FOUND
func_colors["timeline"]=$COLOR_SOVEREIGN