# Functions module - aggregates all backend function subdirectories

# Existing function subdirectories
add_subdirectory(animation)
add_subdirectory(audio)
add_subdirectory(nodes)
add_subdirectory(plugins)
add_subdirectory(video)

# New function subdirectories
add_subdirectory(core)
add_subdirectory(rendering)
add_subdirectory(database)
add_subdirectory(ffmpeg_wrapper)
add_subdirectory(proxy)
add_subdirectory(timeline)

add_library(functions INTERFACE)
target_link_libraries(functions INTERFACE
    animation
    audio
    nodes
    plugins
    video
    core
    rendering
    database
    ffmpeg_wrapper
    proxy
    timeline
)
