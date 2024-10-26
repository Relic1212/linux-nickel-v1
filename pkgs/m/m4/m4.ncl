{
  lib,
  pkgs,
  # base
  _m4Base | lib.AutotoolsPackage
    = {
      baseName = "m4",
      buildEnv = (lib.AutotoolsPackage.buildEnv & { LD = "lld" }),
      sourceInputs = [
        {
          src = {
            uri = "https://ftp.gnu.org/gnu/m4/m4-1.4.19.tar.xz",
            sha256sum = "63aede5c6d33b6d9b13511cd0be2cac046f2e70fd0a07aa9573a04a82783af96"
          }
        }
      ],
      # buildDir = "${SRC}",
    },
  ##

  m4Stage1 =
    _m4Base
    & {
      stage = 1,
      buildInputs =
        lib.biMap [
          pkgs.busyboxStage0,
          pkgs.llvmStage0,
          pkgs.muslStage1,
          pkgs.gnumakeStage1,
          pkgs.ccacheBin,
        ]
    },

  #2

  m4Stage2 =
    _m4Base
    & {
      stage = 2,
      buildInputs =
        lib.biMap [
          pkgs.busyboxStage1,
          pkgs.llvmStage1,
          pkgs.muslStage2,
          pkgs.gnumakeStage2,
          pkgs.ccacheBin,
        ]
    },

  #final

  m4 =
    _m4Base
    & {
      stage = -1,
      buildInputs =
        lib.biMap [
          pkgs.busyboxStage2,
          pkgs.llvmStage2,
          pkgs.musl,
          pkgs.gnumake,
          pkgs.ccacheBin,
        ]
    },
}
