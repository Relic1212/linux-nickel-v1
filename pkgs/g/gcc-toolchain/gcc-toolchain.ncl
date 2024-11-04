{
  lib,
  _binutils | lib.AutotoolsPackage
    = {
      singleSource = {
        uri = "https://ftp.gnu.org/gnu/binutils/binutils-2.43.tar.xz",
        sha256sum = "1",
      },
    }
}
