add_library(core STATIC
    MokmUndoManager.cpp
    MokmUndoManager.h
    MokmProjectManager.cpp
    MokmProjectManager.h
)
set_target_properties(core PROPERTIES AUTOMOC ON)
target_include_directories(core PUBLIC .)
target_link_libraries(core PUBLIC Qt6::Core Qt6::Qml Qt6::Gui)
