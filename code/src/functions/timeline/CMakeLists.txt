add_library(timeline_functions STATIC
    TimelineModel.cpp
    TimelineModel.h
    TimelineClipModel.cpp
    TimelineClipModel.h
    PlayheadController.cpp
    PlayheadController.h
)
set_target_properties(timeline_functions PROPERTIES AUTOMOC ON)
target_include_directories(timeline_functions PUBLIC .)
target_link_libraries(timeline_functions PUBLIC Qt6::Core Qt6::Qml)
