{

  lib,
  pkgs,

  #
  automake | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://ftp.gnu.org/gnu/automake/automake-1.17.tar.gz",
      sha256sum = "397767d4db3018dd4440825b60c64258b636eaf6bf99ac8b0897f06c89310acd",
    },
    biDrvs = lib.biMap [pkgs.perl, pkgs.autoconf, pkgs.m4, ]
  }
}
