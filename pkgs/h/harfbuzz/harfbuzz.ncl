{
  lib,
  drvs,
  harfbuzz | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/harfbuzz/harfbuzz/archive/refs/tags/14.5.1.tar.gz",
      sha256sum = "a058ff4c32dad1e163cd62dce4bca81035f7fbc060bc52fc97f6079c4446ec44"
    },
    extraMesonArgs = [
      "-Dfreetype=enabled",
      "-Dcairo=enabled"
    ],
    pDrvs = [
      # drvs.freetype,
      drvs.cairo,
      # drvs.zlibNg,
      # drvs.pixman,
      # drvs.fontconfig,
      # drvs.libpng,
      # drvs.expat
    ]
  }
}
& {
  lib,
  drvs,
  harfbuzz,
  harfbuzzFull | lib.MesonPackage = {
    singleSource = harfbuzz.singleSource,
    extraMesonArgs = [
      "-Dfreetype=enabled",
      "-Dcairo=enabled",
      "-Dglib=enabled",
    ],
    pDrvs = [
      # drvs.freetype,
      drvs.cairo,
      # drvs.zlibNg,
      # drvs.pixman,
      # drvs.fontconfig,
      # drvs.libpng,
      # drvs.expat,
      # drvs.pcre2,
      # drvs.libffi,
      drvs.glib,
    ]
  },
  harfbuzzIcu | lib.MesonPackage = {
    singleSource = harfbuzz.singleSource,
    extraMesonArgs = [
      "-Dfreetype=enabled",
      "-Dcairo=enabled",
      "-Dglib=enabled",
      "-Dicu=enabled",
    ],
    pDrvs = [
      # drvs.freetype,
      drvs.cairo,
      # drvs.zlibNg,
      # drvs.pixman,
      # drvs.fontconfig,
      # drvs.libpng,
      # drvs.expat,
      # drvs.pcre2,
      # drvs.libffi,
      drvs.glib,
      drvs.libicu,
    ]
  },
  harfbuzzGobjectDynamic =
    harfbuzzGobject
    & {
      # ERROR: pkg-config: error executing command ['pkg-config --static', '--cflags', 'glib-2.0', 'gobject-2.0']: [Errno 2] No such file or directory: 'pkg-config --static'
      buildEnv.PKG_CONFIG = null,
      extraMesonArgs | priority 1 = [
        "-Dfreetype=enabled",
        "-Dcairo=enabled",
        "-Dglib=enabled",
        "-Dintrospection=enabled",
        "-Ddefault_library=shared",
      ],
    },
  harfbuzzGobject | lib.MesonPackage = {
    singleSource = harfbuzz.singleSource,
    buildEnv.EXTRA_LDFLAGS = [
      "$(pkg-config --libs --static zlib)",
    ],
    extraMesonArgs = [
      "-Dfreetype=enabled",
      "-Dcairo=enabled",
      "-Dglib=enabled",
      "-Dintrospection=enabled",
      "--prefer-static",
      "-Ddefault_library=both",
    ],
    # mesonArgsStatic = [
    #   "--prefer-static",
    #   "-Ddefault_library=both",
    # ],
    isStatic = false,
    preConfigurePhase = [
      m%"sed -i "s@and get_option('default_library') != 'static'@@g" ${SRC}/src/meson.build"%,
    ],
    pythonProvider = drvs.pythonDynamic,

    biDrvs = [
      drvs.freetype,
      drvs.cairo,
      drvs.zlibNgPic,
      drvs.pixman,
      drvs.fontconfig,
      drvs.libpngPic,
      drvs.expat,
      drvs.pcre2,
      drvs.libffi,
      drvs.glibDynamic2,
      drvs.gobjectDynamicData,
      drvs.muslShared & { priority = -1 },
      drvs.pythonSetuptools,
      drvs.ldd,
    ]
  },
}
