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
    extraMakeInstallArgs = [
      "PREFIX=/usr"
    ],
    # installPhase =[ ],

    llvmProvider = drvs.llvmFull,
    #   pythonProvider = drvs.pythonDynamic,

    biDrvs = [
      drvs.fontconfig,
      drvs.freetype,
      drvs.zlibNg,
      drvs.gperf,
      drvs.pixman,
      drvs.waylandGtk4LayerShell,
      drvs.waylandProtocols,
      drvs.libffi,
      drvs.libxkbcommon,
      drvs.expat,
      drvs.linuxHeaders,
      drvs.ncurses,
      drvs.readline,
      drvs.pcre2,
      drvs.pango,
      drvs.cairo,
      drvs.libpng,
      drvs.harfbuzzFull,
      drvs.glibDynamic,
      drvs.muslShared,
      drvs.hwdata,
      drvs.gobjectDynamic,
      drvs.cairoGobject,
      drvs.fribidi,
      drvs.gdkPixbufFull,
      drvs.libjpegTurbo,
      drvs.libepoxy,
      drvs.atSpi2Core,
      drvs.mesa2,
      drvs.libelf,
      drvs.libdrm,
      drvs.libpciaccess,
      drvs.llvmConfigStatic,
      drvs.spirvTools,
      drvs.spirvLlvmTranslator,
      drvs.gtk4,
      drvs.vala,
      drvs.pythonSetuptools,
      drvs.libtiff,
      drvs.graphene,
      drvs.gtkmm4,
      drvs.libsigcpp,
      drvs.cairomm_1_16,
      drvs.pangomm_2_48,
      drvs.glibmm_2_82,
      drvs.gtk4LayerShell,
      drvs.pkgconf,
    ],

    # preConfigurePhase = [
    #   #"sed -i 's@-fno-exceptions@@g' ${SRC}/Makefile",
    #   "sed -i 's@pkg-config@pkg-config --static@g' ${SRC}/Makefile",
    #   "sed -i 's@-shared@-static@g' ${SRC}/Makefile",
    #   "sed -i 's@LDFLAGS += -Wl,-O1,--as-needed,-z,now,-z,pack-relative-relocs@#LDFLAGS += -Wl,-O1,--as-needed,-z,now,-z,pack-relative-relocs@g' ${SRC}/Makefile",
    #   "sed -i 's@CXXFLAGS += -Os -s -Wall -flto=auto -fno-exceptions -fPIC@#CXXFLAGS += -Os -s -Wall -flto=auto -fno-exceptions -fPIC@g' ${SRC}/Makefile",
    #   "sed -i 's@libsysboard.so@ libsysboard.a@g' ${SRC}/Makefile",
    # ]
  }
}
