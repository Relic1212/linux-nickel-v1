{
  lib,
  drvs,
  gettext | lib.AutotoolsPackage
    = {
      singleSource = {
        uri = "https://ftp.gnu.org/gnu/gettext/gettext-0.22.5.tar.gz",
        sha256sum = "ec1705b1e969b83a9f073144ec806151db88127f5e40fe5a94cb6c8fa48996a0",
      }
    }
}
