{
  lib,
  drvs,
  libadwaita | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.gnome.org/GNOME/libadwaita/-/archive/1.7.6/libadwaita-1.7.6.tar.gz",
      sha256sum = "8112df4e98dcfd249c0a38bcb7100212cb8e69ac53371fc8e875200752a360df"
    },

    llvmProvider = drvs.llvmFull,
    pythonProvider = drvs.pythonDynamic,

    biDrvs = [
      drvs.atSpi2Core,
      drvs.cairo,
      drvs.cairoGobject,
      drvs.eudev,
      drvs.expat,
      drvs.feedbackd,
      drvs.fontconfig,
      drvs.freetype,
      drvs.fribidi,
      drvs.gdkPixbufFull,
      drvs.gettext,
      drvs.glibDynamic,
      drvs.gmobile,
      drvs.gnomeDesktop,
      drvs.gobjectDynamic,
      drvs.gperf,
      drvs.graphene,
      drvs.gsettingsDesktopSchemas,
      drvs.gsound,
      drvs.gtk4,
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
      drvs.pango_1_56,
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
    }
}
