{
  lib,

  ############
  _linuxHeadersBase | lib.MakePackage = {
    baseName = "linux-headers",
    makeTargets | priority -10 = ["headers"],
    options = {
      version = "6.13.8"
      # version = "6.10"
    },
    sourceInputs = [
      {
        src = {
          uri = "https://mirrors.edge.kernel.org/pub/linux/kernel/v6.x/linux-%{options.version}.tar.gz",
          sha256sum = "a9f61a4db3e3f2d73129b99ef371686ac096e7ac6c40b81a9d60dda9527fe570",
        },
      },
    ],
    buildDir = "/tmp/workdir/src",
    separateBuildDir = false,
    buildEnv,
    # configurePhase | priority 1
    #   = [
    #     "cd %{buildDir}",
    #     "make " ++ (std.string.join " " makeArgs) ++ " defconfig",
    #     "echo 'defconfig done'",
    #   ],
    makeArgs =
      [
        "LLVM=1",
        "HOSTLDFLAGS=%{ lib.functions.varToExportvar buildEnv.LDFLAGS} \\\n",
        "HOSTCFLAGS=%{ lib.functions.varToExportvar  buildEnv.CFLAGS} \\\n",
      ]
      @ lib.MakePackage.makeArgs,

    installPhase = [
      "install -d -m0755 ${DEST}/usr",
      "cp -r ./usr/include ${DEST}/usr",
    ]
  },
  ############
  muslStage0,
  linuxHeadersStage0 =
    _linuxHeadersBase
    & {
      isLlvm = false,
      buildEnv | force = {},
      makeArgs | force = ["PREFIX=/usr"],
      stage = 0,
      buildInputs =
        lib.biMap [
          muslStage0
        ]
    },

  ############
  busyboxBootstrapStage0,
  bootstrapStage0,
  bootstrapSymlinks,
  gnumakeStage1,
  ccacheBin,
  linuxHeadersStage1 =
    _linuxHeadersBase
    & {
      stage = 1,

      buildEnv = {
        _isLlvm = false,
        STAGE_CFLAGS = [
          "-I/include"
        ],
        STAGE_CPPFLAGS = [
          "-I/include"
        ],
      },
      makeArgs | force =
        [
          "HOSTLDFLAGS=%{ lib.functions.varToExportvar buildEnv.LDFLAGS} \\\n",
          "HOSTCFLAGS=%{ lib.functions.varToExportvar  buildEnv.CFLAGS} \\\n",
        ]
        @ lib.MakePackage.makeArgs,

      buildInputs =
        lib.biMap [
          busyboxBootstrapStage0,
          bootstrapStage0,
          bootstrapSymlinks,
          gnumakeStage1,
          ccacheBin,
          # m4Stage1,
          # flexStage1,
          # bisonStage1,
        ]
    },
  busyboxStage1,
  llvmStage1,
  muslStage2,
  gnumakeStage2,

  linuxHeadersStage2 =
    _linuxHeadersBase
    & {
      stage | force = 2,
      buildInputs =
        lib.biMap [
          busyboxStage1,
          llvmStage1,
          muslStage2,
          gnumakeStage2,
          ccacheBin,
          # m4Stage2,
          # flexStage2,
          # bisonStage2,
        ]
    },

  busyboxStage2,
  llvmStage2,
  muslStage3,
  gnumakeStage4,
  linuxHeadersStage3 =
    _linuxHeadersBase
    & {
      stage = -1,
      buildInputs =
        lib.biMap [
          busyboxStage2,
          llvmStage2,
          muslStage3,
          gnumakeStage4,
          ccacheBin,
          # m4,
          # flex,
          # bison,
        ]
    },

  #final
  busyboxStage3,
  llvmStage3,
  musl,
  gnumake,
  linuxHeaders =
    _linuxHeadersBase
    & {
      stage = -1,
      buildInputs =
        lib.biMap [
          busyboxStage3,
          llvmStage3,
          musl,
          gnumake,
          ccacheBin,
          # m4,
          # flex,
          # bison,
        ]
    },

  linuxHeadersAarch64 =
    linuxHeaders
    & {
      makeArgs | priority 1 = ["ARCH=arm64"] @ linuxHeaders.makeArgs,
      buildEnv.TARGET = "aarch64-unknown-linux-musl",
    }
}
