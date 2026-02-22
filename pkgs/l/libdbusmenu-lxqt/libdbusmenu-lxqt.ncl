{
  lib,
  drvs,
  libdbusmenuLxqt | lib.LxqtPackage = {
    singleSource = {
      uri = "https://github.com/lxqt/libdbusmenu-lxqt/archive/refs/tags/0.3.0.tar.gz",
      sha256sum = "9b6bd256adf2578bff154d2ef575ffb60eb8245f6fe9bb6edfb23e782e4152ed",
    },
    buildEnv = {
      EXTRA_LDFLAGS = [
        "$(pkg-config --libs --static expat)",
      ],
    },

    preConfigurePhase = [
      m%"sed -i 's|SHARED|STATIC|g' ${SRC}/src/CMakeLists.txt"%,
    ],
    biDrvs = [
      drvs.dbus,
    ]
  }
}
