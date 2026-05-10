
#include <QtPlugin>
#include <QtQml/qqmlextensionplugin.h>

// Q_IMPORT_QML_PLUGIN(QtLabsAnimationPlugin)		// /usr/lib/qt6/qml/Qt/labs/animation/liblabsanimationplugin.a:labsanimationplugin_QtLabsAnimationPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(Qt_labs_StyleKit_implPlugin)		// /usr/lib/qt6/qml/Qt/labs/StyleKit/impl/liblabsstylekitimplplugin.a:LabsStyleKitImplplugin_Qt_labs_StyleKit_implPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(Qt_labs_StyleKitPlugin)		// /usr/lib/qt6/qml/Qt/labs/StyleKit/liblabsstylekitplugin.a:LabsStyleKitplugin_Qt_labs_StyleKitPlugin.cpp.o:
Q_IMPORT_QML_PLUGIN(QmlFolderListModelPlugin)		// /usr/lib/qt6/qml/Qt/labs/folderlistmodel/libqmlfolderlistmodelplugin.a:qmlfolderlistmodelplugin_QmlFolderListModelPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QmlSettingsPlugin)		// /usr/lib/qt6/qml/Qt/labs/settings/libqmlsettingsplugin.a:qmlsettingsplugin_QmlSettingsPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QmlWavefrontMeshPlugin)		// /usr/lib/qt6/qml/Qt/labs/wavefrontmesh/libqmlwavefrontmeshplugin.a:qmlwavefrontmeshplugin_QmlWavefrontMeshPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtLabsPlatformPlugin)		// /usr/lib/qt6/qml/Qt/labs/platform/liblabsplatformplugin.a:LabsPlatformplugin_QtLabsPlatformPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtQmlLabsModelsPlugin)		// /usr/lib/qt6/qml/Qt/labs/qmlmodels/liblabsmodelsplugin.a:labsmodelsplugin_QtQmlLabsModelsPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(Qt_labs_synchronizerPlugin)		// /usr/lib/qt6/qml/Qt/labs/synchronizer/liblabssynchronizerplugin.a:LabsSynchronizerplugin_Qt_labs_synchronizerPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtQuickSharedImagePlugin)		// /usr/lib/qt6/qml/Qt/labs/sharedimage/libsharedimageplugin.a:qsharedimageplugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(Qt_test_controlsPlugin)		// /usr/lib/qt6/qml/Qt/test/controls/libquickcontrolstestutilsprivateplugin.a:QuickControlsTestUtilsPrivateplugin_Qt_test_controlsPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtQmlPlugin)		// /usr/lib/qt6/qml/QtQml/libqmlplugin.a:qmlplugin_QtQmlPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtQmlWorkerScriptPlugin)		// /usr/lib/qt6/qml/QtQml/WorkerScript/libworkerscriptplugin.a:workerscriptplugin_QtQmlWorkerScriptPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtQmlXmlListModelPlugin)		// /usr/lib/qt6/qml/QtQml/XmlListModel/libqmlxmllistmodelplugin.a:qmlxmllistmodelplugin_QtQmlXmlListModelPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtQmlModelsPlugin)		// /usr/lib/qt6/qml/QtQml/Models/libmodelsplugin.a:modelsplugin_QtQmlModelsPlugin.cpp.o:
Q_IMPORT_QML_PLUGIN(QMultimediaQuickModule)		// /usr/lib/qt6/qml/QtMultimedia/libquickmultimediaplugin.a:multimedia_plugin.cpp.o:
Q_IMPORT_QML_PLUGIN(QFFmpegMediaPlugin)		// /usr/lib/qt6/plugins/multimedia/libffmpegmediaplugin.a:qffmpegplugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtQuickControls2ImplPlugin)		// /usr/lib/qt6/qml/QtQuick/Controls/impl/libqtquickcontrols2implplugin.a:qtquickcontrols2implplugin_QtQuickControls2ImplPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtQuickControls2UniversalStyleImplPlugin)		// /usr/lib/qt6/qml/QtQuick/Controls/Universal/impl/libqtquickcontrols2universalstyleimplplugin.a:qtquickcontrols2universalstyleimplplugin_QtQuickControls2UniversalStyleImplPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtQuickControls2UniversalStylePlugin)		// /usr/lib/qt6/qml/QtQuick/Controls/Universal/libqtquickcontrols2universalstyleplugin.a:qtquickcontrols2universalstyleplugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtQuickControls2MaterialStyleImplPlugin)		// /usr/lib/qt6/qml/QtQuick/Controls/Material/impl/libqtquickcontrols2materialstyleimplplugin.a:qtquickcontrols2materialstyleimplplugin_QtQuickControls2MaterialStyleImplPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtQuickControls2MaterialStylePlugin)		// /usr/lib/qt6/qml/QtQuick/Controls/Material/libqtquickcontrols2materialstyleplugin.a:qtquickcontrols2materialstyleplugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtQuickControls2FusionStyleImplPlugin)		// /usr/lib/qt6/qml/QtQuick/Controls/Fusion/impl/libqtquickcontrols2fusionstyleimplplugin.a:qtquickcontrols2fusionstyleimplplugin_QtQuickControls2FusionStyleImplPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtQuickControls2FusionStylePlugin)		// /usr/lib/qt6/qml/QtQuick/Controls/Fusion/libqtquickcontrols2fusionstyleplugin.a:qtquickcontrols2fusionstyleplugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtQuickControls2Plugin)		// /usr/lib/qt6/qml/QtQuick/Controls/libqtquickcontrols2plugin.a:qtquickcontrols2plugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtQuickControls2FluentWinUI3StyleImplPlugin)		// /usr/lib/qt6/qml/QtQuick/Controls/FluentWinUI3/impl/libqtquickcontrols2fluentwinui3styleimplplugin.a:qtquickcontrols2fluentwinui3styleimplplugin_QtQuickControls2FluentWinUI3StyleImplPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtQuickControls2FluentWinUI3StylePlugin)		// /usr/lib/qt6/qml/QtQuick/Controls/FluentWinUI3/libqtquickcontrols2fluentwinui3styleplugin.a:qtquickcontrols2fluentwinui3styleplugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtQuickControls2ImagineStyleImplPlugin)		// /usr/lib/qt6/qml/QtQuick/Controls/Imagine/impl/libqtquickcontrols2imaginestyleimplplugin.a:qtquickcontrols2imaginestyleimplplugin_QtQuickControls2ImagineStyleImplPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtQuickControls2ImagineStylePlugin)		// /usr/lib/qt6/qml/QtQuick/Controls/Imagine/libqtquickcontrols2imaginestyleplugin.a:qtquickcontrols2imaginestyleplugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtQuickControls2BasicStyleImplPlugin)		// /usr/lib/qt6/qml/QtQuick/Controls/Basic/impl/libqtquickcontrols2basicstyleimplplugin.a:qtquickcontrols2basicstyleimplplugin_QtQuickControls2BasicStyleImplPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtQuickControls2BasicStylePlugin)		// /usr/lib/qt6/qml/QtQuick/Controls/Basic/libqtquickcontrols2basicstyleplugin.a:qtquickcontrols2basicstyleplugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtQuickTemplates2Plugin)		// /usr/lib/qt6/qml/QtQuick/Templates/libqtquicktemplates2plugin.a:qtquicktemplates2plugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtQuickVectorImagePlugin)		// /usr/lib/qt6/qml/QtQuick/VectorImage/libqquickvectorimageplugin.a:qquickvectorimageplugin_QtQuickVectorImagePlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtQuickVectorImageHelpersPlugin)		// /usr/lib/qt6/qml/QtQuick/VectorImage/Helpers/libqquickvectorimagehelpersplugin.a:qquickvectorimagehelpersplugin_QtQuickVectorImageHelpersPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtQuickDialogsPlugin)		// /usr/lib/qt6/qml/QtQuick/Dialogs/libqtquickdialogsplugin.a:qtquickdialogsplugin_QtQuickDialogsPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtQuickDialogs2QuickImplPlugin)		// /usr/lib/qt6/qml/QtQuick/Dialogs/quickimpl/libqtquickdialogs2quickimplplugin.a:qtquickdialogs2quickimplplugin_QtQuickDialogs2QuickImplPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtQuick_WindowPlugin)		// /usr/lib/qt6/qml/QtQuick/Window/libquickwindowplugin.a:quickwindow_QtQuick_WindowPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QmlShapesPlugin)		// /usr/lib/qt6/qml/QtQuick/Shapes/libqmlshapesplugin.a:qquickshapesplugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtQuickShapesDesignHelpersPlugin)		// /usr/lib/qt6/qml/QtQuick/Shapes/DesignHelpers/libqtquickshapesdesignhelpersplugin.a:qtquickshapesdesignhelpersplugin_QtQuickShapesDesignHelpersPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtQuick_toolingPlugin)		// /usr/lib/qt6/qml/QtQuick/tooling/libquicktoolingplugin.a:quicktooling_QtQuick_toolingPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtQuickEffectsPlugin)		// /usr/lib/qt6/qml/QtQuick/Effects/libeffectsplugin.a:effectsplugin_QtQuickEffectsPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtQuickLayoutsPlugin)		// /usr/lib/qt6/qml/QtQuick/Layouts/libqquicklayoutsplugin.a:qquicklayoutsplugin_QtQuickLayoutsPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtQuick2Plugin)		// /usr/lib/qt6/qml/QtQuick/libqtquick2plugin.a:qtquickplugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QQmlLocalStoragePlugin)		// /usr/lib/qt6/qml/QtQuick/LocalStorage/libqmllocalstorageplugin.a:qmllocalstorageplugin_QQmlLocalStoragePlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtQuick2ParticlesPlugin)		// /usr/lib/qt6/qml/QtQuick/Particles/libparticlesplugin.a:particlesplugin_QtQuick2ParticlesPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtNetworkPlugin)		// /usr/lib/qt6/qml/QtNetwork/libqmlnetworkplugin.a:QmlNetworkplugin_QtNetworkPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtTestPlugin)		// /usr/lib/qt6/qml/QtTest/libquicktestplugin.a:QuickTestplugin_QtTestPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtWayland_Compositor_WlShellPlugin)		// /usr/lib/qt6/qml/QtWayland/Compositor/WlShell/libwaylandcompositorwlshellplugin.a:WaylandCompositorWLShellplugin_QtWayland_Compositor_WlShellPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QWaylandTextureSharingExtensionPlugin)		// /usr/lib/qt6/qml/QtWayland/Compositor/TextureSharingExtension/libwaylandtexturesharingextensionplugin.a:plugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtWayland_Compositor_IviApplicationPlugin)		// /usr/lib/qt6/qml/QtWayland/Compositor/IviApplication/libwaylandcompositoriviapplicationplugin.a:WaylandCompositorIviapplicationplugin_QtWayland_Compositor_IviApplicationPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QWaylandCompositorPlugin)		// /usr/lib/qt6/qml/QtWayland/Compositor/libqwaylandcompositorplugin.a:qwaylandcompositorplugin_QWaylandCompositorPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtWayland_Compositor_PresentationTimePlugin)		// /usr/lib/qt6/qml/QtWayland/Compositor/PresentationTime/libwaylandcompositorpresentationtimeplugin.a:WaylandCompositorPresentationTimeplugin_QtWayland_Compositor_PresentationTimePlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtWayland_Compositor_QtShellPlugin)		// /usr/lib/qt6/qml/QtWayland/Compositor/QtShell/libwaylandcompositorqtshellplugin.a:WaylandCompositorQtShell_QtWayland_Compositor_QtShellPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QtWayland_Compositor_XdgShellPlugin)		// /usr/lib/qt6/qml/QtWayland/Compositor/XdgShell/libwaylandcompositorxdgshellplugin.a:WaylandCompositorXdgShellplugin_QtWayland_Compositor_XdgShellPlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QWaylandTextureSharingPlugin)		// /usr/lib/qt6/qml/QtWayland/Client/TextureSharing/libwaylandtexturesharingplugin.a:plugin.cpp.o:
Q_IMPORT_QML_PLUGIN(QtQmlCorePlugin)		// /usr/lib/qt6/qml/QtCore/libqtqmlcoreplugin.a:qtqmlcoreplugin_QtQmlCorePlugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QEglFSIntegrationPlugin)		// /usr/lib/qt6/plugins/platforms/libqeglfs.a:qeglfsmain.cpp.o:
Q_IMPORT_QML_PLUGIN(QWaylandIntegrationPlugin)		// /usr/lib/qt6/plugins/platforms/libqwayland.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(QVncIntegrationPlugin)		// /usr/lib/qt6/plugins/platforms/libqvnc.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(QMinimalIntegrationPlugin)		// /usr/lib/qt6/plugins/platforms/libqminimal.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(QXcbIntegrationPlugin)		// /usr/lib/qt6/plugins/platforms/libqxcb.a:qxcbmain.cpp.o:
// Q_IMPORT_QML_PLUGIN(QMinimalEglIntegrationPlugin)		// /usr/lib/qt6/plugins/platforms/libqminimalegl.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(QOffscreenIntegrationPlugin)		// /usr/lib/qt6/plugins/platforms/libqoffscreen.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(QVkKhrDisplayIntegrationPlugin)		// /usr/lib/qt6/plugins/platforms/libqvkkhrdisplay.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(QLinuxFbIntegrationPlugin)		// /usr/lib/qt6/plugins/platforms/libqlinuxfb.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(VulkanServerBufferIntegrationPlugin)		// /usr/lib/qt6/plugins/wayland-graphics-integration-server/libqt-wayland-compositor-vulkan-server.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(DrmEglServerBufferIntegrationPlugin)		// /usr/lib/qt6/plugins/wayland-graphics-integration-server/libqt-wayland-compositor-drm-egl-server-buffer.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(QWaylandDmabufClientBufferIntegrationPlugin)		// /usr/lib/qt6/plugins/wayland-graphics-integration-server/libqt-wayland-compositor-linux-dmabuf-unstable-v1.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(DmaBufServerBufferIntegrationPlugin)		// /usr/lib/qt6/plugins/wayland-graphics-integration-server/libqt-wayland-compositor-dmabuf-server-buffer.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(QWaylandEglClientBufferIntegrationPlugin)		// /usr/lib/qt6/plugins/wayland-graphics-integration-server/libqt-wayland-compositor-wayland-egl.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(ShmServerBufferIntegrationPlugin)		// /usr/lib/qt6/plugins/wayland-graphics-integration-server/libqt-wayland-compositor-shm-emulation-server.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(QWaylandEglStreamClientBufferIntegrationPlugin)		// /usr/lib/qt6/plugins/wayland-graphics-integration-server/libqt-wayland-compositor-wayland-eglstream-controller.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(QSvgPlugin)		// /usr/lib/qt6/plugins/imageformats/libqsvg.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(QJpegPlugin)		// /usr/lib/qt6/plugins/imageformats/libqjpeg.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(QGifPlugin)		// /usr/lib/qt6/plugins/imageformats/libqgif.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(QICOPlugin)		// /usr/lib/qt6/plugins/imageformats/libqico.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(QSvgIconPlugin)		// /usr/lib/qt6/plugins/iconengines/libqsvgicon.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(QGlibNetworkInformationBackendFactory)		// /usr/lib/qt6/plugins/networkinformation/libqglib.a:qglibnetworkinformationbackend.cpp.o:
// Q_IMPORT_QML_PLUGIN(QNetworkManagerNetworkInformationBackendFactory)		// /usr/lib/qt6/plugins/networkinformation/libqnetworkmanager.a:qnetworkmanagernetworkinformationbackend.cpp.o:
// Q_IMPORT_QML_PLUGIN(QConnManNetworkInformationBackendFactory)		// /usr/lib/qt6/plugins/networkinformation/libqconnman.a:qconnmannetworkinformationbackend.cpp.o:
Q_IMPORT_QML_PLUGIN(QWaylandWlShellIntegrationPlugin)		// /usr/lib/qt6/plugins/wayland-shell-integration/libwl-shell-plugin.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(QWaylandIviShellIntegrationPlugin)		// /usr/lib/qt6/plugins/wayland-shell-integration/libivi-shell.a:main.cpp.o:
Q_IMPORT_QML_PLUGIN(QWaylandXdgShellIntegrationPlugin)		// /usr/lib/qt6/plugins/wayland-shell-integration/libxdg-shell.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(QWaylandFullScreenShellV1IntegrationPlugin)		// /usr/lib/qt6/plugins/wayland-shell-integration/libfullscreen-shell-v1.a:main.cpp.o:
Q_IMPORT_QML_PLUGIN(QWaylandQtShellIntegrationPlugin)		// /usr/lib/qt6/plugins/wayland-shell-integration/libqt-shell.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(QWaylandEglClientBufferPlugin)		// /usr/lib/qt6/plugins/wayland-graphics-integration-client/libqt-plugin-wayland-egl.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(DmaBufServerBufferPlugin)		// /usr/lib/qt6/plugins/wayland-graphics-integration-client/libdmabuf-server.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(ShmServerBufferPlugin)		// /usr/lib/qt6/plugins/wayland-graphics-integration-client/libshm-emulation-server.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(VulkanServerBufferPlugin)		// /usr/lib/qt6/plugins/wayland-graphics-integration-client/libvulkan-server.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(DrmEglServerBufferPlugin)		// /usr/lib/qt6/plugins/wayland-graphics-integration-client/libdrm-egl-server.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(QTuioTouchPlugin)		// /usr/lib/qt6/plugins/generic/libqtuiotouchplugin.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(QEvdevTabletPlugin)		// /usr/lib/qt6/plugins/generic/libqevdevtabletplugin.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(QEvdevMousePlugin)		// /usr/lib/qt6/plugins/generic/libqevdevmouseplugin.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(QEvdevTouchScreenPlugin)		// /usr/lib/qt6/plugins/generic/libqevdevtouchplugin.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(QLibInputPlugin)		// /usr/lib/qt6/plugins/generic/libqlibinputplugin.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(QEvdevKeyboardPlugin)		// /usr/lib/qt6/plugins/generic/libqevdevkeyboardplugin.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(QWaylandBradientDecorationPlugin)		// /usr/lib/qt6/plugins/wayland-decoration-client/libbradient.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(QWaylandAdwaitaDecorationPlugin)		// /usr/lib/qt6/plugins/wayland-decoration-client/libadwaita.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(QTlsBackendOpenSSL)		// /usr/lib/qt6/plugins/tls/libqopensslbackend.a:qtlsbackend_openssl.cpp.o:
// Q_IMPORT_QML_PLUGIN(QTlsBackendCertOnly)		// /usr/lib/qt6/plugins/tls/libqcertonlybackend.a:qtlsbackend_cert.cpp.o:
// Q_IMPORT_QML_PLUGIN(QQmlProfilerServiceFactory)		// /usr/lib/qt6/plugins/qmltooling/libqmldbg_profiler.a:qqmlprofilerservicefactory.cpp.o:
// Q_IMPORT_QML_PLUGIN(QQmlPreviewServiceFactory)		// /usr/lib/qt6/plugins/qmltooling/libqmldbg_preview.a:qqmlpreviewservicefactory.cpp.o:
// Q_IMPORT_QML_PLUGIN(QQmlNativeDebugConnectorFactory)		// /usr/lib/qt6/plugins/qmltooling/libqmldbg_native.a:qqmlnativedebugconnector.cpp.o:
// Q_IMPORT_QML_PLUGIN(QQuickEventReplayServiceFactory)		// /usr/lib/qt6/plugins/qmltooling/libqmldbg_quickeventreplay.a:qquickeventreplayservicefactory.cpp.o:
// Q_IMPORT_QML_PLUGIN(QQmlDebugServerFactory)		// /usr/lib/qt6/plugins/qmltooling/libqmldbg_server.a:qqmldebugserverfactory.cpp.o:
// Q_IMPORT_QML_PLUGIN(QQmlNativeDebugServiceFactory)		// /usr/lib/qt6/plugins/qmltooling/libqmldbg_nativedebugger.a:qqmlnativedebugservicefactory.cpp.o:
// Q_IMPORT_QML_PLUGIN(QTcpServerConnectionFactory)		// /usr/lib/qt6/plugins/qmltooling/libqmldbg_tcp.a:qtcpserverconnection.cpp.o:
// Q_IMPORT_QML_PLUGIN(QLocalClientConnectionFactory)		// /usr/lib/qt6/plugins/qmltooling/libqmldbg_local.a:qlocalclientconnection.cpp.o:
// Q_IMPORT_QML_PLUGIN(QQmlDebuggerServiceFactory)		// /usr/lib/qt6/plugins/qmltooling/libqmldbg_debugger.a:qqmldebuggerservicefactory.cpp.o:
// Q_IMPORT_QML_PLUGIN(QQuickProfilerAdapterFactory)		// /usr/lib/qt6/plugins/qmltooling/libqmldbg_quickprofiler.a:qquickprofileradapterfactory.cpp.o:
// Q_IMPORT_QML_PLUGIN(QDebugMessageServiceFactory)		// /usr/lib/qt6/plugins/qmltooling/libqmldbg_messages.a:qdebugmessageservicefactory.cpp.o:
// Q_IMPORT_QML_PLUGIN(QQmlInspectorServiceFactory)		// /usr/lib/qt6/plugins/qmltooling/libqmldbg_inspector.a:qqmlinspectorservice.cpp.o:
// Q_IMPORT_QML_PLUGIN(QXcbEglIntegrationPlugin)		// /usr/lib/qt6/plugins/xcbglintegrations/libqxcb-egl-integration.a:qxcbeglmain.cpp.o:
// Q_IMPORT_QML_PLUGIN(QXdgDesktopPortalThemePlugin)		// /usr/lib/qt6/plugins/platformthemes/libqxdgdesktopportal.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(QSQLiteDriverPlugin)		// /usr/lib/qt6/plugins/sqldrivers/libqsqlite.a:smain.cpp.o:
// Q_IMPORT_QML_PLUGIN(QEglFSX11IntegrationPlugin)		// /usr/lib/qt6/plugins/egldeviceintegrations/libqeglfs-x11-integration.a:qeglfsx11main.cpp.o:
// Q_IMPORT_QML_PLUGIN(QEglFSKmsGbmIntegrationPlugin)		// /usr/lib/qt6/plugins/egldeviceintegrations/libqeglfs-kms-integration.a:qeglfskmsgbmmain.cpp.o:
// Q_IMPORT_QML_PLUGIN(QEglFSKmsEglDeviceIntegrationPlugin)		// /usr/lib/qt6/plugins/egldeviceintegrations/libqeglfs-kms-egldevice-integration.a:qeglfskmsegldevicemain.cpp.o:
// Q_IMPORT_QML_PLUGIN(QEglFSEmulatorIntegrationPlugin)		// /usr/lib/qt6/plugins/egldeviceintegrations/libqeglfs-emu-integration.a:qeglfsemumain.cpp.o:
// Q_IMPORT_QML_PLUGIN(QmlLintQuickPlugin)		// /usr/lib/qt6/plugins/qmllint/libquicklintplugin.a:quicklintplugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QmlLintQdsPlugin)		// /usr/lib/qt6/plugins/qmllint/libqdslintplugin.a:qdslintplugin.cpp.o:
// Q_IMPORT_QML_PLUGIN(QIbusPlatformInputContextPlugin)		// /usr/lib/qt6/plugins/platforminputcontexts/libibusplatforminputcontextplugin.a:main.cpp.o:
// Q_IMPORT_QML_PLUGIN(QComposePlatformInputContextPlugin)		// /usr/lib/qt6/plugins/platforminputcontexts/libcomposeplatforminputcontextplugin.a:qcomposeplatforminputcontextmain.cpp.o:

Q_IMPORT_QML_PLUGIN(org_kde_layershellPlugin);		// (T) usr/lib/libLayerShellQtQml.a
