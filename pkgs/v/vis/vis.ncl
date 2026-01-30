{
  lib,
  drvs,
  vis | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://github.com/martanne/vis/archive/refs/tags/v0.9.tar.gz",
      sha256sum = "bd37ffba5535e665c1e883c25ba5f4e3307569b6d392c60f3c7d5dedd2efcfca"
    },
    biDrvs = [
      drvs.libtermkey,
      drvs.lua,
      drvs.ncurses,
      drvs.pkgconf,
    ],
    separateBuildDir = false,
    # configurePhase=[
    #     "./configure"
    # ],
  }
}
& {
  lib,
  drvs,
  libtickit | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/leonerd/libtickit/archive/refs/tags/v0.4.3.tar.gz",
      sha256sum = "ad654fcb5ff95609148f4745fbdf16d95119b94f132d8885e91809fd83e15526",
    },
    biDrvs = [
      drvs.pkgconf,
      drvs.m4,
      drvs.libtool,
      drvs.bison,
    ]
  }
}
& {
  lib,
  drvs,
  libtermkey | lib.MakePackage = {
    singleSource = {
      uri = "https://www.leonerd.org.uk/code/libtermkey/libtermkey-0.22.tar.gz",
      sha256sum = "6945bd3c4aaa83da83d80a045c5563da4edd7d0374c62c0d35aec09eb3014600"
    },
    biDrvs = [
      drvs.pkgconf,
      drvs.m4,
      drvs.libtool,
      drvs.bison,
      drvs.ncurses,
    ],
    extraMakeInstallArgs = [
      "PREFIX=/usr",
    ]
  }
}
