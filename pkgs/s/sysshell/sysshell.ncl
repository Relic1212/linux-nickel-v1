{
  lib,
  drvs,
  sysboard | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/System64fumo/sysboard/archive/2beb0e77edac1d75f7ad8f57759f813cd7888ec2.tar.gz",
      sha256sum = "b7f1b1dc40532eb28c0954d74e16f0897bfd045b1bb4b0c70a3e941eb7d97570"
    },
    debug = true,
    patches = [
      {
        sha256sum = "638a1c52e8fd26e8fceed588c02f1c20d8ad899e065baaa89f562666290a08e5",
        file = "sysboard.patch"
      }
    ],
    # buildEnv.EXTRA_LDFLAGS = ["-Wl,--verbose"],
    # buildEnv.EXTRA_CFLAGS = ["--verbose"],

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
      #drvs.pango, #??
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
