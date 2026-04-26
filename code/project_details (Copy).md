# Project Plan: Professional Node-Based Open-Source Video Editor

**Project Name:** MOKM video-editor

**Vision:**  
A lightweight yet professional-grade, fully open-source non-linear video editor (NLE) built in C++ with Qt 6. It features a powerful node-based compositing engine, pervasive proxy editing for low-end hardware compatibility, and aims to rival DaVinci Resolve, Adobe Premiere Pro, and Final Cut Pro while running smoothly on older or budget computers.

**Core Objectives:**
- Deliver industry-standard performance and features without the "hardware tax".
- Use a modern node-based architecture (inspired by Olive 0.2 but improved).
- Ensure excellent performance on low-power hardware through aggressive proxy workflow and optimizations.
- Maintain full cross-platform support (Windows, macOS, Linux).
- Prioritize clean, modular, maintainable C++ codebase.
- Support professional workflows including plugin extensibility (OFX, VST3, LV2, CLAP, Frei0r).

**Technology Stack**
- **Language:** C++17 / C++20
- **UI Framework:** Qt 6.5+ (QML + Qt Quick Scene Graph + C++ backends)
- **Rendering:** Qt Rendering Hardware Interface (RHI) — Vulkan/Metal/Direct3D
- **Multimedia:** FFmpeg (libavcodec, libavformat, libavfilter, libswscale) — direct low-level integration
- **Node Graph:** QtNodes / NodeLink (customized)
- **Color Management:** OpenColorIO (OCIO)
- **Timeline Interchange:** OpenTimelineIO (OTIO)
- **Computer Vision:** OpenCV
- **Build System:** CMake (modern target-based)
- **Dependency Management:** vcpkg or Conan
- **Plugins:** OpenFX (video), VST3/LV2/CLAP (audio), Frei0r (lightweight effects)

---

## 1. Architectural Foundation

### Core Principles
- High performance with low memory footprint
- Multi-threaded architecture (UI thread never blocked)
- Proxy-first editing workflow
- Lazy evaluation + pull-based node rendering
- Zero-copy pipelines where possible
- Hardware acceleration support (decoding/encoding)

### Key Architectural Components
- **UI Layer:** QML + custom C++ render nodes using Qt Quick Scene Graph
- **Backend Engine:** Multi-threaded worker threads for decoding, processing, and transcoding
- **Asset Database:** SQLite-backed media library with proxy/original source pointers
- **Node Engine:** Directed Acyclic Graph (DAG) with lazy evaluation and ROI optimization
- **Rendering Pipeline:** GLSL shaders + dynamic shader chaining on GPU
- **Proxy System:** Transparent background transcoding + dynamic high-res swap

---

## 2. Comprehensive Feature List

### Level 1: Basic Editing and Fundamentals (Core Tier)

- [x] Multi-track non-linear timeline (independent audio & video tracks)
- [x] Frame-accurate cutting, trimming, and razor tool
- [x] Media Asset Management (Bins) with folder structure and metadata
- [x] Import/export of common video, audio, and image formats (via FFmpeg)
- [x] Standard transitions (fades, dissolves, wipes)
- [x] Basic text/title tool (stationary overlays)
- [x] Audio level monitoring (peak meters, gain controls)
- [x] Simple playback controls with smooth scrubbing
- [x] Project save/load with auto-save and crash recovery
- [x] Undo/Redo system (Qt Undo Framework)

### Level 2: Intermediate Editing and Effects (Creator Tier)

- Keyframe animation (position, scale, rotation, opacity, etc.) with Bezier curves
- Primary color correction (exposure, contrast, white balance, saturation)
- Advanced audio editing (noise reduction, EQ, multi-channel mixing)
- Speed ramping and time remapping (with optional optical flow)
- Multi-camera synchronization (via waveform or timecode)
- Custom LUT support (.cube, .3dl)
- Basic effects library (blur, sharpen, etc.)
- Clip effects and track effects
- Audio mixing with level automation

### Level 3: Professional Post-Production (High-End Tier)

- Full node-based compositing engine (advanced masking, rotoscoping, layer compositing)
- Motion tracking (planar and point tracking via OpenCV)
- High Dynamic Range (HDR) support (10-bit / 12-bit workflows)
- Advanced color grading with OCIO / ACES
- Vector scopes, waveform monitors, and parade scopes
- Professional audio plugin hosting (VST3, LV2, CLAP)
- Visual effects plugin hosting (OpenFX / OFX)
- Rotoscoping tools
- Masking (track mattes, bezier masks)
- Advanced compositing nodes (blend modes, alpha handling)
- 3D text / motion graphics basics (future)

