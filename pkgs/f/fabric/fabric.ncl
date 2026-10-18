{
  lib,
  drvs,
  fabric | lib.SetuptoolPackage = {
    singleSource = {
      uri = "https://github.com/Fabric-Development/fabric/archive/refs/tags/v0.0.2.tar.gz",
      sha256sum = "83e521fc68a51c9cbeefbdb1965eec42ceca4033fa5d7aea90db9ae1c4f608dd"
    },
    sourceInputs = [
      {
        src = singleSource,
      },
      {
        src = {
          uri = "https://github.com/Fabric-Development/fabric/commit/f54a3d182f87549c9a7fdf41de11e173a493c7d8.patch",
          sha256sum = "471a69c5db10022cd38664102fbcc763a2634b04bdce13f33e7107ffbea01617",
        }
      }
    ],

    preConfigurePhase = [
      "(cd ${SRC} && patch -p1 < f54a3d182f87549c9a7fdf41de11e173a493c7d8.patch)",
    ],
    biDrvs = [
      drvs.gnupatch & { priority = 1 },
    ],
  }
}
