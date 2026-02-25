{
  lib,
  drvs,
  lxqtLibfmQt | lib.LxqtPackage = {
    singleSource = {
      uri = "https://github.com/lxqt/libfm-qt/archive/refs/tags/2.3.1.tar.gz",
      sha256sum = "df0ce97dbf1dc71fe440d5cec896fcd355d66d38e5fb19411d5d1efb28fd40ad",
    },

    buildEnv = {
      EXTRA_LDFLAGS = [
        "$(pkg-config --static --libs glib-2.0 gmodule-2.0 expat)",
      ],
    },

    preConfigurePhase = [
      "cd ${SRC}",
      m%"patch -p1 << 'EOF'%{import "lxqt-libfm-qt-nox11.patch" as 'Text}EOF"%,
      "cd ${BUILDDIR}",
      "sed -i 's|SHARED|STATIC|g' ${SRC}/src/CMakeLists.txt",
    ],

    biDrvs = [
      drvs.lxqtBuildTools,
      drvs.libfmExtra,
      drvs.libmenuCache,
      drvs.lxqtMenuData,
      drvs.libexif,
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.xcbProto,
      drvs.libxau,
      drvs.libxcb,
      drvs.perl,
      drvs.xdgUserDirs,
    ]
  }
}
