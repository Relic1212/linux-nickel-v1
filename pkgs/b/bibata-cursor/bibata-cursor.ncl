{
  lib,
  drvs,
  bibataCursor | lib.Package = {
    singleSource = {
      uri = "https://github.com/ful1e5/Bibata_Cursor/archive/refs/tags/v2.0.7.tar.gz",
      sha256sum = "1f21e5cade53d668476f973bd8ec827882a0e32c38e0e766abf007f8b3b46313"
    },
    biDrvs = [
      drvs.pythonFull,
      drvs.pythonClickgen,
      drvs.pythonToml,
      drvs.pythonAttrs,
      drvs.pyyaml,
      drvs.bash,
    ],
    separateBuildDir = false,
    buildPhase = [
      m%"sed -i 's@\/bin\/bash@\/usr\/bin\/env bash@g' ./build.sh"%,
      "./build.sh",
    ]
  }
}
