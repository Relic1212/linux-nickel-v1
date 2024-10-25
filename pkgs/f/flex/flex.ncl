{
  lib,
  pkgs,
  ## base
  _flexBase | lib.AutotoolsPackage
    = {
      buildEnv = (lib.AutotoolsPackage.buildEnv & { LD | default = "lld" }),

      baseName | priority -10 = "flex",
      sourceInputs = [
        {
          src = {
            uri = "https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz",
            sha256sum = "e87aae032bf07c26f85ac0ed3250998c37621d95f8bd748b31f15b33c45ee995"
          }
        }
      ],
      buildDir = "${SRC}"
    },
  ##

  flexStage1 | lib.AutotoolsPackage
    =
      _flexBase
      & {
        stage = 1,
        buildInputs =
          lib.biMap [
            pkgs.llvmStage0,
            pkgs.muslStage1,
            pkgs.gnumakeStage1,
            pkgs.ccacheBin,
            pkgs.m4Stage1,
            pkgs.busyboxStage0,
          ]
      },

  #2

  flexStage2 | lib.AutotoolsPackage
    =
      _flexBase
      & {
        stage = 2,
        buildInputs =
          lib.biMap [
            pkgs.llvmStage1,
            pkgs.muslStage2,
            pkgs.gnumakeStage2,
            pkgs.ccacheBin,
            pkgs.m4Stage2,
            pkgs.busyboxStage1,
          ]
      },
  #final

  flex | lib.AutotoolsPackage
    =
      _flexBase
      & {
        stage = -1,
        buildInputs =
          lib.biMap [
            pkgs.llvmStage2,
            pkgs.musl,
            pkgs.gnumake,
            pkgs.ccacheBin,
            pkgs.m4,
            pkgs.busyboxStage2,
          ]
      }
}
