{
  lib,
  drvs,
  noctalia | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/noctalia-dev/noctalia/releases/download/v5.0.0-beta.4/noctalia-v5.0.0-beta.4.tar.gz",
      sha256sum = "53319101d752f24086804fb8d4997dc9c760106c6bdf68c71b4bea81c577f576",
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
      "sed -i 's|lua_ident|lua_ident_compat|g' ${SRC}/third_party/luau/VM/src/lapi.cpp",
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
      drvs.md4c,
      drvs.nlohmannJsonCmake,
      drvs.tomlplusplus,
      drvs.stb,
      drvs.libsodium,
      drvs.libsecret,
    ]
  },
}
