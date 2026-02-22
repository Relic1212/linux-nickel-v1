find_package(Qt6WaylandClient REQUIRED)
find_package(Qt6WlShellIntegrationPrivate REQUIRED)
find_package(Qt6Gui REQUIRED)
find_package(Qt6WaylandCompositor REQUIRED)
find_package(Qt6WaylandCompositorPrivate REQUIRED)
# find_package(Qt6LabsPlatformplugin REQUIRED)
# find_package(Qt6labsmodelsplugin REQUIRED)
find_package(Qt6Widgets REQUIRED)
# find_package(Qt6qtquickdialogsplugin REQUIRED)
# find_package(Qt6qmlfolderlistmodelplugin REQUIRED)
# find_package(Qt6qtqmlcoreplugin REQUIRED)
# find_package(Qt6Multimedia REQUIRED)
# find_package(LayerShellQt REQUIRED)
# find_package(Qt6WaylandClientPrivate REQUIRED NO_MODULE)
# find_package(Qt6 COMPONENTS WaylandClientPrivate REQUIRED)

target_link_libraries(lxqt-session
    /tmp/workdir/src/plugins.o
    Qt6::WaylandClient 
    Qt6::WlShellIntegrationPrivate
    Qt6::Gui
    Qt6::WaylandCompositor
    Qt6::WaylandCompositorPrivate
    Qt6::Widgets
    # LayerShellQt::Interface
)
qt_import_plugins(lxqt-session INCLUDE 
    Qt6::QWaylandIntegrationPlugin
    Qt6::QWaylandXdgShellIntegrationPlugin
    Qt6::QWaylandBradientDecorationPlugin
    Qt6::Qt6QSvgIconPlugin
    Qt6::Qt6QSvgPlugin
)
qt_import_qml_plugins(lxqt-session)
