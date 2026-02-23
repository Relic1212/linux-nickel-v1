
function(ADD_STATIC_QT_PLUGINS BINARY_NAME)

    find_package(Qt6 REQUIRED COMPONENTS
        Core
        WaylandClient
        Gui
        WaylandCompositor
    )
    find_package(PkgConfig)
    pkg_check_modules(LIBINPUT_LIB libinput REQUIRED IMPORTED_TARGET)
    pkg_check_modules(GMODULE_LIB gmodule-2.0 REQUIRED IMPORTED_TARGET)
    pkg_check_modules(EXPAT_LIB expat REQUIRED IMPORTED_TARGET)

    target_link_libraries(${BINARY_NAME}
        /usr/lib/libqtbase_obj.a
        Qt6::WaylandClient
        Qt6::Gui
        Qt6::Core
        Qt6::WaylandCompositor
        PkgConfig::LIBINPUT_LIB
        PkgConfig::GMODULE_LIB
        PkgConfig::EXPAT_LIB
    )

    qt_import_plugins(${BINARY_NAME} INCLUDE
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

endfunction()