{
  lib,
  drvs,
  perlClassXsaccessor | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/tsee/Class-XSAccessor/archive/refs/tags/Class-XSAccessor-1.19_01.tar.gz",
      sha256sum = "541f3b5e22ae73633d07665d72770859a35544ddb344b51c7f725fa820da9f5b",
    },
    isStatic = false,
    buildEnv._isStatic = false,
    buildEnv.PKG_CONFIG = null,
    preConfigurePhase = [
      "perl Makefile.PL"
    ],
    biDrvs = [
      drvs.perlDynamic,
      drvs.muslShared,
    ],
  }
}
