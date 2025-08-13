{
  lib,
  findutils | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://ftp.gnu.org/gnu/findutils/findutils-4.9.0.tar.xz",
      sha256sum = "a2bfb8c09d436770edc59f50fa483e785b161a3b7b9d547573cb08065fd462fe",
    },
  }
}
