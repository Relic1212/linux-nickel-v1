{
  lib,
  busyboxStage2,
  llvmStage2,
  gnumakeStage3,
  ccacheBin,
  muslStage2,

  _muslBase | lib.AutotoolsPackage = {
    stage,
    isLlvm = (stage != 0),
    baseName = "musl",
    isStatic = false,

    sourceInputs = [
      {
        src = { uri = "https://musl.libc.org/releases/musl-1.2.5.tar.gz", sha256sum = "a9a118bbe84d8764da0ea0d28b3ab3fae8477fc7e4085d90102b8596fc7c75e4" }
      }
    ],
    patches = [
      {
        file = "CVE-2025-26519-1.patch",
        sha256sum = "0896fcdb5125d9d0723f4e165f13c209830e7045a75cba4e858060837cb7292e"
      },
      {
        file = "CVE-2025-26519-2.patch",
        sha256sum = "0620fcee4e8a4e52ebe1ea75e2b51d2197ebda242489c0586924eafa9e9606a1",
      },
    ],
    extraEnv | priority -10 = lib.AutotoolsPackage.extraEnv & (if isLlvm then { LIBCC_LDFLAGS = ["--rtlib=compiler-rt"] } else {}),
    #configureFlags | priority -10 = (lib.AutotoolsPackage.configureFlags @ ["--disable-shared"])
    extraConfigureFlags = ["--enable-static", "--disable-shared"],
  },

  muslStage0 = _muslBase & { stage = 0 },
  busyboxBootstrapStage0,
  bootstrapSymlinks,
  bootstrapStage0,
  gnumakeStage1,
  ccacheBin,
  muslStage1 | lib.AutotoolsPackage =
    _muslBase
    & {
      stage = 1,
      isLlvm | force = false,
      buildEnv = {
        _isLlvm | force = false,
      },

      buildInputs =
        lib.biMap [
          busyboxBootstrapStage0,
          bootstrapSymlinks,
          bootstrapStage0,
          gnumakeStage1,
          ccacheBin,
        ]
    },
  busyboxStage1,
  llvmStage1,
  gnumakeStage2,
  ccacheBin,
  muslStage1,
  muslStage2 =
    _muslBase
    & {
      stage = 2,

      buildInputs =
        lib.biMap [
          busyboxStage1,
          llvmStage1,
          gnumakeStage2,
          ccacheBin,
          muslStage1,
        ]
    },

  muslStage3 | lib.AutotoolsPackage =
    _muslBase
    & {
      stage = -1,

      utilsProviders = lib.biMap [],
      baseBuildinputPackages = lib.biMap [],
      biDrvs =
        lib.biMap [
          busyboxStage2,
          llvmStage2,
          gnumakeStage3,
          ccacheBin,
          muslStage2
        ]
    },

  busyboxStage3,
  llvmStage3,
  gnumakeStage4,
  ccacheBin,
  muslStage3,
  musl | lib.AutotoolsPackage =
    _muslBase
    & {
      stage = -1,

      utilsProviders = lib.biMap [],
      baseBuildinputPackages = lib.biMap [],
      biDrvs =
        lib.biMap [
          busyboxStage3,
          llvmStage3,
          gnumakeStage4,
          ccacheBin,
          muslStage3,
        ]
    },
  muslShared =
    musl
    & {
      name = "musl-shared",
      extraConfigureFlags | priority 1 = ["--disable-static", "--enable-shared"],
    },

  busybox,
  clangCross,
  gnumake,
  muslAarch64 =
    musl
    & {
      extraConfigureFlags | priority 1 =
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

      biDrvs | priority 1 =
        lib.biMap [
          busybox,
          clangCross,
          gnumake,
          ccacheBin,
          # muslStage2
        ],
    }
}
