{
  lib,
  drvs,
  noctalia | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/noctalia-dev/noctalia/archive/4a5d8c7950b4fdef3f082b9cfd9e3fae66a14dce.tar.gz",
      sha256sum = "33d110a7969776e96b61a64bc91e3e2ffb3af0ca520e6d17ac95cca294c0f3fc",
    },

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
