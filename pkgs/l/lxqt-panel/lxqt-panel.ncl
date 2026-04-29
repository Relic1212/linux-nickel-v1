let qtImportHeaders = import "../lxqt-session/qt_headers.cpp" as 'Text in

{
  lib,
  drvs,
  lxqtPanel | lib.LxqtPackage = {
    singleSource = {
      uri = "https://github.com/lxqt/lxqt-panel/archive/refs/tags/2.3.2.tar.gz",
      sha256sum = "6e42cb032186e0b18e2649aed2ef57ef7d1f63cc81a6f38a7918f62c573a906d",
    },
    patches = [
      {
        sha256sum = "cbd1413cda5eb4e0120aabbd23ab83e31f3f7c6a8fe5f374c23803953f4fb6c6",
        file = "lxqt-panel-nox11.patch"
      },
      {
        sha256sum = "e455cfb7a122167b1e0403f0a6f4ef14e7898400745a044bc6796f791efa2d8b",
        file = "lxqt-panel-staticplugins.patch",
      },
    ],
    buildEnv = {
      EXTRA_LDFLAGS = [
        "-Wl,--allow-multiple-definition",
        "$(pkg-config --static --libs glib-2.0 gmodule-2.0 expat)",
        "/tmp/workdir/src/dlopen.o",
      ],
    },

    cmakeExtraArgsRecord = {
      "-DKBINDICATOR_PLUGIN" = false,
      "-DTRAY_PLUGIN" = false,
    },
    preConfigurePhase =
      let link = "target_link_libraries(wmbackend_wlroots PRIVATE Qt6::Gui Qt6::GuiPrivate Qt6::WaylandClient Qt6::WaylandClientPrivate Qt6::Concurrent Qt6Xdg)"
      in
      [
        # "echo '%{qtImportHeaders}' > ${SRC}/plugins.cpp",
        # "echo '%{import "qt_wayland_obj.cpp" as 'Text }' >> ${SRC}/plugins.cpp",
        # "clang++ --verbose -c -O2 ${SRC}/plugins.cpp -o ${SRC}/plugins.o",
        # "head -n 103 ${SRC}/panel/CMakeLists.txt > new",
        # "echo '%{import "plugins.cmake" as 'Text}' >> new",
        # "tail -n 20 ${SRC}/panel/CMakeLists.txt >> new",
        # "mv new ${SRC}/panel/CMakeLists.txt",
        ##################
        m%"printf "include(/usr/lib/cmake/AddStaticQtPlugins.cmake)\nadd_static_qt_plugins(lxqt-panel)\n" >> ${SRC}/panel/CMakeLists.txt"%,

        ##################
        "cp /usr/share/ECM/find-modules/FindLibMount.cmake ${SRC}/cmake",
        "cp /usr/share/ECM/find-modules/FindUDev.cmake ${SRC}/cmake",
        # https://github.com/KDE/layer-shell-qt/blob/dd76feea81e851d7032c3b7160ef30f0bc77786e/CMakeLists.txt#L46
        m%"sed -i "s@find_package(LayerShellQt REQUIRED)@find_package(PkgConfig)\npkg_check_modules(XKBCOMMON xkbcommon REQUIRED IMPORTED_TARGET)\nfind_package(LayerShellQt REQUIRED)@g" ${SRC}/CMakeLists.txt"%,
        # m%"sed -i "s@find_package(KF6Solid@find_package(UDev REQUIRED COMPONENTS Udev)\nfind_package(KF6Solid@g" ${SRC}/plugin-mount/CMakeLists.txt"%,
        m%"sed -i "s@find_package(KF6Solid@find_package(UDev REQUIRED)\nfind_package(KF6Solid@g" ${SRC}/plugin-mount/CMakeLists.txt"%,
        "for f in $(find ${SRC} -name CMakeLists.txt); do sed -i 's| MODULE | STATIC |g' ${f};done",
        "sed -i 's| MODULE | STATIC |g' ${SRC}/cmake/BuildPlugin.cmake",
        m%"sed -i "s@int main@Q_IMPORT_PLUGIN(LXQtWMBackendWlrootsLibrary)\nint main@g" ${SRC}/panel/main.cpp"%,
        m%"sed -i "s@lxqt-panel-backend-common@lxqt-panel-backend-common\n\twmbackend_wlroots@" ${SRC}/panel/CMakeLists.txt"%,
        # m%"sed -i "s@loadable modules@loadable modules\n@g" "%
        m%"sed -i "s@add_library@qt6_add_plugin@" ${SRC}/panel/backends/wayland/wlroots/CMakeLists.txt"%,
        m%"sed -i "s@ STATIC @ CLASS_NAME LXQtWMBackendWlrootsLibrary STATIC @" ${SRC}/panel/backends/wayland/wlroots/CMakeLists.txt"%,
        m%"sed -i "s@target_link_libraries@%{link}\n# target_link_libraries@" ${SRC}/panel/backends/wayland/wlroots/CMakeLists.txt"%,
        # (let s = m%"set_properties(wmbackend_wlroots PROPERTIES QT_PLUGIN_CLASS_NAME )"%)
        "echo '%{import "dlopen_empty.c" as 'Text}' > ${SRC}/dlopen.c",
        "${CC} ${CFLAGS} -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
      ],

    libxkbcommonProvider = drvs.libxkbcommonX11,
    muslProvider = drvs.muslBothRenamedDl,
    biDrvs = [
      drvs.acl,
      drvs.attr,
      drvs.duktape,
      drvs.elogindWithPolkit,
      drvs.kwindowsystem,
      drvs.layerShellQt,
      drvs.libcap,
      drvs.liblxqt,
      drvs.libpamFinalUdev,
      drvs.libqtxdg,
      drvs.libx11,
      drvs.libxau,
      drvs.libxcb,
      drvs.libxext,
      drvs.libxfixes,
      drvs.libxrender,
      drvs.libxss,
      drvs.lxqtBuildTools,
      drvs.plasmaWaylandProtocols,
      drvs.polkit,
      drvs.polkitQt6,
      drvs.xcbProto,
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.xtrans,
      drvs.qtxdgTools,
      drvs.xdgUserDirs,
      drvs.procps,
      drvs.perl,
      drvs.libdbusmenuLxqt,
      drvs.lxqtGlobalkeys,
      drvs.lxqtMenuData,
      drvs.libstatgrab,
      drvs.libsysstat,
      drvs.alsaLibs,
      drvs.bluez,
      drvs.sbc,
      drvs.ffmpeg,
      drvs.speex,
      drvs.speexdsp,
      drvs.pulseaudio17,
      drvs.solid,
      drvs.ecm,
      drvs.lmSensors,
      drvs.xcbUtilImage,
      drvs.xcbUtil,
      drvs.xcbUtilWm,
      drvs.libxtst,
      drvs.libxi,
      drvs.qtpluginConsumer,
      drvs.libevdev,
      drvs.mtdev,
    ]
  }
}
