{
  lib,
  pkgs,

  _muslBase | lib.AutotoolsPackage
    = {
      isLlvm | default = lib.AutotoolsPackage.isLlvm,
      baseName = "musl",
      isStatic = false,
      sourceInputs = [
        {
          src = { uri = "https://musl.libc.org/releases/musl-1.2.5.tar.gz", sha256sum = "a9a118bbe84d8764da0ea0d28b3ab3fae8477fc7e4085d90102b8596fc7c75e4" }
        }
      ],
      extraEnv | priority -10 = lib.AutotoolsPackage.extraEnv & (if isLlvm then { LIBCC_LDFLAGS = ["--rtlib=compiler-rt"] } else {}),
      #configureFlags | priority -10 = (lib.AutotoolsPackage.configureFlags @ ["--disable-shared"])
      extraConfigureFlags = ["--enable-static", "--disable-shared", "--disable-shared"],
    },

  muslStage0 = _muslBase & { stage = 0 },

  muslStage1 =
    _muslBase
    & {
      stage = 1,

      buildInputs =
        lib.biMap [
          pkgs.busyboxStage0,
          pkgs.llvmStage0,
          pkgs.gnumakeStage1,
          pkgs.ccacheBin,
          pkgs.muslStage0
        ]
    },

  muslStage2 =
    _muslBase
    & {
      stage = 2,

      buildInputs =
        lib.biMap [
          pkgs.busyboxStage1,
          pkgs.llvmStage1,
          pkgs.gnumakeStage2,
          pkgs.ccacheBin,
          pkgs.muslStage1
        ]
    },

  musl =
    _muslBase
    & {
      stage = -1,

      buildInputs =
        lib.biMap [
          pkgs.busyboxStage2,
          pkgs.llvmStage2,
          pkgs.gnumakeStage3,
          pkgs.ccacheBin,
          pkgs.muslStage2
        ]
    },
  muslShared =
    musl
    & {
      name = "musl-shared",
      extraConfigureFlags | priority 1 = ["--disable-static", "--enable-shared"],
    }
}
