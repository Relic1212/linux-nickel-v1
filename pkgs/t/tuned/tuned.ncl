{
  lib,
  drvs,
  tuned | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/redhat-performance/tuned/archive/refs/tags/v2.24.1.tar.gz",
      sha256sum = "7029f113158a6ec2e1ad3c2084b1d3c5858cbc220daad6c5d90c784bd493a37f"
    },
    biDrvs = [
      drvs.pythonFull,
      drvs.desktopFileUtils,
    ],
    preConfigurePhase = [
      m%"
            for file in $(find "${SRC}" -type f); do
                sed -i 's@\/sbin@\/bin@g' "${file}"
            done
            "%
    ]
  }
}
