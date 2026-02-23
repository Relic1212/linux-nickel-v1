cmake_minimum_required(VERSION 3.10)
find_package(Qt6 REQUIRED COMPONENTS
    Core
    WaylandClient
    Gui
    WaylandCompositor
)
# find_package(Libinput REQUIRED)

add_library(qtbase_obj STATIC qtbase.cpp)

add_executable(qtbase_bin main.cpp)

target_link_libraries(qtbase_bin PUBLIC
    Qt6::WaylandClient
    Qt6::Gui
    Qt6::Core
    Qt6::WaylandCompositor
    # Libinput::Libinput
)

target_link_libraries(qtbase_bin PUBLIC qtbase_obj)

target_link_options(qtbase_bin PUBLIC -Wl,--error-limit=0)

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
)

include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

install(TARGETS qtbase_obj EXPORT PluginConsumer)
install(EXPORT PluginConsumer DESTINATION lib NAMESPACE PluginConsumer::)
install(TARGETS qtbase_bin DESTINATION bin)
# configure_package_config_file()