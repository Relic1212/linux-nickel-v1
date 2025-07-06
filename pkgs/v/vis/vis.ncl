{
  lib,
  libtermkey,
  lua,
  ncurses,
  pkgconf,

  vis | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://github.com/martanne/vis/archive/refs/tags/v0.9.tar.gz",
      sha256sum = "bd37ffba5535e665c1e883c25ba5f4e3307569b6d392c60f3c7d5dedd2efcfca"
    },
    biDrvs =
      lib.biMap [
        libtermkey,
        lua,
        ncurses,
        pkgconf,
      ],
    separateBuildDir = false,
    # configurePhase=[
    #     "./configure"
    # ],
  }
}
& {
  lib,
  pkgconf,
  m4,
  libtool,
  bison,

  libtickit | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/leonerd/libtickit/archive/refs/tags/v0.4.3.tar.gz",
      sha256sum = "ad654fcb5ff95609148f4745fbdf16d95119b94f132d8885e91809fd83e15526",
    },
    biDrvs =
      lib.biMap [
        pkgconf,
        m4,
        libtool,
        bison,
      ]
  }
}
& {
  lib,
  pkgconf,
  m4,
  libtool,
  bison,
  ncurses,

  libtermkey | lib.MakePackage = {
    singleSource = {
      uri = "https://www.leonerd.org.uk/code/libtermkey/libtermkey-0.22.tar.gz",
      sha256sum = "6945bd3c4aaa83da83d80a045c5563da4edd7d0374c62c0d35aec09eb3014600"
    },
    biDrvs =
      lib.biMap [
        pkgconf,
        m4,
        libtool,
        bison,
        ncurses,
      ],
    extraMakeInstallArgs = [
      "PREFIX=/usr",
    ]
  }
}
& {
  lib,

  lua | lib.MakePackage = {
    singleSource = {
      uri = "https://www.lua.org/ftp/lua-5.4.7.tar.gz",
      sha256sum = "9fbf5e28ef86c69858f6d3d34eccc32e911c1a28b4120ff3e84aaa70cfbf1e30",
    },
    extraMakeArgs = [
      "CC=\"${CC}\"",
      "CFLAGS=\"${CFLAGS}\"",
      "LDFLAGS=\"${LDFLAGS}\"",
    ],
    extraMakeInstallArgs = [
      "PREFIX=/usr",
      "INSTALL_TOP=${DEST}/usr",
    ]
  }
}
