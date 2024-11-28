{
  lib,

  drvs,

  libxml2 | lib.MesonPackage
    = {
      singleSource = {
        uri = "https://gitlab.gnome.org/GNOME/libxml2/-/archive/v2.13.4/libxml2-v2.13.4.tar.gz",
        sha256sum = "832f8c4c652f813c9d0a01adcaf86145b77c64e56c71ed85db8071aa78beb98f"
      },
      biDrvs = [
        drvs.git,
      ],
      extraMesonArgs = [
        "-Dpython=true",
      ]
    }
}
& {
  lib,
  drvs,
  libxml2,
  libxml2Dynamic | lib.AutomakePackage
    = {
      singleSource = libxml2.singleSource,
      isStatic = false,
      buildEnv = {
        _isStatic = false
      },
      # pythonProvider = drvs.pythonDynamic,
      separateBuildDir = false,
      biDrvs = [
        drvs.muslShared,
        drvs.git,
        drvs.zstd,
        drvs.zlibNgPic,
        drvs.pythonDynamic,
      ],

      extraConfigureFlags = [
        "--with-python=/usr/bin/python",

        #"--prefer-static",
        #"-Ddefault_library=static",
      ]
    }
}
