cmake_minimum_required(VERSION 3.10)

option(WITH_QTWAYLAND "Qtwayland support" ON)
option(WITH_QTSVQ "Qtwayland support" ON)

find_package(Qt6 REQUIRED COMPONENTS
    Core
    WaylandClient
    Gui
    WaylandCompositor
)
# find_package(Libinput REQUIRED)
find_package(PkgConfig)
pkg_check_modules(LIBINPUT_LIB libinput REQUIRED IMPORTED_TARGET)
pkg_check_modules(GMODULE_LIB gmodule-2.0 REQUIRED IMPORTED_TARGET)
pkg_check_modules(EXPAT_LIB expat REQUIRED IMPORTED_TARGET)

add_library(qtbase_obj STATIC qtbase.cpp)

add_executable(qtbase_bin main.cpp)

if(WITH_QTWAYLAND)
    add_compile_definitions(qtbase_bin -DWITH_QTWAYLAND)
endif(WITH_QTWAYLAND)

if(WITH_QTSVQ)
    add_compile_definitions(qtbase_bin -DWITH_QTSVQ)
endif(WITH_QTSVQ)


target_link_libraries(qtbase_bin
    Qt6::WaylandClient
    Qt6::Gui
    Qt6::Core
    Qt6::WaylandCompositor
    PkgConfig::LIBINPUT_LIB
    PkgConfig::GMODULE_LIB
    PkgConfig::EXPAT_LIB
)

target_link_libraries(qtbase_bin qtbase_obj)

# target_link_options(qtbase_bin PUBLIC -Wl,--error-limit=0)

qt_import_plugins(qtbase_bin INCLUDE
    Qt6::DmaBufServerBufferPlugin
    Qt6::DrmEglServerBufferPlugin
    Qt6::QComposePlatformInputContextPlugin
    Qt6::QEglFSEmulatorIntegrationPlugin
    Qt6::QEglFSIntegrationPlugin
    Qt6::QEglFSKmsEglDeviceIntegrationPlugin
    Qt6::QEglFSKmsGbmIntegrationPlugin
    Qt6::QEvdevKeyboardPlugin
    Qt6::QEvdevMousePlugin
    Qt6::QEvdevTabletPlugin
    Qt6::QEvdevTouchScreenPlugin
    Qt6::QGifPlugin
    Qt6::QICOPlugin
    Qt6::QIbusPlatformInputContextPlugin
    Qt6::QJpegPlugin
    Qt6::QLibInputPlugin
    Qt6::QLinuxFbIntegrationPlugin
    Qt6::QMinimalEglIntegrationPlugin
    Qt6::QMinimalIntegrationPlugin
    Qt6::QOffscreenIntegrationPlugin
    Qt6::QTuioTouchPlugin
    Qt6::QVncIntegrationPlugin
    Qt6::QWaylandBradientDecorationPlugin
    Qt6::QWaylandEglClientBufferPlugin
    Qt6::QWaylandFullScreenShellV1IntegrationPlugin
    Qt6::QWaylandIntegrationPlugin
    Qt6::QWaylandWlShellIntegrationPlugin
    Qt6::QWaylandXdgShellIntegrationPlugin
    Qt6::QXdgDesktopPortalThemePlugin
    Qt6::ShmServerBufferPlugin



    Qt6::QWaylandIviShellIntegrationPlugin
    Qt6::QWaylandQtShellIntegrationPlugin
    Qt6::QWaylandAdwaitaDecorationPlugin
    Qt6::DrmEglServerBufferIntegrationPlugin
    Qt6::QWaylandDmabufClientBufferIntegrationPlugin
    Qt6::ShmServerBufferIntegrationPlugin
    Qt6::DmaBufServerBufferIntegrationPlugin
    Qt6::QWaylandEglStreamClientBufferIntegrationPlugin
    Qt6::QWaylandEglClientBufferIntegrationPlugin

    Qt6::QSvgIconPlugin
    Qt6::QSvgPlugin
)

include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

install(TARGETS qtbase_obj EXPORT PluginConsumer)
install(EXPORT PluginConsumer 
    FILE PluginConsumer.cmake 
    DESTINATION lib 
    NAMESPACE PluginConsumer::
)
install(TARGETS qtbase_bin DESTINATION bin)
# configure_package_config_file()