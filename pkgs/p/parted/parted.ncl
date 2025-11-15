{
  lib,
  drvs,
  parted | lib.AutotoolsPackage = {
    singleSource = {
      uri = "http://ftp.klid.dk/ftp/gnu/parted/parted-3.6.tar.xz",
      sha256sum = "3b43dbe33cca0f9a18601ebab56b7852b128ec1a3df3a9b30ccde5e73359e612"
    },
    buildEnv = {
      EXTRA_CPPFLAGS = [
        "-DUUID_STR_LEN=37"
      ]
    },

    biDrvs = [
      drvs.linuxHeaders,
      drvs.e2fsprogs,
      drvs.ncurses,
      drvs.utilLinux & { priority = 1 },
      drvs.lvm2,
      drvs.readline,
    ]
  }
}
