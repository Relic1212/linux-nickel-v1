{
  lib,
  pkgs,

  _muslBase | lib.AutotoolsPackage
    = {
      stage,
      isLlvm = (stage != 0),
      baseName = "musl",
      isStatic = false,

      sourceInputs = [
        {
          src = { uri = "https://musl.libc.org/releases/musl-1.2.5.tar.gz", sha256sum = "a9a118bbe84d8764da0ea0d28b3ab3fae8477fc7e4085d90102b8596fc7c75e4" }
        }
      ],
      extraEnv | priority -10 = lib.AutotoolsPackage.extraEnv & (if isLlvm then { LIBCC_LDFLAGS = ["--rtlib=compiler-rt"] } else {}),
      #configureFlags | priority -10 = (lib.AutotoolsPackage.configureFlags @ ["--disable-shared"])
      extraConfigureFlags = ["--enable-static", "--disable-shared"],
    },

  muslStage0 = _muslBase & { stage = 0 },

  muslStage1 | lib.AutotoolsPackage
    =
      _muslBase
      & {
        stage = 1,
        isLlvm | force = false,
        buildEnv = {
          _isLlvm | force = false,
        },

        buildInputs =
          lib.biMap [
            pkgs.busyboxBootstrapStage0,
            pkgs.bootstrapSymlinks,
            pkgs.bootstrapStage0,
            pkgs.gnumakeStage1,
            pkgs.ccacheBin,
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

  muslStage3 | lib.AutotoolsPackage
    =
      _muslBase
      & {
        stage = -1,

        utilsProviders = [],
        baseBuildinputPackages = [],
        biDrvs =
          lib.biMap [
            pkgs.busyboxStage2,
            pkgs.llvmStage2,
            pkgs.gnumakeStage3,
            pkgs.ccacheBin,
            pkgs.muslStage2
          ]
      },
  musl | lib.AutotoolsPackage
    =
      _muslBase
      & {
        stage = -1,

        utilsProviders = [],
        baseBuildinputPackages = [],
        biDrvs =
          lib.biMap [
            pkgs.busyboxStage3,
            pkgs.llvmStage3,
            pkgs.gnumakeStage4,
            pkgs.ccacheBin,
            pkgs.muslStage3,
          ]
      },
  muslShared =
    musl
    & {
      name = "musl-shared",
      extraConfigureFlags | priority 1 = ["--disable-static", "--enable-shared"],
    },
  muslAarch64 =
    musl
    & {
      extraConfigureFlags | priority 1
        =
          musl.extraConfigureFlags
          @ [

            # "--target=aarch64-unknown-linux-musl",
            # "--build=x86_64-unknown-linux-gnu",
            "--host=aarch64-unknown-linux-musl"
          ],
      # buildEnv.CPP=["clang","--target=aarch64-unknown-linux-musl", "--sysroot=/aarch64-unknown-linux-musl","-E"],

      extraMakeArgs = [
        "TARGET=aarch64-linux-musl"
      ],
      # buildEnv.EXTRA_CFLAGS=["-target aarch64-unknown-linux-musl"],

      buildEnv.TARGET = "aarch64-unknown-linux-musl",

      biDrvs | priority 1
        =
          lib.biMap [
            pkgs.busybox,
            pkgs.clangCross,
            pkgs.gnumake,
            pkgs.ccacheBin,
            # pkgs.muslStage2
          ],
    }
}
