{
  lib,
  drvs,
  xdgDesktopPortalWlr | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/emersion/xdg-desktop-portal-wlr/archive/refs/tags/v0.7.1.tar.gz",
      sha256sum = "4bddc236aa9d1a2b33e7f0bef09a8712ded51e8bc335a2b6c8cd1d088863e676"
    },
  

    extraMesonArgs = [
      "-Dsd-bus-provider=basu",
      "-Dman-pages=enabled",
    ],
        preConfigurePhase = [
      m%"sed -i 's@werror=true@werror=false@g' ${SRC}/meson.build"%
    ],


    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lc++"
      ],
    },


    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.alsaLibs,
      drvs.bison,
      drvs.cairo,
      drvs.dbus,
      drvs.eudev,
      drvs.expat,
      drvs.fontconfig,
      drvs.freetype,
      drvs.fribidi,
      drvs.fuse,
      drvs.gdkPixbufFull,
      drvs.glib,
      drvs.gperf,
      drvs.gpgme,
      drvs.harfbuzz,
      drvs.hwdata,
      drvs.jsonGlib,
      drvs.kmod,
      drvs.libarchive,
      drvs.libcap,
      drvs.libdrm,
      drvs.libelf,
      drvs.libepoxy,
      drvs.libevdev,
      drvs.libffi,
      drvs.libpciaccess,
      drvs.libpng,
      drvs.libpsl,
      drvs.libsndfile,
      drvs.libxkbcommon,
    
      drvs.linuxHeaders,
      drvs.llvmConfigStatic,
      drvs.lua,
      drvs.lz4,
      drvs.m4,
      drvs.mesa2,
      drvs.ncurses,
      drvs.openssl,
      drvs.pango,
      drvs.pcre2,
      drvs.pipewire,
      drvs.pixman,
      drvs.readline,
      drvs.spirvLlvmTranslator,
      drvs.spirvTools,
      drvs.utilLinux,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.xdgDbusProxy,
      drvs.xz,
      drvs.zlibNg,
      drvs.zstd,
      drvs.libopus,
      drvs.scdoc,
      drvs.basuUdevCompatible,
      drvs.inih,


      drvs.bluez,
      drvs.sbc,
      drvs.libusb,
      drvs.ffmpeg,
      drvs.jansson,

      drvs.libfreeaptx,
      drvs.fdkAac,
      drvs.ldacbt,
    ]
  }
}
