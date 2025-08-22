{
  lib,

  drvs,

  libxml2 | lib.MesonPackage = {
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
  libxml2Dynamic | lib.MesonPackage = {
    singleSource = libxml2.singleSource,
    isStatic = false,
    buildEnv = {
      _isStatic = false
    },
    llvmProvider = drvs.llvmFull,
    pythonProvider = drvs.pythonDynamic,
    # separateBuildDir = false,
    biDrvs = [
      drvs.muslShared,
      drvs.git,
      drvs.zstd,
      drvs.zlibNgPic,
      drvs.xz,
      # drvs.pythonDynamic,
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
& {
  lib,
  drvs,
  libxml2,
  libxml2DynamicCmake | lib.CmakePackage = {
    singleSource = libxml2.singleSource,
    isStatic = false,
    buildEnv = {
      _isStatic = false
    },
    llvmProvider = drvs.llvmFull,
    generator = "Ninja",
    # separateBuildDir = false,
    biDrvs = [
      drvs.muslShared,
      drvs.git,
      drvs.zstd,
      drvs.zlibNgPic,
      drvs.xz,
      drvs.pythonDynamicPic,
    ],
    cmakeExtraArgsRecord = {
      "-DLIBXML2_WITH_PYTHON" = true,
      "-DBUILD_STATIC_LIBS" = true,
      "-DLIBXML2_PYTHON_INSTALL_DIR" = "/usr/lib/python3.12/",
    }
  }
}
& {
  lib,
  drvs,
  libxml2,
  libxml2Cmake | lib.CmakePackage = {
    singleSource = libxml2.singleSource,

    llvmProvider = drvs.llvmFull,
    generator = "Ninja",
    # separateBuildDir = false,
    biDrvs = [
      drvs.git,
      drvs.zstd,
      drvs.zlibNgPic,
      drvs.xz,
      drvs.pythonFull,
    ],
    # cmakeExtraArgsRecord = {
    # "-DLIBXML2_WITH_PYTHON" = false,
    #   "-DBUILD_STATIC_LIBS" = true,
    #   "-DLIBXML2_PYTHON_INSTALL_DIR" = "/usr/lib/python3.12/",
    # }
  }
}
