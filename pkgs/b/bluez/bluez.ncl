{
  lib,
  drvs,
  bluez | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://www.kernel.org/pub/linux/bluetooth/bluez-5.86.tar.xz",
      sha256sum = "99f144540c6070591e4c53bcb977eb42664c62b7b36cb35a29cf72ded339621d"
    },
    biDrvs = [
      drvs.linuxHeaders,
      drvs.pkgconf,
      drvs.gperf,
      drvs.libical,
      drvs.pythonFull,
      drvs.docutils,
    ],
    pDrvs = [
      drvs.glib,
      drvs.readline,
      drvs.eudev,
      drvs.dbus,
      drvs.alsaLibs,
    ],
    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lreadline",
        "-lncursesw"
      ]
    },
    extraEnv = {
      LIBS = buildEnv.EXTRA_LDFLAGS,
    },
    extraConfigureFlags = [
      "--enable-obex",
      "--disable-systemd",
      "--disable-cups",
      "--enable-manpages",
      "--enable-library",
      "--enable-deprecated",
    ],
    preConfigurePhase = [
      # m%"sed -i 's@MAX_INPUT@_POSIX_MAX_INPUT@g' ${SRC}/src/shared/util.c"%,
      m%"sed -i 's@MAX_INPUT@_POSIX_MAX_INPUT@g' ${SRC}/gdbus/object.c"%,
    ],
    preBuildPhase = [
      "sed -i 's@ -lreadline@ -lreadline -lncursesw@g' Makefile"
    ]
  }
}
& {
  lib,
  drvs,
  blueAlsa | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/arkq/bluez-alsa/archive/refs/tags/v4.3.1.tar.gz",
      sha256sum = "933fe898dfac21fdfeb5f4ffa685c2aa2db9c064d639170ac2652f156e956a2a",
      #uri ="https://github.com/arkq/bluez-alsa/archive/e77b82b9495abdc23ca4f983c284a494fb454719.zip",
      #sha256sum = "1",
    },
    biDrvs = [
      drvs.bluez,
      drvs.alsaLibs,
      drvs.dbus,
      drvs.glib,
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.sbc,
      drvs.libsndfile,
      drvs.linuxHeaders,
      drvs.pythonFull,
      drvs.readline,
      drvs.ncurses,
    ],
    extraConfigureFlags = [
      "--enable-cli"
    ]
  }
}
