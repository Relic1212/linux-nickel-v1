{
  lib,
  drvs,
  sysboard | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/System64fumo/sysboard/archive/d7788339878447dba5ecc1d4cc92cdbea78785eb.tar.gz",
      sha256sum = "478fc2713be68b4580ff6315988d50f92719356553932d37b56bc24f31f34e68"
    },
    debug = true,
    patches = [
      {
        sha256sum = "b718f851bbb620315a345daa491f3b00eb3b7d616d0793bb44b5294ca322b316",
        file = "sysboard.patch"
      }
    ],
    buildEnv.EXTRA_LDFLAGS = [
      "-Wl,--verbose",
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
      #   #"sed -i 's@-fno-exceptions@@g' ${SRC}/Makefile",
      #   "sed -i 's@pkg-config@pkg-config --static@g' ${SRC}/Makefile",
      #   "sed -i 's@-shared@-static@g' ${SRC}/Makefile",
      #   "sed -i 's@LDFLAGS += -Wl,-O1,--as-needed,-z,now,-z,pack-relative-relocs@#LDFLAGS += -Wl,-O1,--as-needed,-z,now,-z,pack-relative-relocs@g' ${SRC}/Makefile",
      #   "sed -i 's@CXXFLAGS += -Os -s -Wall -flto=auto -fno-exceptions -fPIC@#CXXFLAGS += -Os -s -Wall -flto=auto -fno-exceptions -fPIC@g' ${SRC}/Makefile",
      #   "sed -i 's@libsysboard.so@ libsysboard.a@g' ${SRC}/Makefile",
    ],
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
      drvs.muslShared,
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
