find_package(PkgConfig REQUIRED)
pkg_check_modules(FFMPEG REQUIRED
    libavcodec
    libavformat
    libavutil
    libswscale
)

add_library(ffmpeg_wrapper STATIC
    FFmpegMediaProbe.cpp
    FFmpegMediaProbe.h
    FFmpegThumbnailer.cpp
    FFmpegThumbnailer.h
)
set_target_properties(ffmpeg_wrapper PROPERTIES AUTOMOC ON)
target_include_directories(ffmpeg_wrapper PUBLIC .)
target_link_libraries(ffmpeg_wrapper PUBLIC
    Qt6::Core
    Qt6::Gui
    ${FFMPEG_LIBRARIES}
)
target_include_directories(ffmpeg_wrapper PUBLIC ${FFMPEG_INCLUDE_DIRS})
target_compile_options(ffmpeg_wrapper PUBLIC ${FFMPEG_CFLAGS_OTHER})
