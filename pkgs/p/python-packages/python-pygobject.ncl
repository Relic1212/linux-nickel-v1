{
  lib,
  drvs,
  pythonPygobject | lib.MesonPackage = {
    singleSource = {
      # uri = "https://download.gnome.org/sources/pygobject/3.52/pygobject-3.52.3.tar.gz",
      # sha256sum = "00e427d291e957462a8fad659a9f9c8be776ff82a8b76bdf402f1eaeec086d82",
      uri = "https://download.gnome.org/sources/pygobject/3.58/pygobject-3.58.1.tar.gz",
      sha256sum = "4c80598ade17fbaa7798e01a25d0bf29ce109740786026a074c5c62bb3e79d23",
    },
    isStatic = false,
    buildEnv._isStatic = false,
    extraMesonArgs = [
      "-Dtests=false",
      # "-Dpycairo=disabled",
    ],
    pythonProvider = drvs.pythonDynamic,
    biDrvs = [
      drvs.pythonSetuptools,
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNgPic,
      # drvs.glibDynamic,
      drvs.flex,
      drvs.bison,
      drvs.m4,
      drvs.libtool,
      # drvs.cairoGobject,
      drvs.pixman,
      drvs.freetype,
      drvs.fontconfig,
      drvs.libpngPic,
      drvs.expat,
      drvs.muslShared,
      # drvs.binutils,
      # drvs.lddObjdump,
      # drvs.gobjectDynamic,
      drvs.pythonPycairo,
      drvs.glibGobjectDynamic & { priority = -2 },
      drvs.gobjectDynamicCairo2 & { priority = -1 },
      drvs.gtk4IntrospectionDynamic & { priority = -1 },
      drvs.gtk4LayerShellIntrospection & { priority = -1 },
      drvs.harfbuzzGobjectDynamic & { priority = -1 },
      drvs.pangoGobject & { priority = -1 },
      drvs.libadwaitaIntrospection & { priority = -1 },
    ]
  },

  pythonPygobjectStatic | lib.MesonPackage = {
    singleSource = pythonPygobject.singleSource,
    # isStatic = false,
    # buildEnv._isStatic = false,
    extraMesonArgs = [
      "-Dtests=false",
      "-Dpycairo=disabled",
      # "-Dpycairo=enabled",
    ],
    # pythonProvider = drvs.pythonDynamic,
    preConfigurePhase = [
      m%"sed -i 's@python.extension_module@library@g' ${SRC}/gi/meson.build"%,
      m%"sed -i "s@subdir : 'gi',@# subdir : 'gi',@g" ${SRC}/gi/meson.build"%,
    ],
    eofPatches = [
      # { patch = import "python-pygobject-static.patch" as 'Text, },
    ],
    biDrvs = [
      drvs.gnupatch & { priority = 1 },
      drvs.pythonSetuptools,
    ],
    pDrvs = [
      drvs.glib,
      # drvs.cairoGobject,
    ],
  },

  girepositoryFiles | lib.Package = {
    installPhase = [
      "install -dm0755 ${DEST}/usr/lib",
      "cp -r /usr/lib/girepository-1.0 ${DEST}/usr/lib/girepository-1.0",
    ],
    biDrvs = [
      drvs.glibGobjectDynamic & { priority = -2 },
      drvs.gobjectDynamicCairo2 & { priority = -1 },
      drvs.grapheneIntrospection & { priority = -1 },
      drvs.gtk4IntrospectionDynamic & { priority = -1 },
      drvs.gtk4LayerShellIntrospection & { priority = -1 },
      drvs.harfbuzzGobjectDynamic & { priority = -1 },
      drvs.libadwaitaIntrospection & { priority = -1 },
      drvs.pangoGobject & { priority = -1 },
      drvs.gdkPixbufIntrospectionDynamic & { priority = -1 },
      drvs.atSpi2CoreIntrospection & { priority = -1 },
      drvs.gtk3Introspection & { priority = -1 },
      drvs.dbusmenuGtkIntrospection & { priority = -1 },
      drvs.gtkLayerShellIntrospection & { priority = -1 },
    ]
  },
}
