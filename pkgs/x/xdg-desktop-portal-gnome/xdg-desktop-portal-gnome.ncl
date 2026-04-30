{
  lib,
  drvs,
  xdgDesktopPortalGnome | lib.MesonPackage = {
    options = {
      elogind | default = true
    },

    singleSource = {
      uri = "https://gitlab.gnome.org/GNOME/xdg-desktop-portal-gnome/-/archive/48.0/xdg-desktop-portal-gnome-48.0.tar.bz2",
      sha256sum = "913a89553d2a222cef420d4d56672539d1a6075cd56e0a6d17f6120a3d695208"
    },

    sourceInputs = [
      { src = singleSource },
      {
        src = {
          uri = "https://gitlab.gnome.org/GNOME/libgxdp/-/archive/e68375c7aced97705953b8e3b30af9f17991153b/libgxdp-e68375c7aced97705953b8e3b30af9f17991153b.tar.bz2",
          sha256sum = "f44f79dc2809d4941f1c8bc3f92517d055607311cfbe6748c2cdaf064a769cbe"
        },
        dest = "subprojects/libgxdp"
      },
      # {
      #   src = {
      #     # uri = "https://gitlab.gnome.org/GNOME/libadwaita/-/archive/1.6.9/libadwaita-1.6.9.tar.bz2",
      #     # sha256sum = "8fde4bb8d237d9ba0b75ac7be71319ca1fb517b667125e0457c1af1da1e1f4d1",

      #     uri = "https://gitlab.gnome.org/GNOME/libadwaita/-/archive/1.7.6/libadwaita-1.7.6.tar.bz2",
      #     sha256sum = "05a44635a3481d207ce61204e3fd80bcd693cce12620b85b63cffdb6dc5c6542"
      #   },
      #   dest = "subprojects/libadwaita"
      # }
    ],

    # extraMesonArgs = [
    #   "-Dsettings=enabled",
    #   "-Dappchooser=enabled",
    #   "-Dlockdown=disabled",
    # ],

    # libcamera needs -lc++
    buildEnv = {
      EXTRA_LDFLAGS = [
        # "-lc++",
        "-ldl_factory",
      ],
    },
    preConfigurePhase = [
      m%"sed -i "s|dependencies: deps,|dependencies: deps,\nlink_args: \[ '/usr/lib/adwaita_init_resources.o' \],|g" ${SRC}/src/meson.build"%,
    ],
    llvmProvider = drvs.llvmFull,
    muslProvider = drvs.muslBothRenamedDl,

    biDrvs = [
      drvs.libadwaitaInitResources,
      drvs.libdlFactory,
      drvs.alsaLibs,
      drvs.appstream,
      drvs.atSpi2Core,
      drvs.bison,
      drvs.bluez,
      drvs.bubblewrap,
      drvs.cairo,
      drvs.cairoGobject,
      drvs.curl,
      drvs.dbus,
      drvs.docutils,
      drvs.elogindWithPolkit,
      drvs.eudev,
      drvs.expat,
      drvs.fdkAac,
      drvs.feedbackd,
      drvs.ffmpeg,
      drvs.flatpak,
      drvs.fontconfig,
      drvs.freetype,
      drvs.fribidi,
      drvs.fuse,
      drvs.gdkPixbufFull,
      drvs.gettext,
      drvs.glibPatched,
      drvs.gmobile,
      drvs.gnomeDesktop4,
      drvs.gobjectDynamic,
      drvs.gperf,
      drvs.gpgme,
      drvs.graphene,
      drvs.gsettingsDesktopSchemas,
      drvs.gsound,
      drvs.gtk3,
      drvs.gtk4ForGnome,
      drvs.gudev,
      drvs.harfbuzzFull,
      drvs.hwdata,
      drvs.inih,
      drvs.isoCodes,
      drvs.jansson,
      drvs.jsonGlib,
      drvs.kmod,
      drvs.ldacbt,
      drvs.libarchive,
      drvs.libassuan,
      drvs.libbsd,
      drvs.libcanberra,
      drvs.libcap,
      drvs.libdrm,
      drvs.libelf,
      drvs.libepoxy,
      drvs.libevdev,
      drvs.libffi,
      drvs.libfreeaptx,
      drvs.libgpgError,
      drvs.libgtop,
      drvs.libjpegTurbo,
      drvs.libmd,
      drvs.libogg,
      drvs.libopus,
      drvs.libpciaccess,
      drvs.libpng,
      drvs.libportal,
      drvs.libpsl,
      drvs.libseccomp,
      drvs.libsndfile,
      drvs.libtiff,
      drvs.libtool,
      drvs.libusb,
      drvs.libvorbis,
      drvs.libxkbcommon,
      drvs.libxml2,
      drvs.libxmlb,
      drvs.libxslt,
      drvs.libyaml,
      drvs.linuxHeaders,
      drvs.llvmConfigStatic,
      drvs.lua,
      drvs.lz4,
      drvs.m4,
      drvs.mesa2,
      # drvs.muslShared,
      drvs.ncurses,
      drvs.openssl,
      drvs.ostree,
      drvs.pango,
      drvs.pcre2,
      drvs.pipewire,
      drvs.pixman,
      drvs.polkit,
      drvs.readline,
      drvs.sassc,
      drvs.sbc,
      drvs.spirvLlvmTranslator,
      drvs.spirvTools,
      drvs.utilLinux,
      # drvs.vala,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.xdgDbusProxy,
      drvs.xdgDesktopPortal,
      drvs.xdgDesktopPortalGtk,
      drvs.xkeyboardConfig,
      drvs.xz,
      drvs.zlibNg,
      drvs.zstd,
      drvs.libadwaita,
    ]
    # @ (
    #   if options.elogind then
    #     [
    #       drvs.elogindWithPolkit,
    #       drvs.polkit,
    #     ]
    #   else
    #     [
    #       drvs.basuUdevCompatible,
    #     ]
    # )
  },
  gtk4,
  gtk4ForGnome =
    gtk4
    & {
      postInstallPhase | priority 1 =
        gtk4.postInstallPhase
        @ [
          "cd ${DEST}/usr/lib",
          "llvm-objcopy --redefine-sym properties=__gtk4_private_properties libgtk-4.a",
        ]
    }
}
