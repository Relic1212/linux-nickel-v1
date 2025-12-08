{
  lib,
  drvs,

  swappy | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/jtheoof/swappy/archive/2aa3ae2433ee671ddc73e36ece8598e68f7f3632.zip",
      sha256sum = "718e41fa65ac2e20291f009dd1edfc44414683489b93ee9a7a3fd3a7714fedd7"
    },

    buildEnv = {
      EXTRA_LDFLAGS = [
        "-ldl_factory",
        # "/tmp/workdir/src/symbols.o",
      ],
    },
    extraFiles = [
      {
        file = "symbols.c",
        sha256sum = "2a3293e1f0c92ba492efaf79ba6a5dd94ea4a65a9027d22ba668eddd74c7de39"
      },
      # {
      #   file = ""
      # }
    ],

    preConfigurePhase = [
      "${CC} ${CFLAGS} -c /tmp/workdir/files/symbols.c -o ${SRC}/symbols.o",
      m%"sed -i "s@'-rdynamic'@'/tmp/workdir/src/symbols.o'@g" ${SRC}/meson.build"%,
    ],

    llvmProvider = drvs.llvmFull,
    muslProvider = drvs.muslBothRenamedDl,
    biDrvs = [
      drvs.libdlFactory,
      drvs.fontconfig,
      drvs.freetype,
      drvs.zlibNg,
      drvs.gperf,
      drvs.pixman,
      drvs.wayland,
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
      drvs.harfbuzz,
      drvs.glibPatched,
      # drvs.muslShared,
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
      drvs.gtk3,
      drvs.gettext,
    ],
  }
}
