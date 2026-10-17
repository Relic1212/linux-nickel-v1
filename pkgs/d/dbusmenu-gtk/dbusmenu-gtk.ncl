{
  lib,
  drvs,
  dbusmenuGtk | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://launchpad.net/libdbusmenu/16.04/16.04.0/+download/libdbusmenu-16.04.0.tar.gz",
      sha256sum = "b9cc4a2acd74509435892823607d966d424bd9ad5d0b00938f27240a1bfa878a"
    },
    llvmProvider = drvs.llvmFull,
    # perlProvider = drvs.perlDynamic,
    # 
    biDrvs = [
      drvs.muslShared,
      drvs.intltool,

      ## py
      drvs.pythonFull,
      ## -py

      ### autotools ###
      # drvs.perl,
      drvs.perlDynamic,
      drvs.perlXmlParserDynamic,
      drvs.gettext,
      drvs.bison,
      drvs.flex,
      drvs.m4,
      drvs.pkgconf,
      drvs.libtool,

      ### END autotools ##
      drvs.gtkDoc,
    ],
    pDrvs = [
      drvs.gtk3,
      drvs.gudev,
      # drvs.vala,
      drvs.libpsl,
      drvs.libxml2,
      drvs.jsonGlib,
      drvs.libyaml,
      drvs.libxmlb,
      drvs.libvorbis,
      drvs.libogg,
      ## -X
    ],
    extraConfigureFlags = [
      "--with-gtk=3",
      "--disable-dumper",
      "--enable-introspection=no",
      "--disable-vala",
    ]
  },

  dbusmenuGtkIntrospection | lib.AutotoolsPackage = {
    singleSource = dbusmenuGtk.singleSource,
    buildEnv = {
      PKG_CONFIG = null,
      _isStatic = false,
      EXTRA_LDFLAGS = [
        "$(pkg-config --libs --static gtk+-3.0)",
      ]
    },

    llvmProvider = drvs.llvmFull,
    # perlProvider = drvs.perlDynamic,
    # muslProvider = drvs.muslBothRenamedDl,
    # 
    preConfigurePhase = [
      # "dl-func > ${SRC}/dlopen.c",
      # "${CC} ${CFLAGS} -Werror -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
      # "${AR} rcs ${SRC}/libdlopen.a ${SRC}/dlopen.o",
      # "export LDFLAGS=\"${LDFLAGS} ${SRC}/libdlopen.a\"",
    ],
    biDrvs = [
      drvs.pythonDlFunc,
      drvs.muslShared,
      drvs.intltool,

      ## py
      drvs.pythonDynamic,
      ## -py

      ### autotools ###
      # drvs.perl,
      drvs.perlDynamic,
      drvs.perlXmlParserDynamic,
      drvs.gettext,
      drvs.bison,
      drvs.flex,
      drvs.m4,
      drvs.pkgconf,
      drvs.libtool,

      ### END autotools ##
      drvs.gtkDoc,
      drvs.pythonSetuptools80,
      drvs.ldd,
      drvs.glibGobject & { priority = -2 },
      drvs.pangoGobject & { priority = -1 },
      drvs.harfbuzzGobjectDynamic & { priority = -1 },
      drvs.gdkPixbufIntrospection & { priority = -1 },
      drvs.grapheneIntrospection & { priority = -1 },
      drvs.glibGobjectDynamic & { priority = -1 },
      drvs.gobjectDynamicCairo2 & { priority = -1 },
      drvs.atSpi2CoreIntrospection & { priority = -1 },
      drvs.gtk3Introspection & { priority = -1 },
    ],
    pDrvs = [
      drvs.gtk3,
      drvs.gudev,
      # drvs.vala,
      drvs.libpsl,
      drvs.libxml2,
      drvs.jsonGlib,
      drvs.libyaml,
      drvs.libxmlb,
      drvs.libvorbis,
      drvs.libogg,
      ## -X
    ],
    extraConfigureFlags = [
      "--with-gtk=3",
      "--disable-dumper",
      "--enable-introspection=yes",
      "--disable-vala",
    ]
  },
}
