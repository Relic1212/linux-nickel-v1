cmake_minimum_required(VERSION 3.10)
add_executable(testplugin main.cpp)

install(TARGETS testplugin DESTINATION bin)

include(/usr/lib/cmake/AddStaticQtPlugins.cmake)
add_static_qt_plugins(testplugin)
