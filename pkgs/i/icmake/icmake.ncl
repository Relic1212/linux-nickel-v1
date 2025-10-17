{
  lib,
  drvs,
  icmake | lib.MakePackage = {
    singleSource = {
      # uri = "https://gitlab.com/fbb-git/icmake/-/archive/13.04.00/icmake-13.04.00.tar.gz",
      # sha256sum = "f5cb28cb50acc23e129bb8f510dbcdc9884d77b3849df3f6ed716ff77983bb1d",

      uri = "https://gitlab.com/fbb-git/icmake/-/archive/9.03.01/icmake-9.03.01.tar.gz",
      sha256sum = "7c5c091f58f576da580238c5e3636e2038d9ecf5efb6562ae7e402910d9036e6",
    },
    buildPhase = [
      "cd icmake",
      m%"for f in $(find . -type f); do sed -i 's|#!\/bin\/bash|#!\/usr\/bin\/bash|g' $f;done"%,
      # "./prepare ${DEST}",
      # "./buildlib ${DEST}",
      # "./build all",
      "./icm_prepare /",
      "./icm_bootstrap /",
    ],
    installPhase = [
      "DESTDIR=${DEST} ./icm_install all ${DEST}",
    ],
    biDrvs = [
      drvs.bash,
      drvs.flex,
      drvs.bison,
    ]
  }
}
