{
  lib,
  ncurses,
  readline,

  less | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://www.greenwoodsoftware.com/less/less-668.tar.gz",
      sha256sum = "2819f55564d86d542abbecafd82ff61e819a3eec967faa36cd3e68f1596a44b8",
    },
    biDrvs =
      lib.biMap [
        ncurses,
        readline,
      ]
  }
}
