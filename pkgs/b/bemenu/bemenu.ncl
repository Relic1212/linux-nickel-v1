{
  lib,
  fontconfig,
  freetype,
  zlibNg,
  gperf,
  pixman,
  wayland,
  waylandProtocols,
  libffi,
  libxkbcommon,
  expat,
  linuxHeaders,
  pkgconf,
  ncurses,
  readline,
  pcre2,
  pango,
  cairo,
  libpng,
  harfbuzz,
  scdoc,
  glib,
  hwdata,
  linuxHeaders,
  libxcursor,
  xorgMacros,
  xorgproto,
  xtrans,
  libxcb,
  xcbProto,
  libxau,
  libx11,
  libxrender,
  libxfixes,

  bemenu | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/Cloudef/bemenu/archive/refs/tags/0.6.23.tar.gz",
      sha256sum = "0e7878c3bf57e0e362efe89c59deddd33819cd62b980be7e0b7bb4da45478e44"
    },
    biDrvs =
      lib.biMap [
        fontconfig,
        freetype,
        zlibNg,
        gperf,
        pixman,
        wayland,
        waylandProtocols,
        libffi,
        libxkbcommon,
        expat,
        linuxHeaders,
        pkgconf,
        ncurses,
        readline,
        pcre2,
        pango,
        cairo,
        libpng,
        harfbuzz,
        scdoc,
        # glib,
        # hwdata,
        # linuxHeaders,

        ###############################################################
        libxcursor,
        xorgMacros,
        xorgproto,
        xtrans,
        libxcb,
        xcbProto,
        libxau,
        libx11,
        libxrender,
        libxfixes,
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
