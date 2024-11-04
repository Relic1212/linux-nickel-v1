{
  lib,
  drvs,
  libxo | lib.AutomakePackage
    = {
      singleSource = {
        uri = "https://github.com/Juniper/libxo/releases/download/1.7.5/libxo-1.7.5.tar.gz",
        sha256sum = "d12249ffad3ef04b160e6419adf1bbe7e593a60bb23f0a0a077fa780b214934a",
      },
      biDrvs = [
        drvs.linuxHeaders,
        drvs.libbsd,
        drvs.libmd,
      ],
      preConfigurePhase = [
        "mkdir -p bsd/sys",
        "cp /usr/include/bsd/sys/queue.h bsd/sys/",
      ],
      buildEnv = {
        EXTRA_CFLAGS = [
          "-I/tmp/workdir/build/bsd/"
        ],
        EXTRA_CXXFLAGS = [
          "-I/tmp/workdir/build/bsd/"
        ]
      }
    }
}
