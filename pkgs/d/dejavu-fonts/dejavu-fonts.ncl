{
  lib,
  drvs,
  dejavuFonts | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/dejavu-fonts/dejavu-fonts/archive/refs/tags/version_2_37.tar.gz",
      sha256sum = "c4d10a1b665db893adc0c0aaee7ecd81b2b47c877d5cea0b40216707cbf327e4"
    },
    biDrvs = [
      drvs.fontforge,
      drvs.perl,
      drvs.pkgconf,
      drvs.perlFontTtf,
      drvs.perlIoString,
    ],
    makeTargets = [
      "full-ttf"
    ],
    installPhase = [
      "install -d -m0755 ${DEST}/usr/share/fonts/TTF",
      "install -m0755 build/* ${DEST}/usr/share/fonts/TTF",
    ]
  }
}
& {
  lib,
  drvs,
  fontforge | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/fontforge/fontforge/archive/refs/tags/20230101.tar.gz",
      sha256sum = "ab0c4be41be15ce46a1be1482430d8e15201846269de89df67db32c7de4343f1"
    },
    biDrvs = [
      drvs.freetype,
      drvs.zlibNg,
      drvs.gperf,
      drvs.expat,
      drvs.fontconfig,
      drvs.gettext,
      drvs.libxml2,
      drvs.pixman,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.libffi,
      drvs.libxkbcommon,
      drvs.linuxHeaders,
      drvs.ncurses,
      drvs.readline,
      drvs.pcre2,
      drvs.pango,
      drvs.cairo,
      drvs.libpng,
      drvs.harfbuzz,
      drvs.glibDynamic,
      drvs.muslShared,
      drvs.hwdata,
      drvs.gobjectDynamic,
      drvs.cairoGobject,
      drvs.fribidi,
      drvs.gdkPixbufFull,
      drvs.libjpegTurboStatic,
      drvs.libepoxy,
      drvs.atSpi2Core,
      drvs.mesa2,
      drvs.libelf,
      drvs.libdrm,
      drvs.libpciaccess,
      drvs.llvmConfigStatic,
      drvs.spirvTools,
      drvs.spirvLlvmTranslator,
      drvs."gtk+3",

      # drvs.pythonFull,
      drvs.libtiff,
    ],

    cmakeExtraArgsRecord = {
      "-DBUILD_TESTING" = false,
      "-DENABLE_DOCS" = false,
      "-DENABLE_GUI" = false,
      "-DENABLE_LIBSPIRO" = false,
      "-DENABLE_LIBGIF" = false,
      "-DENABLE_WOFF2" = false,
      "-DENABLE_PYTHON_SCRIPTING" = false,
    },
    preConfigurePhase = [
      "sed -i 's@add_subdirectory(po)@#add_subdirectory(po)@g' ${SRC}/CMakeLists.txt",
    ],

    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lreadline",
        "-lncursesw",
        "-lpcre2-8",
        "-lc++",
        "-lffi",
        "-lgmodule-2.0",
        "-lgio-2.0",
      ]
    },
  }
}
& {
  lib,
  drvs,
  perlFontTtf | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/silnrsi/font-ttf/archive/8a57acd3a58950de585852c9ad0d9f74afcfecac.zip",
      sha256sum = "6ed1b84a7731a567d744ad80a8c33eee4d928ec2e3d16af13f24411debe9f78a"
    },
    biDrvs = [
      drvs.perl,
    ],
    preBuildPhase = [
      "perl Makefile.PL"
    ]
  }
}
& {
  lib,
  drvs,
  perlIoString | lib.MakePackage = {
    singleSource = {
      uri = "https://www.cpan.org/authors/id/G/GA/GAAS/IO-String-1.08.tar.gz",
      sha256sum = "2a3f4ad8442d9070780e58ef43722d19d1ee21a803bf7c8206877a10482de5a0"
    },
    biDrvs = [
      drvs.perl,
    ],
    preBuildPhase = [
      "perl Makefile.PL"
    ]
  }
}
