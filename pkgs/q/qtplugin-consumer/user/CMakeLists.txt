cmake_minimum_required(VERSION 3.10)
include(/usr/lib/cmake/AddStaticQtPlugins.cmake)
add_executable(testplugin main.cpp)
add_static_qt_plugins(testplugin)

install(TARGETS testplugin DESTINATION bin)