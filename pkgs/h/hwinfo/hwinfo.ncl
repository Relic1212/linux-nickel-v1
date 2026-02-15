{
  lib,
  drvs,
  hwinfo | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/openSUSE/hwinfo/archive/refs/tags/25.2.tar.gz",
      sha256sum = "2d188e1deca6a17162c208470ba5287891f2e6537a9d107b46d860fea6e39e27",
    },
    patches = [
      {
        sha256sum = "4890e9f487b45889768420d8287217c2e960a1d3df3bb61b2415fbf075feec7f",
        file = "hwinfo-staticlib.patch",
      },
    ],
    enableParallel = false,
    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lx86emu",
        "$(pkg-config --libs --static uuid)",
      ],
    },
    preConfigurePhase = [
      "echo 25.2 > VERSION",
      "rm ./git2log",
      "sed -i 's|sbin|bin|g' Makefile",
    ],
    preInstallPhase = [
      # static lib is only installed if this doesn't exist
      "echo 'removing stuff'",
      "rm -v /tmp/workdir/src/src/libhd.so.25.2",
      "rm -v src/libhd.so*",
    ],
    extraMakeArgs = [
      "LIBDIR=/usr/lib",
    ],
    extraMakeInstallArgs = extraMakeArgs,
    biDrvs = [
      drvs.linuxHeaders,
      drvs.utilLinux,
      drvs.perl,
      drvs.libx86emu,
      drvs.flex,
      drvs.flexLex,
      drvs.m4,
      drvs.bison,
      drvs.pkgconfMeson,
    ],
  }
}
