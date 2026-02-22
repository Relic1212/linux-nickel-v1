let qtImportHeaders = import "qt_imports.cpp" as 'Text in
{
  lib,
  drvs,
  lxqtSession | lib.LxqtPackage = {
    singleSource = {
      uri = "https://github.com/lxqt/lxqt-session/archive/refs/tags/2.3.0.tar.gz",
      sha256sum = "0f4620dcbbf963f27c86bdf31cfcae9413492e0600c3c8d85835cb746b209c9d",
    },
    patches = [
      {
        file = "lxqt-session-nox11.patch",
        sha256sum = "4fab4ea9e7959eabf58bf32953f863b705905c107d6049614771bb23cf01164c",
      },
    ],

    buildEnv = {
      EXTRA_LDFLAGS = [
        "$(pkg-config --static --libs glib-2.0 gmodule-2.0 expat)",
      ],
    },
    cmakeExtraArgsRecord = {
      # "-DCMAKE_PREFIX_PATH" = "\"/usr/lib/cmake/Qt6WaylandCompositor:/usr/lib/cmake/Qt6WaylandClient\"",
    },
    preConfigurePhase =
      let qtplugins = [
        # "QWaylandDmabufClientBufferIntegrationPlugin",
        # "QWaylandEglClientBufferIntegrationPlugin",
        # "QWaylandEglStreamClientBufferIntegrationPlugin",
        "QWaylandXdgShellIntegrationPlugin",
        "QWaylandIntegrationPlugin",
      ]
      in
      [
        "echo '%{qtImportHeaders}' > ${SRC}/plugins.cpp",
        "echo '%{import "qt_wayland_obj.cpp" as 'Text }' >> ${SRC}/plugins.cpp",
        "clang++ --verbose -c -O2 ${SRC}/plugins.cpp -o ${SRC}/plugins.o",
        # (
        #   let linkStr =
        #     std.string.join
        #       m%"\n"%
        #       (
        #         [
        #           "/tmp/workdir/src/plugins.o",
        #         ]
        #         # @ (
        #         #   std.array.map
        #         #     (fun s => "Qt6::" ++ s
        #         #     )
        #         #     qtplugins
        #         # )
        #       )
        #   in
        #   m%"sed -i "s@KF6::WindowSystem@KF6::WindowSystem\n%{linkStr}@g" ${SRC}/lxqt-session/CMakeLists.txt"%
        # ),
        # (
        #   let finds = (std.array.map (fun s => "find_package(Qt6%{s} REQUIRED)" ++ m%"\n"%)) qtplugins in

        #   m%"sed -i "s@add_executable@%{std.string.join "" finds }add_executable@g" ${SRC}/lxqt-session/CMakeLists.txt"%
        # ),
        # (
        #   m%"sed -i "s@target_link_libraries(lxqt-session@"% ++
        #   ###
        #   "qt_import_plugins(quickshell INCLUDE"
        #   ++ m%"\n"% ++
        #   ###
        #   (
        #     let qimports =
        #       ""
        #       ++ (
        #         std.string.join
        #           ""
        #           (
        #             std.array.map (fun s => m%"Qt6::%{s}\n"%) qtplugins
        #           )
        #       )
        #     in qimports
        #   ) ++
        #   ###
        #   m%"\n)\n"%
        #   ###
        #   ++ m%"target_link_libraries(lxqt-session@g" ${SRC}/lxqt-session/CMakeLists.txt"%
        # ),
        "head -n 61 ${SRC}/lxqt-session/CMakeLists.txt > new",
        "echo '%{import "plugins.cmake" as 'Text}' >> new",
        "tail -n 35 ${SRC}/lxqt-session/CMakeLists.txt >> new",
        "mv new ${SRC}/lxqt-session/CMakeLists.txt",
      ],
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
    ]
  }
}
