add_library(database STATIC
    MediaBinModel.cpp
    MediaBinModel.h
)
set_target_properties(database PROPERTIES AUTOMOC ON)
target_include_directories(database PUBLIC .)
target_link_libraries(database PUBLIC
    Qt6::Core
    Qt6::Qml
    Qt6::Gui
    ffmpeg_wrapper
)
