{
  lib,
  drvs,
  bemenu | lib.MakePackage
    = {
      singleSource = {
        uri = "https://github.com/Cloudef/bemenu/archive/refs/tags/0.6.23.tar.gz",
        sha256sum = "0e7878c3bf57e0e362efe89c59deddd33819cd62b980be7e0b7bb4da45478e44"
      },
      biDrvs = [
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
        drvs.pkgconf,
        drvs.ncurses,
        drvs.readline,
        drvs.pcre2,
        drvs.pango,
        drvs.cairo,
        drvs.libpng,
        drvs.harfbuzz,
        drvs.scdoc,
        # drvs.glib,
        # drvs.hwdata,
        # drvs.linuxHeaders,

        ###############################################################
        drvs.libxcursor,
        drvs.xorgMacros,
        drvs.xorgproto,
        drvs.xtrans,
        drvs.libxcb,
        drvs.xcbProto,
        drvs.libxau,
        drvs.libx11,
        drvs.libxrender,
        drvs.libxfixes,
        ###################################################
      ],
      makeTargets = [
        "bemenu",
        "bemenu-run"
      ],
      makeInstallTargets = [
        "install-bins"
      ],
      preConfigurePhase = [
        #   m%"sed -i 's@\.so@\.a@g' ${SRC}/GNUmakefile"%,
        #  m%"sed -i 's@-shared@@g' ${SRC}/GNUmakefile"%,
      ]
    }
}
