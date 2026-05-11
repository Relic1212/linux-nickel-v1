{
  lib,
  drvs,
  _gobject | lib.MesonPackage = {
    singleSource = {
      uri = "https://download.gnome.org/sources/gobject-introspection/1.86/gobject-introspection-1.86.0.tar.xz",
      sha256sum = "920d1a3fcedeadc32acff95c2e203b319039dd4b4a08dd1a2dfd283d19c0b9ae",
    },
    options = {
      libpng | default = drvs.libpng,
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
      options.libpng,
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
        _isStatic | force = false,
        PKG_CONFIG = null,
      },
      options = {
        cairo | default = drvs.cairo,
        extraBiDrvs | default = []
      },
      biDrvs | priority 1 =
        [
          drvs.binutils,
          drvs.bison,
          options.cairo,
          drvs.expat,
          drvs.flex,
          drvs.fontconfig,
          drvs.freetype,
          drvs.glibDynamic,
          drvs.lddObjdump,
          drvs.libffi,
          options.libpng,
          drvs.libtool,
          drvs.m4,
          drvs.muslShared,
          drvs.pcre2,
          drvs.pixman,
          drvs.pythonSetuptools,
          drvs.zlibNgPic,
        ]
        @ options.extraBiDrvs,
      extraMesonArgs = [
        "--prefer-static",
        "-Ddefault_library=static",
        "-Dbuild_introspection_data=false",
      ]
    },

  gobjectDynamicCairo | lib.MesonPackage =
    gobjectDynamic
    & {
      options = {
        cairo = drvs.cairoGobject,
        libpng = drvs.libpngPic,
        extraBiDrvs = [
          (drvs.glibDynamic2 & { priority = -1 }),
        ]
      },

      preConfigurePhase | priority 1 = [],
      extraMesonArgs | priority 1 = [
        "--prefer-static",
        "-Ddefault_library=static",
        "-Dbuild_introspection_data=true",
      ]
    },
  gobjectDynamicCairo2 | lib.MesonPackage =
    gobjectDynamicCairo
    & {
      # try to fix including g_type_init
      extraMesonArgs | priority 2 = [
        # "--prefer-static",
        "-Ddefault_library=both",
        "-Dbuild_introspection_data=true",
      ]
    },

  gobjectDynamicData =
    gobjectDynamic
    & {
      # llvmProvider = drvs.llvmFullPic,
      biDrvs | priority 2 = [
        drvs.binutils,
        drvs.bison,
        drvs.cairo,
        drvs.expat,
        drvs.flex,
        drvs.fontconfig,
        drvs.freetype,
        drvs.glibDynamic2,
        # drvs.lddObjdump,
        drvs.ldd,
        drvs.libffi,
        drvs.libpng,
        drvs.libtool,
        drvs.m4,
        drvs.muslShared,
        drvs.pcre2,
        drvs.pixman,
        drvs.pythonSetuptools,
        drvs.zlibNgPic,
      ],

      buildEnv.EXTRA_LDFLAGS = ["-lffi"],
      extraMesonArgs | priority 1 = [

        # "--prefer-static",
        "-Ddefault_library=both",
        "-Dbuild_introspection_data=true",
        "-Dgir_dir_prefix=/usr/share",
      ],
      #       preConfigurePhase | priority 1 =
      #         gobjectDynamic.preConfigurePhase
      #         @ [
      #           m%"printf "foreach gir: uninstalled_gir_files\n\tinstall_data(gir.full_path(), install_dir: girdir)\nendforeach
      # " >> ${SRC}/meson.build"%,
      #         ],
      postInstallPhase = [
        "for f in $(ls gir); do if [ ! -e ${DEST}/usr/share/gir-1.0/${f} ]; then install -m0755 gir/${f} ${DEST}/usr/share/gir-1.0 ;fi;done",
        # "install -m0755 gir/GObject-2.0.gir ${DEST}/usr/share/gir-1.0",
        # "install -m0755 gir/GLib-2.0.gir ${DEST}/usr/share/gir-1.0",
      ]
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

  glibDynamic2 =
    glib
    & {
      # all the stuff,
      isStatic | force = false,
      buildEnv = {
        _isStatic | force = false
      },
      # options.patched = true,

      extraMesonArgs | priority 1 = ["-Dglib_assert=false", "-Dnls=disabled", "-Dglib_debug=disabled", "-Dtests=false", "--prefer-static", "-Ddefault_library=both"],
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
        drvs.glibDynamic2,
        # (drvs.glib & { priority = -2 }),
        drvs.pythonSetuptools,
        drvs.ldd,
        # drvs.glibDynamic,
        drvs.flex,
        drvs.bison,
        drvs.m4,
        drvs.libtool,
      ],
      isStatic | force = false,
      buildEnv = {
        _isStatic | force = false,
        PKG_CONFIG = null,
      },
      # postInstallPhase | priority 1 = [],
      extraMesonArgs | priority 1 = ["-Dglib_assert=false", "-Dnls=disabled", "-Dglib_debug=disabled", "-Dtests=false", "--prefer-static", "-Ddefault_library=static", "-Dintrospection=enabled"],
    },
  glibGobjectDynamic =
    glibGobject
    & {
      extraMesonArgs | priority 2 = ["-Dglib_assert=false", "-Dnls=disabled", "-Dglib_debug=disabled", "-Dtests=false", "-Ddefault_library=shared", "-Dintrospection=enabled"],
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
