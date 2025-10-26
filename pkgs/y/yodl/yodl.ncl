{
  lib,
  drvs,
  yodl | lib.MakePackage = {
    singleSource = {
      # uri = "https://gitlab.com/fbb-git/yodl/-/archive/4.05.01/yodl-4.05.01.tar.gz",
      # sha256sum = "602d1d2a9ee1917adfd408c4c81e1a11e867275d59f15da171471306ca3f9baf",

      uri = "https://gitlab.com/fbb-git/yodl/-/archive/4.03.03/yodl-4.03.03.tar.gz",
      sha256sum = "f765e80b468bbf88647bbf157a7668be0bff6ded40d8733e1ade352e1e7b3343",
    },
    buildPhase = [
      "export HOME=/tmp",
      "export TERM=dumb",
      "cd yodl",
      m%"for f in $(find . -type f); do sed -i 's|#!\/bin\/bash|#!\/usr\/bin\/bash|g' $f;done"%,
      "sed -i 's|gcc|clang|g' INSTALL.im",
      "sed -i 's|g++|clang++|g' INSTALL.im",
      "./build programs",
    ],
    installPhase = [
      # "./build install ${DEST}"
    ],
    biDrvs = [
      drvs.icmake,
      drvs.bash,
      drvs.ncurses2,
      drvs.bison,
      drvs.flex,
      drvs.perl,
    ]
  }
}
