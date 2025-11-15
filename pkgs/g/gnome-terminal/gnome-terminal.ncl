{
  lib,
  drvs,

  gnomeTerminal | lib.MesonPackage = {
    singleSource = {
      # uri = "https://download.gnome.org/sources/gnome-terminal/3.56/gnome-terminal-3.56.2.tar.xz",
      # sha256sum = "235bc09dfa34cc5f1e95122e9bf60203a84daf861cfacf7e4496c5f548239978",
      uri = "https://download.gnome.org/sources/gnome-terminal/3.58/gnome-terminal-3.58.0.tar.xz",
      sha256sum = "07ebc7af13516be5b37777f520d2640b33120620e99bbb05deea5f8280fd69ce",
    },

    extraMesonArgs = [
      "-Ddocs=false",
      "-Dnautilus_extension=false",
      "-Dsearch_provider=false",
      "-Dvte:_systemd=false",
      "-Dvte:vapi=false",
    ],

    preConfigurePhase = [
      m%"
      sed -i 's@W_EXITCODE(0, SIGKILL)@((0) << 8 | (SIGKILL))@g' ${SRC}/subprojects/vte/src/widget.cc
      "%,
      m%"
      sed -i 's@W_EXITCODE(0, SIGKILL)@((0) << 8 | (SIGKILL))@g' ${SRC}/src/terminal.cc
      "%,
      m%"sed -i 's@g_module_open@g_module_open_gross_hack@g' ${SRC}/src/server.cc"%,
      m%"sed -i 's@W_EXITCODE(0, SIGKILL)@((0) << 8 | (SIGKILL))@g' ${SRC}/subprojects/vte/src/widget.cc"%,
      "sed -i 's@shared_library@library@g' ${SRC}/subprojects/vte/src/meson.build",
      "sed -i 's@debug_sources +@@g' ${SRC}/subprojects/vte/src/app/meson.build",
    ],
    llvmProvider = drvs.llvmFull,
    pythonProvider = drvs.pythonDynamic,
    biDrvs = [
      drvs.fastFloat,

      #drvs.harfbuzz,
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
      # drvs.harfbuzz,
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
      drvs.libxml2DynamicCmake,
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
      drvs.lz4,
      drvs.gtk3,
      drvs.vte,
      drvs.libhandy,
      drvs.libxslt,
      drvs.itstool,
      drvs.nettleGmp,
      drvs.gmp,
      drvs.libtasn1,
      drvs.gnutls,
      drvs.libicu,
    ],
  }
}
& {
  lib,
  drvs,
  libhandy | lib.MesonPackage = {
    singleSource = {
      # uri = "https://gitlab.gnome.org/GNOME/libhandy/-/archive/1.0.3/libhandy-1.0.3.tar.gz",
      # sha256sum = "80c7f015b8ed0888f0f6a5cb15015d120cdf0dfcacf9dddb06d4e93bd8ffef1f",

      uri = "https://gitlab.gnome.org/GNOME/libhandy/-/archive/1.8.3/libhandy-1.8.3.tar.gz",
      sha256sum = "7e7670f5d0a6d0adc24b888da44dab938a6f52472b8944d6dd4e31b6d3569a5f"
    },

    llvmProvider = drvs.llvmFull,

    extraMesonArgs = [
      "-Dintrospection=disabled",
      "-Dvapi=false",
      "-Dtests=false",
      "-Dexamples=false",
      "-Dglade_catalog=disabled",
    ],

    preConfigurePhase = [
      m%"
      for f in $(find ${SRC} -name meson.build); do
        sed -i 's@shared_library@library@g' ${f}
      done
      "%,
    ],

    patches = [
      {
        sha256sum = "8d84486dc04a8fcd592d718587cf1bb01ba786fb17cd4e0a590100c5464d981e",

        file = "libhandy.patch",
      }
    ],

    biDrvs = [
      drvs.fontconfig,
      drvs.freetype,
      drvs.zlibNg,
      drvs.gperf,
      drvs.pixman,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.libffi,
      drvs.libxkbcommon,
      drvs.expat,
      drvs.linuxHeaders,
      drvs.ncurses,
      drvs.readline,
      drvs.pcre2,
      drvs.pango,
      #drvs.cairo,
      drvs.libpng,
      drvs.harfbuzz,
      drvs.glibDynamic,
      drvs.muslShared,
      drvs.hwdata,
      drvs.gobjectDynamic,
      drvs.cairoGobject,
      drvs.fribidi,
      drvs.gdkPixbufFull,
      drvs.libjpegTurbo,
      drvs.libepoxy,
      drvs.atSpi2Core,
      drvs.mesa2,
      drvs.libelf,
      drvs.libdrm,
      drvs.libpciaccess,
      drvs.llvmConfigStatic,
      drvs.spirvTools,
      drvs.spirvLlvmTranslator,
      # drvs.gtk3Libhandy,
      drvs.gtk3,
    ],
  }
}
& {
  lib,
  drvs,
  gtk3,
  gtk3Libhandy =
    gtk3
    & {
      postInstallPhase =
        let symbols = [
          "gtk_progress_tracker_init_copy",
          "gtk_progress_tracker_start",
          "gtk_progress_tracker_finish",
          "gtk_progress_tracker_advance_frame",
          "gtk_progress_tracker_skip_frame",
          "gtk_progress_tracker_get_state",
          "gtk_progress_tracker_get_iteration",
          "gtk_progress_tracker_get_iteration_cycle",
          "gtk_progress_tracker_get_progress",
          "gtk_progress_tracker_get_ease_out_cubic",
        ]
        in

        std.array.map (fun x => "objcopy -W " ++ x ++ " ${DEST}/usr/lib/libgtk-3.a") symbols,
    }
}
& {
  lib,
  drvs,
  libicu | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://github.com/unicode-org/icu/releases/download/release-78.1/icu4c-78.1-sources.tgz",
      sha256sum = "6217f58ca39b23127605cfc6c7e0d3475fe4b0d63157011383d716cb41617886"
    },
    configureScript = "${SRC}/source/configure",
  }
}
