{
  lib,
  drvs,
  noctalia | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/noctalia-dev/noctalia-shell/archive/1faa2f98a4de7ebe0725fc960fdb5e55cdb9e8da.tar.gz",
      sha256sum = "42795f7df07c0005162233ba3a047110df82bfa865ddd94c3025f9a5cf28dc36",
    },
    eofPatches = [
      #   {
      #     patch = import "noctalia-no-time_zone.patch" as 'Text
      #   },
      {
        patch = import "noctalia-full.patch" as 'Text
      },
    ],
    # separateBuildDir = false,
    # allowDubplicateBuldInputs = true,
    # enableParallel = false,
    # preConfigurePhase = [
    # "sed -i 's@cpp_std=c++20@cpp_std=c++23@g' ${SRC}/meson.build",
    # ],
    # mesonArgs,
    # configurePhase = [
    #   "meson setup %{std.string.join lib.constants.buildFlagSep mesonArgs} build ."
    # ],
    preBuildPhase = [
      "ninja cursor-shape-v1-client-protocol.h",
      "ninja dwl-ipc-unstable-v2-client-protocol.h",
      "ninja ext-background-effect-v1-client-protocol.h",
      "ninja ext-data-control-v1-client-protocol.h",
      "ninja ext-idle-notify-v1-client-protocol.h",
      "ninja ext-session-lock-v1-client-protocol.h",
      "ninja ext-workspace-v1-client-protocol.h",
      "ninja fractional-scale-v1-client-protocol.h",
      "ninja hyprland-focus-grab-v1-client-protocol.h",
      "ninja idle-inhibit-unstable-v1-client-protocol.h",
      "ninja viewporter-client-protocol.h",
      "ninja virtual-keyboard-unstable-v1-client-protocol.h",
      "ninja wlr-data-control-unstable-v1-client-protocol.h",
      "ninja wlr-foreign-toplevel-management-unstable-v1-client-protocol.h",
      "ninja wlr-layer-shell-unstable-v1-client-protocol.h",
      "ninja xdg-activation-v1-client-protocol.h",
      "ninja xdg-output-unstable-v1-client-protocol.h",
      "ninja xdg-shell-client-protocol.h",
    ],
    # installPhase = [
    #   "meson install --destdir ${DEST}"
    # ],

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
}
