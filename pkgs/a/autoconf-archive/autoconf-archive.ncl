{
  lib,
  drvs,
  autoconfArchive | lib.AutotoolsPackage = {
    singleSource = {
      # uri = "https://github.com/autoconf-archive/autoconf-archive/archive/refs/tags/v2023.02.20.tar.gz",
      # sha256sum = "9143c2b02e16efd20093e6e947a7bdaeac71302638214d516a0c2ca383b6bca7",

      uri = "https://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2024.10.16.tar.xz",
      sha256sum = "7bcd5d001916f3a50ed7436f4f700e3d2b1bade3ed803219c592d62502a57363"
    },
  }
}
