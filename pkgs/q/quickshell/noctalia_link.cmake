target_link_libraries(quickshell PRIVATE Qt6::Multimedia Qt6::qtqmlcoreplugin Qt6::qmlfolderlistmodelplugin Qt6::QFFmpegMediaPlugin Qt6::QWaylandWlShellIntegrationPlugin)

# pkg_check_modules(XKBCOMMON REQUIRED IMPORTED_TARGET xkbcommon)
# find_package(LayerShellQt REQUIRED)

target_link_libraries(quickshell PRIVATE LayerShellQt::Interface)

qt_import_qml_plugins(quickshell)
