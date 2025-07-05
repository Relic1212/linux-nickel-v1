{
  lib,
  drvs,
  _gobject | lib.MesonPackage = {
    singleSource = {
      uri = "https://download.gnome.org/sources/gobject-introspection/1.82/gobject-introspection-1.82.0.tar.xz",
      sha256sum = "0f5a4c1908424bf26bc41e9361168c363685080fbdb87a196c891c8401ca2f09",
    },
    pythonProvider = drvs.pythonDynamic,
    biDrvs = [
      drvs.pythonSetuptools,
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNgPic,
      drvs.glib,
      (drvs.glibDynamic & { priority = -1 }),
      drvs.flex,
      drvs.bison,
      drvs.m4,
      drvs.libtool,
      drvs.cairo,
      drvs.pixman,
      drvs.freetype,
      drvs.fontconfig,
      drvs.libpng,
      drvs.expat,
      drvs.muslShared,
      drvs.binutils,
      drvs.lddObjdump,
      drvs.gobjectDynamic,
    ],

    preConfigurePhase = [
      m%"find "${SRC}" -name "meson.build"|xargs sed -i 's/shared_library/library/g'"%,
    ],
  },

  gobject =
    _gobject
    & {
      ectraMesonArgs = [
        "-Dgi_cross_use_prebuilt_gi=true",
        "-Dgi_cross_binary_wrapper=/usr/bin/g-ir-compiler",
        "-Dbuild_introspection_data=false",
      ]
    },

  gobjectDynamic | lib.MesonPackage =
    _gobject
    & {
      isStatic | force = false,
      buildEnv = {
        _isStatic | force = false
      },
      biDrvs | priority 1 = [
        drvs.pythonSetuptools,
        drvs.pcre2,
        drvs.libffi,
        drvs.zlibNgPic,
        drvs.glibDynamic,
        drvs.flex,
        drvs.bison,
        drvs.m4,
        drvs.libtool,
        drvs.cairo,
        drvs.pixman,
        drvs.freetype,
        drvs.fontconfig,
        drvs.libpng,
        drvs.expat,
        drvs.muslShared,
        drvs.binutils,
        drvs.lddObjdump,
      ],
      extraMesonArgs = [
        "--prefer-static",
        "-Ddefault_library=static",
        "-Dbuild_introspection_data=false",
      ]
      # biDrvs |priority 1 = gobject.biDrvs @ [drvs.muslShared],
    },

  glib,

  glibDynamic =
    glib
    & {
      isStatic | force = false,
      buildEnv = {
        _isStatic | force = false
      },
      postInstallPhase | priority 1 = [],
      extraMesonArgs | priority 1 = ["-Dglib_assert=false", "-Dnls=disabled", "-Dglib_debug=disabled", "-Dtests=false", "--prefer-static", "-Ddefault_library=static"],
      biDrvs | priority 1 = [
        drvs.pcre2,
        drvs.libffi,
        drvs.zlibNgPic,
        drvs.muslShared
      ],
    },

  glibGobject =
    glib
    & {
      pythonProvider = drvs.pythonDynamic,
      # extraMesonArgs | priority 1
      #   =
      #     glib.extraMesonArgs
      #     @ [
      #       "-Dintrospection=enabled",
      #     ],
      biDrvs | priority 1 = [
        drvs.pcre2,
        drvs.libffi,
        drvs.zlibNgPic,
        drvs.muslShared,
        drvs.gobjectDynamic,
        drvs.cairo,
        drvs.pixman,
        drvs.freetype,
        drvs.fontconfig,
        drvs.libpng,
        drvs.expat,
        #  (drvs.glib & { priority = -2 }),
        drvs.pythonSetuptools,
        drvs.ldd,
        drvs.glibDynamic,
        drvs.flex,
        drvs.bison,
        drvs.m4,
        drvs.libtool,
      ],
      isStatic | force = false,
      buildEnv = {
        _isStatic | force = false
      },
      # postInstallPhase | priority 1 = [],
      extraMesonArgs | priority 1 = ["-Dglib_assert=false", "-Dnls=disabled", "-Dglib_debug=disabled", "-Dtests=false", "--prefer-static", "-Ddefault_library=static", "-Dintrospection=enabled"],
    }
}
& {
  lib,
  ldd | lib.Package = {
    installPhase = [
      "install -d -m0755 ${DEST}/usr/bin",
      "cd ${DEST}/usr/bin",
      "ln -s /usr/lib/libc.so ldd",
    ]
  },
  lddObjdump | lib.Package = {
    installPhase = [
      "install -d -m0755 ${DEST}/usr/bin",
      "cd ${DEST}/usr/bin",
      m%"
      echo "#!/bin/sh
objdump -p \"\$@\"
" > ldd
chmod +x ldd
      "%,
    ]
  }
}
