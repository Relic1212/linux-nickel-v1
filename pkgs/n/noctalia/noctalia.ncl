{
  lib,
  drvs,
  noctalia | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/noctalia-dev/noctalia-shell/archive/91c16583c337f76f34267a212ee134e4ee8d6c79.tar.gz",
      sha256sum = "8ca43c12e28f3a79fe6acaf22d6ed697aaf453733c3de3e34dd814bd8f8e7822",
    },
    eofPatches = [
      #   {
      #     patch = import "noctalia-no-time_zone.patch" as 'Text
      #   },
      {
        patch = import "noctalia-full.patch" as 'Text
      },
    ],
    separateBuildDir = false,
    # allowDubplicateBuldInputs = true,
    # enableParallel = false,
    mesonArgs,
    configurePhase = [
      "meson setup %{std.string.join lib.constants.buildFlagSep mesonArgs} build ."
    ],
    buildPhase = [
      "ninja -C build cursor-shape-v1-client-protocol.h",
      "ninja -C build dwl-ipc-unstable-v2-client-protocol.h",
      "ninja -C build ext-background-effect-v1-client-protocol.h",
      "ninja -C build ext-data-control-v1-client-protocol.h",
      "ninja -C build ext-idle-notify-v1-client-protocol.h",
      "ninja -C build ext-session-lock-v1-client-protocol.h",
      "ninja -C build ext-workspace-v1-client-protocol.h",
      "ninja -C build fractional-scale-v1-client-protocol.h",
      "ninja -C build hyprland-focus-grab-v1-client-protocol.h",
      "ninja -C build idle-inhibit-unstable-v1-client-protocol.h",
      "ninja -C build viewporter-client-protocol.h",
      "ninja -C build virtual-keyboard-unstable-v1-client-protocol.h",
      "ninja -C build wlr-data-control-unstable-v1-client-protocol.h",
      "ninja -C build wlr-foreign-toplevel-management-unstable-v1-client-protocol.h",
      "ninja -C build wlr-layer-shell-unstable-v1-client-protocol.h",
      "ninja -C build xdg-activation-v1-client-protocol.h",
      "ninja -C build xdg-output-unstable-v1-client-protocol.h",
      "ninja -C build xdg-shell-client-protocol.h",
      "meson compile -C build",
    ],
    installPhase = [
      "meson install -C build --destdir ${DEST}"
    ],

    llvmProvider = drvs.llvmFull,
    pDrvs = [
      drvs.sdbusCpp,
      drvs.mesa2,
      drvs.freetype,
      drvs.fontconfig,
      drvs.expat,
      #   drvs.cairo,
      drvs.libpng,
      drvs.pixman,
      drvs.harfbuzz,
      drvs.pango,
      drvs.fribidi,
      drvs.glibPatched,
      drvs.pcre2,
      drvs.librsvg,
      drvs.gdkPixbuf,
      drvs.libxml2,
      drvs.cairoGobject,
      drvs.libxkbcommon,
      drvs.polkit,
      drvs.pipewire,
      drvs.libsndfile,
      drvs.libopus,
      drvs.lua,
      drvs.bluez,
      drvs.sbc,
      drvs.libusb,
      drvs.jansson,
      drvs.fdkAac,
      drvs.ldacbt,
      drvs.eudev,
      drvs.kmod,
      drvs.xz,
      drvs.zstd,
      drvs.alsaLibs,
      drvs.dbus,
      drvs.curl,
      drvs.libwebp,
    ]
  },
  bad | lib.Package = {
    biDrvs = [
      drvs.xz,
      drvs.xz,
    ]
  }
}
