{
  lib,
  drvs,
  libadwaita | lib.MesonPackage = {
    singleSource = {
      # uri = "https://gitlab.gnome.org/GNOME/libadwaita/-/archive/1.7.6/libadwaita-1.7.6.tar.gz",
      # sha256sum = "8112df4e98dcfd249c0a38bcb7100212cb8e69ac53371fc8e875200752a360df",

      uri = "https://gitlab.gnome.org/GNOME/libadwaita/-/archive/1.8.1/libadwaita-1.8.1.tar.bz2",
      sha256sum = "56fa5cbaaf6cdcfab69bd09bde50fbd04bf6d81ee22569e45ae76abf14634d22",
    },
    patches = [
      {
        sha256sum = "5200537f94e707b32fd58442bff1970f48feafe7894ee5c7a1eabfaf66e60122",
        file = "0001-libadwaita.patch"
      }
    ],
    extraMesonArgs = [
      "-Dintrospection=disabled",
      "-Dvapi=false",
      "-Dtests=false",
      "-Dexamples=false",
      # "--prefer-static",
      # "-Ddefault_library=both",
      # "-Ddefault_library=shared",
    ],
    options = {
      gtk | default = [drvs.gtk4, drvs.glibDynamic, ],
    },
    llvmProvider = drvs.llvmFull,
    pythonProvider = drvs.pythonDynamic,

    biDrvs =
      [
        drvs.atSpi2Core,
        drvs.cairo,
        drvs.cairoGobject,
        drvs.eudev,
        drvs.expat,
        drvs.fontconfig,
        drvs.freetype,
        drvs.fribidi,
        drvs.gdkPixbufFull,
        drvs.gettext,
        drvs.gmobile,
        drvs.gnomeDesktop,
        drvs.gobjectDynamic,
        drvs.gperf,
        drvs.graphene,
        drvs.gsettingsDesktopSchemas,
        drvs.gsound,
        # drvs.gtk4,
        drvs.gudev,
        drvs.harfbuzzFull,
        drvs.hwdata,
        drvs.isoCodes,
        drvs.jsonGlib,
        drvs.kmod,
        drvs.libbsd,
        drvs.libcanberra,
        drvs.libdrm,
        drvs.libelf,
        drvs.libepoxy,
        drvs.libffi,
        drvs.libgtop,
        drvs.libjpegTurbo,
        drvs.libmd,
        drvs.libogg,
        drvs.libpciaccess,
        drvs.libpng,
        drvs.libportal,
        drvs.libpsl,
        drvs.libseccomp,
        drvs.libtiff,
        drvs.libtool,
        drvs.libvorbis,
        drvs.libxkbcommon,
        drvs.libxml2,
        drvs.libxmlb,
        drvs.libyaml,
        drvs.linuxHeaders,
        drvs.llvmConfigStatic,
        drvs.mesa2,
        drvs.muslShared,
        drvs.ncurses,
        drvs.openssl,
        drvs.pango,
        drvs.pcre2,
        drvs.pixman,
        drvs.readline,
        drvs.spirvLlvmTranslator,
        drvs.spirvTools,
        drvs.utilLinux,
        drvs.wayland,
        drvs.waylandProtocols,
        drvs.xkeyboardConfig,
        drvs.xz,
        drvs.zlibNg,
        drvs.zstd,
        drvs.sassc,
        drvs.appstream,
        drvs.curl,
        # drvs.vte,
      ]
      @ options.gtk,
  },
  libadwaitaFixedSyms | lib.MesonPackage =
    libadwaita
    & {
      preConfigurePhase = libadwaitaShared.preConfigurePhase,
    },

  libadwaitaShared | lib.MesonPackage =
    libadwaita
    & {
      isStatic = false,
      buildEnv = {
        _isStatic = false,
      },

      extraMesonArgs | priority 1 = [
        "-Dintrospection=disabled",
        "-Dvapi=false",
        "-Dtests=false",
        "-Dexamples=true",
        # "--prefer-static",
        "-Ddefault_library=both",
        #"-Ddefault_library=shared",
      ],

      preConfigurePhase = [
        m%"
            fix_symbol(){
                echo    sed -i "s@${1}(@${1}_libadwaita_privatr(@g"
                for f in $(find ${SRC}/src -type f -name '*.h' |grep -v subprojects);do
                    sed -i "s@${1} (@${1}_libadwaita_privatr (@g" $f
                    sed -i "s@_${1}_libadwaita_privatr (@_${1} (@g" $f
                done
                for f in $(find ${SRC}/src -type f -name '*.c' |grep -v subprojects);do
                    sed -i "s@${1} (@${1}_libadwaita_privatr (@g" $f
                    sed -i "s@_${1}_libadwaita_privatr (@_${1} (@g" $f
                done
            }
            "%,
        "fix_symbol \"_gtk_builder_parser_translate\"",
        "fix_symbol \"_gtk_builder_prefix_error\"",
        "fix_symbol \"_gtk_builder_error_unhandled_tag\"",
        "fix_symbol \"_gtk_builder_check_parent\"",
      ]
    },

  libadwaitaSharedNoLibs =
    libadwaitaShared
    & {
      postInstallPhase = [
        "find ${DEST}/usr/lib -name '*.so' -delete",
        "find ${DEST}/usr/lib -name '*.so.*' -delete",
      ]
    },

  libadwaitaShared_181 =
    libadwaita
    & {
      singleSource | priority 1 = {
        uri = "https://gitlab.gnome.org/GNOME/libadwaita/-/archive/1.8.1/libadwaita-1.8.1.tar.bz2",
        sha256sum = "56fa5cbaaf6cdcfab69bd09bde50fbd04bf6d81ee22569e45ae76abf14634d22",
      },
      patches | priority 1 = [],
      options = {
        # gtk = [drvs.gtk4_21, drvs.librsvg, drvs.glibNoExportDynamic, ]
        gtk = [drvs.gtk4, drvs.glibNoExportDynamic, ]
      }
    },

  libadwaitaInitResources | lib.Package = {
    enableCcache = false,
    buildPhase = [
      m%"
        echo '
extern void adw_stylesheet_get_resource(void);
extern void adw_get_resource(void);
__attribute__((constructor)) static void adwaita_init_resources()
{
	adw_stylesheet_get_resource();
	adw_get_resource();
}
' > adwaita_init_resources.c"%,
      "${CC} ${CFLAGS} -c adwaita_init_resources.c -o adwaita_init_resources.o"
    ],

    installPhase = [
      "install -dm0755 ${DEST}/usr/lib",
      "install -dm0755 ${DEST}/usr/lib/pkgconfig",
      "install -m0755 adwaita_init_resources.o ${DEST}/usr/lib",
      m%"echo 'prefix=/usr
includedir=${prefix}/include
libdir=${prefix}/lib

Name: Adwaita
Description: Building blocks for modern GNOME applications
Version: 1.7.6
Requires: glib-2.0, fribidi, gio-2.0, gtk4 >=  4.17.5, appstream
Libs: -L${prefix}/lib -ladwaita-1 /usr/lib/adwaita_init_resources.o -lm
Cflags: -I${includedir}/libadwaita-1' > ${DEST}/usr/lib/pkgconfig/libadwaita-1.pc"%,
    ],
    biDrvs = [
      drvs.llvm,
    ]
  }
}
& {
  lib,
  drvs,
  libadwaita,
  libadwaitaShared,
  libadwaitaIntrospection | lib.MesonPackage = {
    singleSource = libadwaita.singleSource,
    buildEnv = {
      _isStatic = false,
    },
    isStatic = false,
    extraMesonArgs = [
      "-Dintrospection=enabled",
      "-Dvapi=true",
      "-Dtests=false",
      "-Dexamples=false",
      # "--prefer-static",
      "-Ddefault_library=both",
      #"-Ddefault_library=shared",
    ],
    preConfigurePhase = libadwaitaShared.preConfigurePhase,
    llvmProvider = drvs.llvmFull,
    pythonProvider = drvs.pythonDynamic,

    biDrvs = [
      drvs.ldd,
      drvs.pythonSetuptools,
      drvs.gtk4Introspection,
      # drvs.glibDynamic,
      drvs.glibGobject,
      drvs.glibGobjectDynamic & { priority = -2 },
      drvs.atSpi2Core,
      drvs.cairo,
      drvs.cairoGobject,
      drvs.eudev,
      drvs.expat,
      drvs.fontconfig,
      drvs.freetype,
      drvs.fribidi,
      # drvs.gdkPixbufFull,
      drvs.gdkPixbufIntrospection,
      drvs.gettext,
      drvs.gmobile,
      drvs.gnomeDesktop,
      drvs.gobjectDynamic,
      drvs.gobjectDynamicCairo2 & { priority = -1 },
      drvs.gperf,
      drvs.grapheneIntrospection,
      drvs.gsettingsDesktopSchemas,
      drvs.gsound,
      # drvs.gtk4,
      drvs.gudev,
      drvs.harfbuzzFull,
      drvs.harfbuzzGobjectDynamic & { priority = -1 },
      drvs.hwdata,
      drvs.isoCodes,
      drvs.jsonGlib,
      drvs.kmod,
      drvs.libbsd,
      drvs.libcanberra,
      drvs.libdrm,
      drvs.libelf,
      drvs.libepoxy,
      drvs.libffi,
      drvs.libgtop,
      drvs.libjpegTurbo,
      drvs.libmd,
      drvs.libogg,
      drvs.libpciaccess,
      drvs.libpng,
      drvs.libportal,
      drvs.libpsl,
      drvs.libseccomp,
      drvs.libtiff,
      drvs.libtool,
      drvs.libvorbis,
      drvs.libxkbcommon,
      drvs.libxml2,
      drvs.libxmlb,
      drvs.libyaml,
      drvs.linuxHeaders,
      drvs.llvmConfigStatic,
      drvs.mesa2,
      drvs.muslShared,
      drvs.ncurses,
      drvs.openssl,
      drvs.pangoGobject,
      drvs.pcre2,
      drvs.pixman,
      drvs.readline,
      drvs.spirvLlvmTranslator,
      drvs.spirvTools,
      drvs.utilLinux,
      drvs.vala,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.xkeyboardConfig,
      drvs.xz,
      drvs.zlibNg,
      drvs.zstd,
      drvs.sassc,
      drvs.appstream,
      drvs.curl,
      # drvs.vte,
    ]
  }
}
