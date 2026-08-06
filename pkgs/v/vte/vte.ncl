{
  lib,
  drvs,
  vte | lib.MesonPackage = {
    singleSource = {
      # uri = "https://gitlab.gnome.org/GNOME/vte/-/archive/0.80.3/vte-0.80.3.tar.gz",
      # sha256sum = "8567106c7664251e950cfd81db29034b2e4e2e8c1abf6a0cc4ea56394cf21074",

      #uri = "https://gitlab.gnome.org/GNOME/vte/-/archive/0.79.91/vte-0.79.91.tar.gz",
      #sha256sum = "8f6d9ac516ad3fedebaa439f62ebcc98a2a5d96c3326a7a860dfc49b646423d6",

      uri = "https://gitlab.gnome.org/GNOME/vte/-/archive/0.82.1/vte-0.82.1.tar.bz2",
      sha256sum = "8ba2a82c19c96e56fb77560c1caa49ca0a236e65d3b9123465794d863cd2a0d1"
    },

    buildEnv = {
      # EXTRA_LDFLAGS = [
      #     "$(pkg-config --libs --static harfbuzz)",
      # ],
    },
    extraMesonArgs = [
      "-Da11y=false",
      "-D_b_symbolic_functions=false",
      "-Dgir=false",
      "-Dgnutls=true",
      "-Dicu=false",
      "-Dgtk4=true",
      "-Dgtk3=true",
      "-D_systemd=false",
      "-Dvapi=false",

      #"-Dcpp_link_args=\"$(pkg-config --libs --static harfbuzz)\""
    ],
    # https://gitlab.gnome.org/GNOME/vte/-/issues/72

    preConfigurePhase = [
      # m%"
      # sed -i 's@W_EXITCODE(ret, sig)@((ret) << 8 | (sig))@g' ${SRC}/src/widget.cc
      # "%,
      m%"
        sed -i 's@W_EXITCODE(0, SIGKILL)@((0) << 8 | (SIGKILL))@g' ${SRC}/src/widget.cc
        "%,
      "sed -i 's@shared_library@library@g' ${SRC}/src/meson.build",

      #"sed -i 's@_vte_debug_hexdump@_vte_debug_hexdump_debug_private@g' ${SRC}/src/debug.cc",

      # "sed -i 's@_vte_debug_hexdump@_vte_debug_hexdump_debug_private@g' ${SRC}/src/debug.hh",
      "sed -i 's@debug_sources +@@g' ${SRC}/src/app/meson.build",
    ],
    # buildPhase = [
    #     "ninja src/libvte-2.91.a",
    #     "echo 'LIBVTE IS BUILT'",
    #     "ninja src/libvte-2.91-gtk4.a",
    # ],
    # installPhase = [

    # ]

    llvmProvider = drvs.llvmFull,
    pythonProvider = drvs.pythonDynamic,
    biDrvs = [
      drvs.muslShared,
    ],
    neverInclude = [
      drvs.harfbuzz,
    ],
    pDrvs = [
      drvs.fastFloat,

      #drvs.harfbuzz,
      # drvs.atSpi2Core,
      drvs.gmobile,
      drvs.gnomeDesktop,

      # drvs.gsettingsDesktopSchemas,
      drvs.gsound,
      drvs.gtk4,
      # drvs.librsvg,
      # drvs.gudev,
      # # drvs.harfbuzz,
      # drvs.harfbuzzFull,
      # drvs.hwdata,
      # drvs.isoCodes,
      # drvs.jsonGlib,
      # drvs.kmod,
      # drvs.libbsd,
      # drvs.libcanberra,
      # drvs.libdrm,
      # drvs.libelf,
      # drvs.libepoxy,
      # drvs.libffi,
      # drvs.libgtop,
      # drvs.libjpegTurbo,
      # drvs.libmd,
      # drvs.libogg,
      # drvs.libpciaccess,
      # drvs.libpng,
      # drvs.libportal,
      # drvs.libpsl,
      # drvs.libseccomp,
      # drvs.libtiff,
      # drvs.libtool,
      # drvs.libvorbis,
      # drvs.libxkbcommon,
      # drvs.libxml2,
      # drvs.libxmlb,
      # drvs.libyaml,
      # drvs.linuxHeaders,
      # drvs.llvmConfigStatic,
      # drvs.mesa2,
      # drvs.muslShared,
      # drvs.ncurses,
      # drvs.openssl,
      # drvs.pango,
      # drvs.pcre2,
      # drvs.pixman,
      # drvs.readline,
      # drvs.spirvLlvmTranslator,
      # drvs.spirvTools,
      # drvs.utilLinux,
      # drvs.wayland,
      # drvs.waylandProtocols,
      # drvs.xkeyboardConfig,
      # drvs.xz,
      # drvs.zlibNg,
      # drvs.zstd,
      # drvs.sassc,
      drvs.appstream,
      # drvs.curl,
      drvs.lz4,
      # drvs.gtk3,
      drvs.simdutf,
      drvs.fmt,
      # drvs.gmp,
      # drvs.libtasn1,
      # drvs.nettleGmp,
      drvs.gnutls,
      # drvs.p11Kit,
    ],
  }
}
