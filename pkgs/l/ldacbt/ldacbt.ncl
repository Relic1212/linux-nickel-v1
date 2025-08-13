{
  lib,
  drvs,
  ldacbt | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/EHfive/ldacBT/archive/refs/tags/v2.0.2.3.tar.gz",
      sha256sum = "c02998718f9c4620437d7594b4d121b3ab4c5cfeba8d41fa31dd5c71db09edca"
    },
    sourceInputs = [
      {
        src = singleSource
      },
      {
        src = {
          uri = "https://gitlab.com/eh5/libldac/-/archive/82b6a1abee84787b8fa167efe20290073f60db2d/libldac-82b6a1abee84787b8fa167efe20290073f60db2d.tar.gz",
          sha256sum = "d61edcd3bfc4b71123136895fe71e7ba974f4a91f16a158f0ec8d5eb1913c51a"
        },
        dest = "libldac"
      }
    ],
    preConfigurePhase = [
      "sed -i 's@ SHARED@@g' ${SRC}/CMakeLists.txt"
    ],
    cmakeExtraArgsRecord = {
      "-DLDAC_SOFT_FLOAT" = "OFF"
    }
  }
}
