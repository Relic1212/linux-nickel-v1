{
  lib,
  drvs,
  hyprlandQtutils | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/hyprwm/hyprland-qtutils/archive/refs/tags/v0.1.3.tar.gz",
      sha256sum = "3e57617ebd849ebf074c492bf828efa37a5b47fd6d43b392462874069170c5ed"
    },
    llvmProvider = drvs.llvmFull,

    biDrvs = [
      drvs.pixman,
      drvs.expat,
      drvs.libffi,
      drvs.libevdev,
      drvs.mtdev,
      drvs.pango,
      drvs.cairo,
      drvs.libpng,
      drvs.freetype,
      drvs.fontconfig,
      drvs.zlibNg,
      drvs.harfbuzz,
      drvs.glib,
      drvs.hwdata,
      drvs.linuxHeaders,
      drvs.hyprwaylandScanner,
      drvs.aquamarine,
      drvs.hyprUtils,
      drvs.hyprlang,
      drvs.hyprcursor,
      drvs.libjpegTurboStatic,
      drvs.libspng,
      drvs.file,
      drvs.libwebp,
      drvs.dbusForQt,
      drvs.qtdeclarative,
      drvs.qtbase,
      drvs.qtshadertools,
      drvs.qtwayland,
      drvs.mesa2,
      # drvs.pkgconf,
      drvs.libelf,
      drvs.libdrm,
      drvs.pythonMako,
      drvs.pythonPackaging,
      drvs.pythonMarkupsafe,
      drvs.libpciaccess,
      drvs.bison,
      drvs.flex,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.m4,
      drvs.pyyaml,
      drvs.llvmConfigStatic,
      drvs.spirvTools,
      drvs.spirvLlvmTranslator,
      ###
      drvs.jsonC,
      drvs.pcre2,
      drvs.libxkbcommon,
      drvs.openssl,
      drvs.kmod,
      drvs.zstd,
      drvs.xz,
      drvs.eudev,
      drvs.libinput,
    ],
    buildEnv = {
      EXTRA_LDFLAGS = [
        "$(pkg-config --libs --static gbm glesv2 egl dri wayland-client)",
      ]
    },
    cmakeExtraArgsRecord = {
      "-DQT_DEBUG_FIND_PACKAGE" = "ON",
      "-DCMAKE_MODULE_LINKER_FLAGS:STRING" = "\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -lglapi -ldrm $(pkg-config --libs --static dri glesv2 gbm egl wayland-client)\""
    },

    patches = [
      {
        sha256sum = "fa1305ef55b815c9f130f90cf55553baa9a39670fbc7e08a1a3f602d2fc594da",
        file = "hyprland-qtutils.patch",
      }
    ],
    cmakeExtraArgsRecord = {
      "-DCMAKE_BUILD_TYPE" | priority 1 = "Release",
    },
  }
}
& (import "./hyprland-qt-support.ncl")
