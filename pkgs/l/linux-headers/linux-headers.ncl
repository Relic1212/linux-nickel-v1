{
  lib,
  pkgs,
  ############
  _linuxHeadersBase | lib.MakePackage = {
    baseName = "linux-headers",
    makeTargets | priority -10 = ["headers"],
    options ={
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
  linuxHeadersStage0 =
    _linuxHeadersBase
    & {
      isLlvm = false,
      buildEnv | force = {},
      makeArgs | force = ["PREFIX=/usr"],
      stage = 0,
      buildInputs =
        lib.biMap [
          pkgs.muslStage0
        ]
    },

  ############

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
          pkgs.busyboxBootstrapStage0,
          pkgs.bootstrapStage0,
          pkgs.bootstrapSymlinks,
          pkgs.gnumakeStage1,
          pkgs.ccacheBin,
          # pkgs.m4Stage1,
          # pkgs.flexStage1,
          # pkgs.bisonStage1,
        ]
    },

  linuxHeadersStage2 =
    _linuxHeadersBase
    & {
      stage | force = 2,
      buildInputs =
        lib.biMap [
          pkgs.busyboxStage1,
          pkgs.llvmStage1,
          pkgs.muslStage2,
          pkgs.gnumakeStage2,
          pkgs.ccacheBin,
          # pkgs.m4Stage2,
          # pkgs.flexStage2,
          # pkgs.bisonStage2,
        ]
    },

  linuxHeadersStage3 =
    _linuxHeadersBase
    & {
      stage = -1,
      buildInputs =
        lib.biMap [
          pkgs.busyboxStage2,
          pkgs.llvmStage2,
          pkgs.muslStage3,
          pkgs.gnumakeStage4,
          pkgs.ccacheBin,
          # pkgs.m4,
          # pkgs.flex,
          # pkgs.bison,
        ]
    },

  #final

  linuxHeaders =
    _linuxHeadersBase
    & {
      stage = -1,
      buildInputs =
        lib.biMap [
          pkgs.busyboxStage3,
          pkgs.llvmStage3,
          pkgs.musl,
          pkgs.gnumake,
          pkgs.ccacheBin,
          # pkgs.m4,
          # pkgs.flex,
          # pkgs.bison,
        ]
    },

  linuxHeadersAarch64 =
    linuxHeaders
    & {
      makeArgs | priority 1 = ["ARCH=arm64"] @ linuxHeaders.makeArgs,
      buildEnv.TARGET = "aarch64-unknown-linux-musl",
    }
}
