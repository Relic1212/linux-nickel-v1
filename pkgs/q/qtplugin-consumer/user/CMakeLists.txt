cmake_minimum_required(VERSION 3.10)

add_executable(testplugin main.cpp)


find_package(PluginConsumer REQUIRED)
target_link_libraries(testplugin PluginConsumer)

install(TARGET testplugin DESTINATION lib)