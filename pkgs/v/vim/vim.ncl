{
  lib,
  drvs,
  vim | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://www.vim.org/downloads/vim-9.2.tar.bz2",
      sha256sum = "3481983a2b36e71b7f887bf8590e9a4b50c820826c7bedb95155d0ca71fe385d"
    },
    separateBuildDir = false,
    biDrvs = [
      drvs.ncurses,
      drvs.readline,
    ]
  }
}
