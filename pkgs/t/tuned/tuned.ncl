{
  lib,
  drvs,
  tuned | lib.MakePackage = {
    singleSource = {
      # uri = "https://github.com/redhat-performance/tuned/archive/refs/tags/v2.24.1.tar.gz",
      # sha256sum = "7029f113158a6ec2e1ad3c2084b1d3c5858cbc220daad6c5d90c784bd493a37f",
      uri = "https://github.com/redhat-performance/tuned/archive/refs/tags/v2.28.0.tar.gz",
      sha256sum = "e8fa0a3493dec60462a36082c9755c1f38ace89640dea816b0833d48d5df686b",
    },
    biDrvs = [
      drvs.pythonFull,
      drvs.desktopFileUtils,
    ],
    preConfigurePhase = [
      m%"for file in $(find "${SRC}" -type f); do sed -i 's@\/sbin@\/bin@g' "${file}";done"%,
    ]
  }
}
