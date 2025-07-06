{
  lib,
  qbe,

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
  qbe,
  harec | lib.MakePackage = {
    singleSource = {
      uri = "https://git.sr.ht/~sircmpwn/harec/archive/0.24.2.tar.gz",
      sha256sum = "88b3961b236fbfe3a0dfb46bb954741fa5c031bbda6d07fbc238c98f0abb41a2"
    },
    biDrvs =
      lib.biMap [
        qbe,
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
  qbe,
  harec,
  scdoc,
  binutils,

  hare | lib.MakePackage = {
    singleSource = {
      uri = "https://git.sr.ht/~sircmpwn/hare/archive/0.24.2.tar.gz",
      sha256sum = "afba69fd537a63442da53d115d9b50f525918159b395843ede2a5473323e0776"
    },
    # llvmProvider =llvmFull,
    biDrvs =
      lib.biMap [
        qbe,
        harec,
        scdoc,
        binutils,
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
  qbe,
  harec,
  scdoc,
  hare,

  hareJson | lib.MakePackage = {
    singleSource = {
      uri = "https://git.sr.ht/~sircmpwn/hare-json/archive/0.24.2.tar.gz",
      sha256sum = "3b3087b7abbdf67a87592122335ebfbebf5588314c43330fef11512296e83507"
    },
    biDrvs =
      lib.biMap [
        qbe,
        harec,
        scdoc,
        hare,
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
  qbe,
  harec,
  scdoc,
  hare,
  binutils,

  hareEv | lib.MakePackage = {
    singleSource = {
      uri = "https://git.sr.ht/~sircmpwn/hare-ev/archive/7f80dcbeb09f4dd743cdccfb2cfed10bfdeb07ab.tar.gz",
      sha256sum = "1e87369fe4645dc801974fe748beeb40ce23daa7ee2da9f5262783da88ed9d98"
    },
    isLlvm = false,

    biDrvs =
      lib.biMap [
        qbe,
        harec,
        scdoc,
        hare,
        binutils,
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
