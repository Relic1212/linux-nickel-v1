{
  lib,

  git,

  libxml2 | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.gnome.org/GNOME/libxml2/-/archive/v2.13.4/libxml2-v2.13.4.tar.gz",
      sha256sum = "832f8c4c652f813c9d0a01adcaf86145b77c64e56c71ed85db8071aa78beb98f"
    },
    biDrvs =
      lib.biMap [
        git,
      ],
    extraMesonArgs = [
      "-Dpython=true",
    ]
  }
}
& {
  lib,
  muslShared,
  git,
  zstd,
  zlibNgPic,
  xz,
  pythonDynamic,

  libxml2,
  libxml2Dynamic | lib.MesonPackage = {
    singleSource = libxml2.singleSource,
    isStatic = false,
    buildEnv = {
      _isStatic = false
    },
    pythonProvider = lib.singleBiMap pythonDynamic,
    # separateBuildDir = false,
    biDrvs =
      lib.biMap [
        muslShared,
        git,
        zstd,
        zlibNgPic,
        xz,
        # pythonDynamic,
      ],

    extraMesonArgs = [
      # "--with-python=/usr/bin/python",

      #"--prefer-static",
      #"-Ddefault_library=static",
      "-Dlegacy=true",
      "-Dzlib=enabled",
      "-Dlzma=enabled",
      "-Dtls=true",
      "-Dthreads=enabled",
      "-Dpython=true",
      "-Dmodules=enabled",
    ]
  }
}
