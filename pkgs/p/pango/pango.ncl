{
  lib,
  drvs,
  pango | lib.MesonPackage = {
    singleSource = {

      uri = "https://download.gnome.org/sources/pango/1.56/pango-1.56.1.tar.xz",
      sha256sum = "426be66460c98b8378573e7f6b0b2ab450f6bb6d2ec7cecc33ae81178f246480"
    },
    extraMesonArgs = [
      "-Dgtk_doc=false",
      "-Dxft=disabled",
      "-Dintrospection=disabled",
      "-Dbuild-testsuite=false",
      "-Dfontconfig:tests=disabled",
    ],
    preConfigurePhase = [
      # like Kiss Linux does
      ": > ${SRC}/tests/meson.build",
      ": > ${SRC}/examples/meson.build",
      ": > ${SRC}/docs/meson.build",
      "rm -rf ${SRC}/subprojects",
    ],
    # patches = [{ file = "kisslinux-no-fribidi.patch", sha256sum = "fb69568c89cc1c00a3d5f5aaffa048ffe2d1d846a6153f7c7c2665717e10191f" }],

    pDrvs = [
      drvs.glib,
      # drvs.pcre2,
      # drvs.libffi,
      # drvs.freetype,
      # drvs.fontconfig,
      # drvs.zlibNg,
      drvs.harfbuzz,
      # drvs.cairo,
      # drvs.pixman,
      # drvs.libpng,
      # drvs.expat,
      drvs.fribidi,
    ]
  },
  pangoGobject =
    pango
    & {
      extraMesonArgs | priority 1 = [
        "-Dgtk_doc=false",
        "-Dxft=disabled",
        "-Dintrospection=enabled",
        "-Dbuild-testsuite=false",
        "-Dbuild-examples=false",
        "-Dfontconfig:tests=disabled",
        # "--prefer-static",
        "-Ddefault_library=both",
        "-Dcairo=enabled",
      ],
      buildEnv = {
        _isStatic = false,
      },
      buildEnv.PKG_CONFIG = null,

      extraEnv = {
        GI_SCANNER_DEBUG = "save-temps",
      },
      # preConfigurePhase | priority 1 =
      #   pango.preConfigurePhase
      #   @ [
      #     m%"sed -i "s|subdir('utils')||g" ${SRC}/meson.build"%,
      #   ],
      isStatic = false,
      pythonProvider = drvs.pythonDynamic,
      pDrvs | priority 1 = [],
      biDrvs | priority 1 = [
        # drvs.glibDynamic2 & { priority = -1 },
        drvs.glibGobjectDynamic & { priority = -2 },
        # drvs.glibPatched,
        drvs.pcre2,
        drvs.libffi,
        drvs.freetype,
        drvs.fontconfig,
        drvs.zlibNg,
        drvs.harfbuzzGobjectDynamic,
        drvs.cairoGobject,
        drvs.pixman,
        drvs.libpng,
        drvs.expat,
        drvs.fribidi,
        # drvs.gobjectDynamicCairo,
        drvs.gobjectDynamicCairo2,
        drvs.muslShared & { priority = -1 },
        drvs.pythonSetuptools,
        drvs.ldd,
        # drvs.cairoGobjectEmpty,
      ]
    }
}
