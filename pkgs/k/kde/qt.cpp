diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 52db00a..1f000e2 100644
--- a/src/CMakeLists.txt
 b/src/CMakeLists.txt
@@ -1,5 1,31 @@
 qt_add_executable(quickshell main.cpp)
 
target_link_libraries(quickshell PRIVATE
	Qt6::WaylandClient 
    Qt6::WlShellIntegrationPrivate
    Qt6::Gui
    Qt6::WaylandCompositor
    Qt6::WaylandCompositorPrivate
	Qt6::LabsPlatformplugin
	Qt6::labsmodelsplugin
	Qt6::Widgets
	Qt6::qtquickdialogsplugin
	Qt6::qmlfolderlistmodelplugin
	Qt6::qtqmlcoreplugin
	Qt6::Multimedia
)
qt_import_plugins(quickshell INCLUDE 
    Qt6::QWaylandIntegrationPlugin
    Qt6::QWaylandXdgShellIntegrationPlugin
    Qt6::QWaylandBradientDecorationPlugin
	Qt6::LabsPlatformplugin
	Qt6::qtquickdialogsplugin
	Qt6::labsmodelsplugin
	Qt6::Multimedia

)
find_package(Qt6QmlImportScanner REQUIRED)
qt_import_qml_plugins(quickshell)
 install(TARGETS quickshell RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
 
 add_subdirectory(build)
diff --git a/src/main.cpp b/src/main.cpp
index e0ce937..984d4f6 100644
--- a/src/main.cpp
 b/src/main.cpp
@@ -1,3 1,78 @@
 #include "launch/main.hpp"
#include <QtPlugin>
#include <QtQml/qqmlextensionplugin.h>


Q_IMPORT_PLUGIN(QWaylandIntegrationPlugin)
Q_IMPORT_PLUGIN(QWaylandXdgShellIntegrationPlugin)
Q_IMPORT_PLUGIN(QWaylandBradientDecorationPlugin)

// https://github.com/stal-ix/ix/blob/f0b587f2c8e062b23359080bbe1d45086c01932e/pkgs/lib/qt/6/declarative/deps/ix.sh#L34


// decl
// Q_IMPORT_PLUGIN(QmlLintQuickPlugin)
Q_IMPORT_PLUGIN(QQmlDebugServerFactory)
Q_IMPORT_PLUGIN(QQmlPreviewServiceFactory)
Q_IMPORT_PLUGIN(QTcpServerConnectionFactory)
Q_IMPORT_PLUGIN(QQuickProfilerAdapterFactory)
Q_IMPORT_PLUGIN(QQmlProfilerServiceFactory)
Q_IMPORT_PLUGIN(QLocalClientConnectionFactory)
Q_IMPORT_PLUGIN(QQmlInspectorServiceFactory)
Q_IMPORT_PLUGIN(QQmlNativeDebugConnectorFactory)
Q_IMPORT_PLUGIN(QQmlNativeDebugServiceFactory)
Q_IMPORT_PLUGIN(QQmlDebuggerServiceFactory)
Q_IMPORT_PLUGIN(QDebugMessageServiceFactory)
Q_IMPORT_PLUGIN(QtQmlWorkerScriptPlugin)
// Q_IMPORT_PLUGIN(QmlSettingsPlugin)
// Q_IMPORT_PLUGIN(QtLabsAnimationPlugin)
Q_IMPORT_PLUGIN(QtQuick_WindowPlugin)
// Q_IMPORT_PLUGIN(QtNetworkPlugin)
Q_IMPORT_PLUGIN(QtQuickControls2FluentWinUI3StyleImplPlugin)
Q_IMPORT_PLUGIN(QtQuickLayoutsPlugin)
Q_IMPORT_PLUGIN(QtQuickControls2ImagineStyleImplPlugin)
// Q_IMPORT_PLUGIN(QmlWavefrontMeshPlugin)
Q_IMPORT_PLUGIN(QtQuickControls2ImagineStylePlugin)
Q_IMPORT_PLUGIN(QtQuickControls2FusionStylePlugin)
// Q_IMPORT_PLUGIN(QtQuickDialogs2QuickImplPlugin)
Q_IMPORT_PLUGIN(QtQuickControls2BasicStyleImplPlugin)
Q_IMPORT_PLUGIN(QtQuickControls2BasicStylePlugin)
Q_IMPORT_PLUGIN(QtQuick2Plugin)
Q_IMPORT_PLUGIN(QtQuickEffectsPlugin)
Q_IMPORT_PLUGIN(QtQuickControls2MaterialStylePlugin)
Q_IMPORT_PLUGIN(QmlShapesPlugin)
// Q_IMPORT_PLUGIN(QtQuick2ParticlesPlugin)
Q_IMPORT_PLUGIN(QtQuickControls2FluentWinUI3StylePlugin)
Q_IMPORT_PLUGIN(QtQuickControls2ImplPlugin)
// Q_IMPORT_PLUGIN(QQmlLocalStoragePlugin)
// Q_IMPORT_PLUGIN(QtTestPlugin)
Q_IMPORT_PLUGIN(QtQuickControls2UniversalStyleImplPlugin)
// Q_IMPORT_PLUGIN(Qt_test_controlsPlugin)
Q_IMPORT_PLUGIN(QtLabsPlatformPlugin)
Q_IMPORT_PLUGIN(QtQuickControls2MaterialStyleImplPlugin)
// Q_IMPORT_PLUGIN(Assets_DownloaderPlugin)
Q_IMPORT_PLUGIN(QtQuickControls2UniversalStylePlugin)
// Q_IMPORT_PLUGIN(QtQuickVectorImagePlugin)
Q_IMPORT_PLUGIN(QtQuickTemplates2Plugin)
Q_IMPORT_PLUGIN(QtQuickControls2FusionStyleImplPlugin)
// Q_IMPORT_PLUGIN(QtQuick_toolingPlugin)
Q_IMPORT_PLUGIN(QtQuickDialogsPlugin)
// Q_IMPORT_PLUGIN(QtQuickSharedImagePlugin)
Q_IMPORT_PLUGIN(QtQuickControls2Plugin)

Q_IMPORT_PLUGIN(QmlFolderListModelPlugin)

Q_IMPORT_PLUGIN(QMultimediaQuickModule)




Q_IMPORT_QML_PLUGIN(QtQmlPlugin)
Q_IMPORT_QML_PLUGIN(QtQmlModelsPlugin)
Q_IMPORT_QML_PLUGIN(QtQmlLabsModelsPlugin)
Q_IMPORT_QML_PLUGIN(QtQmlCorePlugin)
// Q_IMPORT_PLUGIN(QtQmlXmlListModelPlugin)


 
