{
  lib,
  drvs,
  texinfo | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://ftp.gnu.org/gnu/texinfo/texinfo-7.2.tar.xz",
      sha256sum = "0329d7788fbef113fa82cb80889ca197a344ce0df7646fe000974c5d714363a6"
    },
    biDrvs = [
      drvs.perl,
    ],
  }
}
