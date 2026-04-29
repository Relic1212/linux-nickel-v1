{
  lib,
  drvs,
  sysboard | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/System64fumo/sysboard/archive/1a032fb4dd76f3f5496955d293eab2ea90f7fc15.tar.gz",
      sha256sum = "9ef2bb3b75a32de9315cb77235aab695c40118fe7a1aba73e9181b7c96ecaf60"
    },
    debug = true,
    patches = [
      {
        sha256sum = "f1d4eab0ac152799b1b3dc6b0e52f36688411819b2e45bc7ed2c12b9770f3f35",
        file = "sysboard.patch"
      }
    ],
    buildEnv.EXTRA_LDFLAGS = [
      "-Wl,--verbose",
      # "-ldl_factory",
      "$(pkg-config --static --libs egl)",
      "${SRC}/symbols.o",
    ],
    buildEnv.EXTRA_CFLAGS = ["--verbose"],

    makeTargets = [
      "sysboard"
    ],
    extraMakeArgs = [
      # "CFLAGS=\"${CFLAGS}\"",
      # "CXXFLAGS=\"${CXXFLAGS}\"",
      # "CXXFLAGS=\"-g\"",
      # "LDFLAGS=\"${LDFLAGS}\"",
    ],
    extraMakeInstallArgs =
      [
        "PREFIX=/usr"
      ]
      @ extraMakeArgs,
    # installPhase =[ ],

    llvmProvider = drvs.llvmFull,
    #   pythonProvider = drvs.pythonDynamic,
    preConfigurePhase = [
      m%"sed -i 's|-Os -s|-O0 -g|g' ${SRC}/Makefile"%,
      m%"sed -i 's|-Os|-O0|g' ${SRC}/Makefile"%,
      m%"sed -i 's|-O1|-O0|g' ${SRC}/Makefile"%,
      m%"sed -i 's|@install -D -t $(DESTDIR)$(LIBDIR) $(BUILDDIR)/$(LIBS)||g' ${SRC}/Makefile"%,
      "echo '%{import "./sysboard_symbols.c" as 'Text}' > ${SRC}/symbols.c",
      "${CC} ${CFLAGS} -c ${SRC}/symbols.c -o ${SRC}/symbols.o",

      #   #"sed -i 's@-fno-exceptions@@g' ${SRC}/Makefile",
      #   "sed -i 's@pkg-config@pkg-config --static@g' ${SRC}/Makefile",
      #   "sed -i 's@-shared@-static@g' ${SRC}/Makefile",
      #   "sed -i 's@LDFLAGS += -Wl,-O1,--as-needed,-z,now,-z,pack-relative-relocs@#LDFLAGS += -Wl,-O1,--as-needed,-z,now,-z,pack-relative-relocs@g' ${SRC}/Makefile",
      #   "sed -i 's@CXXFLAGS += -Os -s -Wall -flto=auto -fno-exceptions -fPIC@#CXXFLAGS += -Os -s -Wall -flto=auto -fno-exceptions -fPIC@g' ${SRC}/Makefile",
      #   "sed -i 's@libsysboard.so@ libsysboard.a@g' ${SRC}/Makefile",
    ],
    muslProvider = drvs.muslBothRenamedDl,
    biDrvs = [
      drvs.atSpi2Core,
      drvs.cairo,
      drvs.cairoGobject,
      drvs.cairomm_1_16,
      drvs.expat,
      drvs.fontconfig,
      drvs.freetype,
      drvs.fribidi,
      drvs.gdkPixbufFull,
      drvs.glibPatched,
      drvs.glibmm_2_82,
      drvs.gobjectDynamic,
      drvs.gperf,
      drvs.graphene,
      drvs.gtk4,
      drvs.gtk4LayerShell,
      drvs.gtkmm4,
      drvs.harfbuzzFull,
      drvs.hwdata,
      drvs.libdrm,
      drvs.libelf,
      drvs.libepoxy,
      drvs.libffi,
      drvs.libjpegTurbo,
      drvs.libpciaccess,
      drvs.libpng,
      drvs.libsigcpp,
      drvs.libtiff,
      drvs.libxkbcommon,
      drvs.linuxHeaders,
      drvs.llvmConfigStatic,
      drvs.mesa2,
      # drvs.muslShared,
      drvs.ncurses,
      drvs.pango,
      drvs.pangomm_2_48,
      drvs.pcre2,
      drvs.pixman,
      drvs.pkgconf,
      drvs.pythonSetuptools,
      drvs.readline,
      drvs.spirvLlvmTranslator,
      drvs.spirvTools,
      drvs.vala,
      drvs.waylandGtk4LayerShell,
      drvs.waylandProtocols,
      drvs.zlibNg,
    ],
  }
}
