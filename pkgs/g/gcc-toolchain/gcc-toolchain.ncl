{
  lib,
  _binutils | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://ftp.gnu.org/gnu/binutils/binutils-2.43.tar.xz",
      sha256sum = "b53606f443ac8f01d1d5fc9c39497f2af322d99e14cea5c0b4b124d630379365",
    },
    separateBuildDir = false,
  },
  binutils = _binutils,
}