### Cross-Cutting / System Features

- **Proxy Editing System** (core innovation)
  - Automatic proxy generation on import (background transcoding)
  - Configurable proxy settings (resolution, codec, bitrate)
  - Transparent proxy/original switching
  - High-quality preview toggle
  - Dynamic swap during final render
  - Hardware-accelerated proxy encoding

- **Node-Based Processing Engine**
  - Pull-based lazy evaluation
  - Region of Interest (ROI) optimization
  - GLSL shader integration for effects
  - Dynamic shader combination into single GPU passes
  - Caching system for intermediate results
  - Support for custom nodes

- **Performance Optimizations for Low-End Hardware**
  - Asynchronous frame pre-fetching
  - Hardware decoding (NVENC, QuickSync, VAAPI)
  - Zero-copy rendering pipelines
  - Memory-mapped files for large media
  - SIMD optimizations (SSE/AVX/NEON)
  - Background task prioritization (high priority for current playhead frame)
  - I-frame-only proxies (e.g., ProRes Proxy or H.264)

- **Plugin Architecture**
  - OpenFX host for video effects
  - VST3 / LV2 / CLAP host for audio
  - Frei0r support
  - Custom node plugin system

- **Interoperability**
  - OpenTimelineIO (OTIO) for project interchange with Premiere, Resolve, Final Cut
  - EDL / XML export/import
  - AAF support (future)

- **Monitoring & Analysis Tools**
  - Real-time vectorscope
  - Waveform monitor
  - Histogram
  - Audio peak/RMS meters

- **Export & Rendering**
  - High-performance final render engine
  - Deterministic rendering (bit-identical results across machines)
  - Wide range of export codecs and containers (via FFmpeg)
  - Hardware-accelerated encoding
  - Render queue / background rendering
  - Proxy-aware rendering (always uses original sources)

---

## 3. UI/UX Requirements

- Highly responsive interface (60 FPS previews where possible)
- Dockable, customizable panels (similar to Premiere/Shotcut)
- Smooth timeline scrubbing with asynchronous decoding
- Custom high-performance timeline renderer (C++ backend in QML)
- Node graph editor with data-flow visualization
- Dark professional UI theme
- Keyboard shortcuts (industry standard where possible)
- Touch/gesture support (future)

---

## 4. Engineering & Optimization Strategies

- Strict modularization (`libeditor-core`, `libeditor-ui`, `libeditor-nodes`, etc.)
- Modern CMake practices
- Zero or minimal UI thread blocking
- Comprehensive threading model with `QThreadPool`
- Memory management best practices (smart pointers, move semantics)
- Clean coding standards + documentation
- Continuous Integration (Windows, macOS, Linux)
- Unit and integration testing strategy

---

## 5. Development Roadmap (Phased)

**Phase 1: Foundation**
- Project setup (CMake, Qt 6, FFmpeg integration)
- Basic media import/playback
- Simple timeline + basic trimming
- Proxy generation system (core)

**Phase 2: Core Editing**
- Multi-track timeline
- Cutting/trimming tools
- Basic effects and transitions
- Asset bin management
- Undo/redo + auto-save

**Phase 3: Node Engine**
- Full node graph implementation
- GLSL shader nodes
- Basic compositing nodes

**Phase 4: Intermediate Features**
- Keyframing
- Color correction
- Audio tools
- LUT support

**Phase 5: Professional Tier**
- Advanced compositing
- Motion tracking
- Plugin hosting (OFX + Audio)
- Scopes and monitors
- OTIO support

**Phase 6: Polish & Optimization**
- Performance tuning for low-end hardware
- UI/UX refinement
- Stability & crash recovery
- Documentation & community building

---

## 6. Success Criteria

- Runs smoothly on 10-year-old laptops for 1080p editing (with proxies)
- Handles 4K+ projects on modern hardware
- Stable, crash-resistant editing sessions
- Professional output quality
- Extensible via open standards (OFX, OTIO, etc.)
- Clean, well-documented, contributor-friendly codebase
- Active open-source community potential

---

**License:** GPLv3 or later (to be decided — must remain fully open source)

**Target Audience:**  
Independent filmmakers, YouTubers, content creators, students, and professionals on a budget who want Resolve-level power without expensive hardware.

---

This document serves as the living **Project Plan** and **Feature Specification**. It should be expanded with detailed technical specifications, API designs, and task breakdowns as development progresses.

*Last updated: April 2026*
