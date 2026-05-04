{
  lib,
  drvs,
  _plasma_sources,
  layerShellQt | lib.QtPackage = {
    name,
    singleSource =
      let version = "6.6.4" in
      {
        uri = "https://download.kde.org/stable/plasma/%{version}/%{name}-%{version}.tar.xz",
        # uri = "https://download.kde.org/stable/plasma/6.4.5/%{name}-6.4.5.tar.xz",
        sha256sum = _plasma_sources."%{uri}",
      },

    buildEnv = {
      EXTRA_LDFLAGS = [
        "$(pkg-config --libs --static gio-2.0 fontconfig)",
      ],
    },
    preConfigurePhase = [
      "sed -i 's| SHARED | STATIC |g' ${SRC}/src/CMakeLists.txt",
    ],
    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.ecm,
    ],
    pDrvs = [
      drvs.qtwayland,
    ]
  }
}
