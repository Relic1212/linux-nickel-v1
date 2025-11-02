{
  lib,
  drvs,
  linux,
  ############
  _linuxHeadersBase | lib.MakePackage = {
    baseName = "linux-headers",
    makeTargets | priority -10 = ["headers"],
    options = {
      # version = "6.10"

      # version = "6.13.8"
      version = "6.17.6"
    },
    sourceInputs = [
      {
        src = linux.singleSource,
        # {
        #   uri = "https://mirrors.edge.kernel.org/pub/linux/kernel/v6.x/linux-%{options.version}.tar.gz",
        #   sha256sum = "a9f61a4db3e3f2d73129b99ef371686ac096e7ac6c40b81a9d60dda9527fe570",
        # },
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
      buildInputs = [
        drvs.muslStage0
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

      buildInputs = [
        drvs.busyboxBootstrapStage0,
        drvs.bootstrapStage0,
        drvs.bootstrapSymlinks,
        drvs.gnumakeStage1,
        drvs.ccacheBin,
        # drvs.m4Stage1,
        # drvs.flexStage1,
        # drvs.bisonStage1,
      ]
    },

  linuxHeadersStage2 =
    _linuxHeadersBase
    & {
      stage | force = 2,
      buildInputs = [
        drvs.busyboxStage1,
        drvs.llvmStage1,
        drvs.muslStage2,
        drvs.gnumakeStage2,
        drvs.ccacheBin,
        # drvs.m4Stage2,
        # drvs.flexStage2,
        # drvs.bisonStage2,
      ]
    },

  linuxHeadersStage3 =
    _linuxHeadersBase
    & {
      stage = -1,
      buildInputs = [
        drvs.busyboxStage2,
        drvs.llvmStage2,
        drvs.muslStage3,
        drvs.gnumakeStage4,
        drvs.ccacheBin,
        # drvs.m4,
        # drvs.flex,
        # drvs.bison,
      ]
    },

  #final

  linuxHeaders =
    _linuxHeadersBase
    & {
      stage = -1,
      buildInputs = [
        drvs.busyboxStage3,
        drvs.llvmStage3,
        drvs.musl,
        drvs.gnumake,
        drvs.ccacheBin,
        # drvs.m4,
        # drvs.flex,
        # drvs.bison,
      ]
    },

  linuxHeadersAarch64 =
    linuxHeaders
    & {
      makeArgs | priority 1 = ["ARCH=arm64"] @ linuxHeaders.makeArgs,
      buildEnv.TARGET = "aarch64-unknown-linux-musl",
    }
}
