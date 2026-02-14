{
  lib,
  drvs,
  hyprcursor | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {

      uri = "https://github.com/hyprwm/hyprcursor/archive/refs/tags/v0.1.13.tar.gz",
      sha256sum = "82af8b2ce27242ffdd6baebaa71b3f6c8665dc25c52bfcfccc16912622896af8",
    },
    patches = [
      {
        sha256sum = "9a39fa9ec0b150627f34c6f64a5dda260f40918b2ae278c70a6992bb8b87a035",
        file = "hyprcyrsor-no-svg-v3.patch",
      }
    ],
    biDrvs = [
      drvs.cairo,
      drvs.libzip,
      drvs.pixman,
      drvs.zlibNg,
      drvs.freetype,
      drvs.fontconfig,
      drvs.libpng,
      drvs.expat,
      drvs.hyprlang,
      drvs.hyprUtils,
      drvs.tomlplusplus,

      # drvs.librsvg,
    ],
    buildEnv = {
      EXTRA_CXXFLAGS = [
        "-l:libhyprlang.a -l:libhyprutils.a"
      ],
    },
    preConfigurePhase = [
      m%"
        sed -i \
          's@hyprcursor SHARED@hyprcursor STATIC@g' \
          ${SRC}/CMakeLists.txt
        "%,
    ],
  }
}
& {
  lib,
  drvs,
  libzip | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/nih-at/libzip/releases/download/v1.11.2/libzip-1.11.2.tar.xz",
      sha256sum = "5d471308cef4c4752bbcf973d9cd37ba4cb53739116c30349d4764ba1410dfc1",
    },
    biDrvs = [
      drvs.zlibNg,
    ]
  }
}
& {
  lib,
  drvs,
  tomlplusplus | lib.MesonPackage = {
    # generator="Ninja",
    singleSource = {
      uri = "https://github.com/marzer/tomlplusplus/archive/refs/tags/v3.4.0.tar.gz",
      sha256sum = "8517f65938a4faae9ccf8ebb36631a38c1cadfb5efa85d9a72e15b9e97d25155",
    },
    biDrvs = [
      drvs.cmake,
    ]
  }
}
& {
  lib,
  drvs,
  udis86 | lib.AutomakePackage = {
    # generator = "Ninja",
    sourceInputs = [
      {
        src = {
          uri = "https://github.com/canihavesomecoffee/udis86/archive/5336633af70f3917760a6d441ff02d93477b0c86.zip",
          sha256sum = "91c06980bd6abce1cd071196e3af655599ca2fcfd62328f06fcd915ed2645671",
        }
      }
    ],

    biDrvs = [
      drvs.pythonFull,
    ]
  }
}
