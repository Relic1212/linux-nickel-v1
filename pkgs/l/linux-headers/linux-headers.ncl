{
  lib,
  pkgs,
  ############
  _linuxHeadersBase | lib.MakePackage
    = {
      baseName = "linux-headers",
      makeTargets | priority -10 = ["headers"],
      sourceInputs = [
        {
          src = {
            uri = "https://mirrors.edge.kernel.org/pub/linux/kernel/v6.x/linux-6.10.tar.gz",
            sha256sum = "37041701dab67f8e1bd699d728fec07d6098abd147b366f0c7ad1a3fb1b58619",
          },
        },
      ],
      buildDir = "/tmp/workdir/src",

      buildEnv,
      configurePhase | priority 1
        = [
          "cd %{buildDir}",
          "make " ++ (std.string.join " " makeArgs) ++ " defconfig",
          "echo 'defconfig done'",
        ],
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
      stage = 0,
      buildInputs =
        lib.biMap [
          muslStage0
        ]
    },

  ############

  linuxHeadersStage1 =
    _linuxHeadersBase
    & {
      stage = 1,
      buildInputs =
        lib.biMap [
          pkgs.busyboxStage0,
          pkgs.llvmStage0,
          pkgs.muslStage1,
          pkgs.gnumakeStage1,
          pkgs.ccacheBin,
          pkgs.m4Stage1,
          pkgs.flexStage1,
          pkgs.bisonStage1,
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
          pkgs.m4Stage2,
          pkgs.flexStage2,
          pkgs.bisonStage2,
        ]
    },

  #final

  linuxHeaders =
    _linuxHeadersBase
    & {
      stage = -1,
      buildInputs =
        lib.biMap [
          pkgs.busyboxStage2,
          pkgs.llvmStage2,
          pkgs.musl,
          pkgs.gnumake,
          pkgs.ccacheBin,
          pkgs.m4,
          pkgs.flex,
          pkgs.bison,
        ]
    },
  linuxHeadersAarch64 =
    linuxHeaders
    & {
      makeArgs | priority 1 = ["ARCH=arm64"] @ linuxHeaders.makeArgs,
      buildEnv.TARGET = "aarch64-unknown-linux-musl",
    }
}
