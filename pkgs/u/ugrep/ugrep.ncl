{
  lib,
  drvs,
  ugrep | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://github.com/Genivia/ugrep/archive/refs/tags/v7.8.2.tar.gz",
      sha256sum = "f991cc6c61dbc5af5a3b3939083e917df4113509549670fb400d121f639f69f6",
    },
    separateBuildDir = false,
    pDrvs = [
      drvs.pcre2,
      drvs.zlibNg,
      drvs.zstd,
      drvs.bzip2,
      drvs.brotli,
    ]
  }
}
