{
  lib,
  drvs,
  noctalia | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/noctalia-dev/noctalia-shell/archive/99f59698a4e51ebddab4edd036edca7470f39690.tar.gz",
      sha256sum = "eae328581aef81ddb96188fd2ced076ef5e0c7bb87927f16582b319f0387920c",
    },
    eofPatches = [
      {
        patch = import "timezone.patch" as 'Text
      },
      # {
      #   patch = import "to_string.patch" as 'Text
      # },
    ],
    buildEnv = {
      EXTRA_CPPFLAGS = [
        # https://github.com/llvm/llvm-project/issues/107779#issuecomment-2339420980
        # https://releases.llvm.org/19.1.0/projects/libcxx/docs/UsingLibcxx.html
        "-fexperimental-library",
        "-I/usr/include/libxml2",
      ],
    },
    # separateBuildDir = false,
    # allowDubplicateBuldInputs = true,
    # enableParallel = false,
    preConfigurePhase = [
      "sed -i 's| log| noctalia_log|g' ${SRC}/src/system/desktop_entry_launch.cpp",
      m%"sed -i 's|std::to_string(ticks)|std::to_string(static_cast<long long>(ticks))|g' ${SRC}/src/render/core/thumbnail_service.cpp"%,
      m%"sed -i "s@#include <unistd.h>@#include <unistd.h>\n#include <errno.h>@g" ${SRC}/src/ipc/ipc_client.cpp"%,
      # "sed -i 's@cpp_std=c++20@cpp_std=c++23@g' ${SRC}/meson.build",
    ],
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
      "ninja wlr-gamma-control-unstable-v1-client-protocol.h",
    ],
    # installPhase = [
    #   "meson install --destdir ${DEST}"
    # ],

    llvmProvider = drvs.llvmFull,
    neverInclude = [drvs.glib, ],
    biDrvs = [
      drvs.librsvg,
      # drvs.gnupatch & {priority = 1 },
    ],
    pDrvs = [
      drvs.jemalloc,
      drvs.sdbusCpp,
      drvs.pango,
      drvs.glibPatched,
      drvs.gdkPixbuf,
      # drvs.libxml2,
      drvs.cairoGobject,
      drvs.polkit,
      drvs.pipewire,
      drvs.kmod,

      # drvs.curl,
      drvs.libwebp,
      drvs.libqalculate,
    ]
  },
}
