{
  lib,
  drvs,
  qbe | lib.MakePackage = {
    singleSource = {
      uri = "https://c9x.me/compile/release/qbe-1.2.tar.xz",
      sha256sum = "a6d50eb952525a234bf76ba151861f73b7a382ac952d985f2b9af1df5368225d"
    },
    extraMakeArgs = [
      "CC=clang"
    ],
    extraMakeInstallArgs = [
      "PREFIX=/usr"
    ]
  }
}
& {
  lib,
  drvs,
  harec | lib.MakePackage = {
    singleSource = {
      uri = "https://git.sr.ht/~sircmpwn/harec/archive/0.26.0.tar.gz",
      sha256sum = "5581bc16dcf22969c7d33b0f2a9535ba37d4cf1bb39dec252e98ff2781175629"
    },
    biDrvs = [
      drvs.qbe,
    ],
    configurePhase = [
      "cp configs/linux.mk config.mk"
    ],
    extraMakeArgs = [
      "CC=clang",
      "LDFLAGS='-static --static'"
    ],
    extraMakeInstallArgs = [
      "PREFIX=/usr"
    ]
  }
}
& {
  lib,
  drvs,
  hare | lib.MakePackage = {
    singleSource = {
      uri = "https://git.sr.ht/~sircmpwn/hare/archive/0.26.0.tar.gz",
      sha256sum = "525ee699bdbade390eb1e35525ab9b5b3032c5f42cddce49d9176bbdc9172d04"
    },
    # llvmProvider =drvs.llvmFull,
    biDrvs = [
      drvs.qbe,
      drvs.harec,
      drvs.scdoc,
      drvs.binutils,
    ],
    configurePhase = [
      "mkdir /tmp/workdir/build/home",
      "export HOME=/tmp/workdir/build/home",
      "cp configs/linux.mk config.mk"
    ],
    extraMakeArgs = [
      "CC=clang",
      "LDFLAGS='-static --static'",
      # "AS=llvm-as",
      # "AR=llvm-ar",
      #  "LD=lld",
      #  "LDFLAGS=\"$LDFLAGS\"",
      #  "CFLAGS=\"$CFLAGS\"",
    ],
    extraMakeInstallArgs = [
      "PREFIX=/usr",
    ]
  }
}
& {
  lib,
  drvs,
  hareJson | lib.MakePackage = {
    singleSource = {
      uri = "https://git.sr.ht/~sircmpwn/hare-json/archive/0.24.2.tar.gz",
      sha256sum = "3b3087b7abbdf67a87592122335ebfbebf5588314c43330fef11512296e83507"
    },
    biDrvs = [
      drvs.qbe,
      drvs.harec,
      drvs.scdoc,
      drvs.hare,
    ],
    configurePhase = [
      "mkdir /tmp/workdir/build/home",
      "export HOME=/tmp/workdir/build/home",

      #  "cp configs/linux.mk config.mk"
    ],
    extraMakeArgs = [
      "CC=clang",
      "LDFLAGS='-static --static'",
      # "AS=llvm-as",
      # "AR=llvm-ar",
      #  "LD=lld",
      #  "LDFLAGS=\"$LDFLAGS\"",
      #  "CFLAGS=\"$CFLAGS\"",
    ],
    extraMakeInstallArgs = [
      "PREFIX=/usr",
    ]
  }
}
& {
  lib,
  drvs,
  hareEv | lib.MakePackage = {
    singleSource = {
      uri = "https://git.sr.ht/~sircmpwn/hare-ev/archive/0.26.0.0.tar.gz",
      sha256sum = "6be334cdcbd180fd714810e1a86f6c3fabf799973948bd415271dc4a1a2b5a6a",
    },
    isLlvm = false,

    biDrvs = [
      drvs.qbe,
      drvs.harec,
      drvs.scdoc,
      drvs.hare,
      drvs.binutils,
    ],
    configurePhase = [
      "mkdir /tmp/workdir/build/home",
      "export HOME=/tmp/workdir/build/home",

      #  "cp configs/linux.mk config.mk"
    ],
    extraMakeArgs = [
      "CC=clang",
      "LDFLAGS='-static --static'",
      # "AS=llvm-as",
      # "AR=llvm-ar",
      #  "LD=lld",
      #  "LDFLAGS=\"$LDFLAGS\"",
      #  "CFLAGS=\"$CFLAGS\"",
    ],
    extraMakeInstallArgs = [
      "PREFIX=/usr",
    ]
  }
}
