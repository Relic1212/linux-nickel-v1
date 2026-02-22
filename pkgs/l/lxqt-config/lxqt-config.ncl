{
  lib,
  lib = {
    LxqtPackage,
  },
  lib.functions = {
    _cmakeAddLines = (fun line lines before =>
      let allLines = if before then lines @ [line] else [line] @ lines in
      let new = std.string.join m%"\n"% allLines in

      m%"sed -i "s@%{line}@%{new}@g""%
    ),
    cmakePrependLines = (fun line lines => _cmakeAddLines line lines true),
    cmakeAppendLines = (fun line lines => _cmakeAddLines line lines false),
  },
  drvs,
  lxqtConfig | lib.LxqtPackage = {
    singleSource = {
      uri = "https://github.com/lxqt/lxqt-config/archive/refs/tags/2.3.1.tar.gz",
      sha256sum = "2b27590967d087a95c8c21ccdb04844e9797eae5c06a552aabe8d4dc7e8ce13a",
    },

    buildEnv = {
      EXTRA_LDFLAGS = [
        "$(pkg-config --static --libs gmodule-2.0)",
        "$(pkg-config --static --libs glib-2.0)",
        "$(pkg-config --static --libs expat)",
        "$(pkg-config --static --libs xrender)",
      ],
    },

    cmakeExtraArgsRecord = {
      "-DWITH_TOUCHPAD" = false, # xorg-libinput
      "-DWITH_INPUT" = false,
      "-DWITH_BRIGHTNESS" = false,
    },

    preConfigurePhase = [
      "cd ${SRC}",
      m%"patch -p1 << 'EOF'%{import "lxqt-config-nox11.patch" as 'Text}EOF"%,
      "cd ${BUILDDIR}",
      "sed -i 's|SHARED|STATIC|g' ${SRC}/liblxqt-config-cursor/CMakeLists.txt",
    ],

    biDrvs = [
      drvs.acl,
      drvs.attr,
      drvs.duktape,
      drvs.elogindWithPolkit,
      drvs.kwindowsystem,
      drvs.libcap,
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
      drvs.liblxqt,
      drvs.lxqtMenuData,
      drvs.perl,
      drvs.xdgUserDirs,
      #   drvs.kscreen,
      drvs.libkscreen,
      drvs.libxcursor,
    ],
  }
}
