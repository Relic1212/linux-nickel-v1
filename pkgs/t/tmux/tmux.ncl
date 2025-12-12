{
  lib,
  drvs,
  tmux | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/tmux/tmux/archive/refs/tags/3.6a.tar.gz",
      sha256sum = "cd8d97f344cd2faa89e41358428b3ada883e4c72fd7d4f43ccac93daec1442eb"
    },
    biDrvs = [
      drvs.libevent,
      drvs.ncurses,
      drvs.openssl,
      drvs.bison,
      drvs.flex,
    ]
  }
}
