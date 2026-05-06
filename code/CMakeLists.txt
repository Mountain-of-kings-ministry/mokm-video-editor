cmake_minimum_required(VERSION 3.16)

project(mokm_video_editor VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.10)

qt_add_executable(appmokm_video_editor
    main.cpp
    src/resources/resources.qrc
)

add_subdirectory(src)

set_source_files_properties(src/pages/Theme.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

# Automatically find all cpp and h files in src/functions
file(GLOB_RECURSE FUNCTION_SOURCES "src/functions/*.cpp" "src/functions/*.h")

# Automatically find all subdirectories in src/functions to add to include path
file(GLOB FUNCTION_SUBDIRS "src/functions/*")
foreach(dir ${FUNCTION_SUBDIRS})
    if(IS_DIRECTORY ${dir})
        list(APPEND FUNCTION_INCLUDE_DIRS ${dir})
    endif()
endforeach()

# Automatically find all cpp and h files in src/providers
file(GLOB_RECURSE PROVIDER_SOURCES "src/providers/*.cpp" "src/providers/*.h")

# Add src/providers directly to include path
list(APPEND PROVIDER_INCLUDE_DIRS "src/providers")

# Also find any subdirectories in src/providers for include path
file(GLOB PROVIDER_SUBDIRS "src/providers/*")
foreach(dir ${PROVIDER_SUBDIRS})
    if(IS_DIRECTORY ${dir})
        list(APPEND PROVIDER_INCLUDE_DIRS ${dir})
    endif()
endforeach()

    set_source_files_properties(src/pages/components/docking/DockManager.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

    qt_add_qml_module(appmokm_video_editor
        URI mokm_video_editor
        VERSION 1.0
        QML_FILES
            src/pages/Main.qml
            src/pages/Theme.qml
            src/pages/SplashScreen.qml
            src/pages/MediaBinPage.qml
            src/pages/EditorPage.qml
            src/pages/NodeEditorPage.qml
            src/pages/AudioPage.qml
            src/pages/CompositorPage.qml
            src/pages/HistoryPage.qml
            src/pages/RendererPage.qml
            src/pages/SettingsPage.qml
            src/pages/components/SidebarButton.qml
            src/pages/components/Sidebar.qml
            src/pages/components/EditorToolBar.qml
            src/pages/components/PanelHeader.qml
            src/pages/components/StatusBar.qml
            src/pages/components/TimelineRuler.qml
            src/pages/components/TimelineTrack.qml
            src/pages/components/NodeSocket.qml
            src/pages/components/MediaPreviewPanel.qml
            src/pages/components/docking/DockManager.qml
            src/pages/components/docking/DockPanel.qml
            src/pages/components/docking/DockRoot.qml
            src/pages/components/docking/DockDropOverlay.qml
            src/pages/components/docking/DockTabBar.qml
            src/pages/components/docking/SplitContainer.qml
            src/pages/components/docking/FloatingWindow.qml
            src/pages/components/panels/PreviewPanel.qml
            src/pages/components/panels/MiniBin.qml
            src/pages/components/panels/PropertiesPanel.qml
            src/pages/components/panels/NodePanel.qml
            src/pages/components/panels/TimelinePanel.qml
        SOURCES ${FUNCTION_SOURCES} ${PROVIDER_SOURCES}
        RESOURCES src/resources/resources.qrc
    )

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appmokm_video_editor PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appmokm_video_editor
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appmokm_video_editor
    PRIVATE Qt6::Quick
)

find_package(Qt6 REQUIRED COMPONENTS Quick Core Multimedia Concurrent)
target_link_libraries(appmokm_video_editor PRIVATE Qt6::Quick Qt6::Core Qt6::Multimedia Qt6::Concurrent)

if(FUNCTION_INCLUDE_DIRS)
    target_include_directories(appmokm_video_editor PRIVATE ${FUNCTION_INCLUDE_DIRS})
endif()

if(PROVIDER_INCLUDE_DIRS)
    target_include_directories(appmokm_video_editor PRIVATE ${PROVIDER_INCLUDE_DIRS})
endif()

install(TARGETS appmokm_video_editor
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
