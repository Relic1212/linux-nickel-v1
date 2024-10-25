{
  lib,
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

      buildEnv | default = lib.MakePackage.buildEnv,
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

  busyboxStage0,
  llvmStage0,
  muslStage1,
  gnumakeStage1,
  ccacheBin,
  m4Stage1,
  flexStage1,
  bisonStage1,
  linuxHeadersStage1 =
    _linuxHeadersBase
    & {
      stage = 1,
      buildInputs =
        lib.biMap [
          busyboxStage0,
          llvmStage0,
          muslStage1,
          gnumakeStage1,
          ccacheBin,
          m4Stage1,
          flexStage1,
          bisonStage1,
        ]
    },

  busyboxStage1,
  llvmStage1,
  muslStage2,
  gnumakeStage2,
  m4Stage2,
  flexStage2,
  bisonStage2,
  linuxHeadersStage2 =
    _linuxHeadersBase
    & {
      stage = 2,
      buildInputs =
        lib.biMap [
          busyboxStage1,
          llvmStage1,
          muslStage2,
          gnumakeStage2,
          ccacheBin,
          m4Stage2,
          flexStage2,
          bisonStage2,
        ]
    },

  #final
  busyboxStage2,
  llvmStage2,
  musl,
  gnumake,
  m4,
  flex,
  bison,
  linuxHeaders =
    _linuxHeadersBase
    & {
      stage = -1,
      buildInputs =
        lib.biMap [
          busyboxStage2,
          llvmStage2,
          musl,
          gnumake,
          ccacheBin,
          m4,
          flex,
          bison,
        ]
    },
}
