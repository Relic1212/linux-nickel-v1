{
  lib,
  drvs,
  libxmlplusplus5 | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/libxmlplusplus/libxmlplusplus/archive/refs/tags/5.4.0.tar.gz",
      sha256sum = "89d21b931d2ee5ee44d9a76579c60b0fbe0e2c6c7776ebefd6a2dcd567893f56"
    },
    extraMesonArgs = [
      "-Dbuild-examples=false",
      "-Dbuild-tests=false",
    ],
    biDrvs = [
      drvs.libxml2DynamicCmake,
    ]
  }
}
& {
  lib,
  drvs,
  libxmlplusplus | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://download.gnome.org/sources/libxml++/2.40/libxml%2B%2B-2.40.1.tar.xz",
      sha256sum = "4ad4abdd3258874f61c2e2a41d08e9930677976d303653cd1670d3e9f35463e9"
    },
    buildEnv = {
      # https://stackoverflow.com/questions/69116001/how-do-i-re-enable-c17-removed-features-in-clang
      CXX = [
        "clang++",
        "-std=c++17",
        "-D_HAS_AUTO_PTR_ETC=1",
        "-D_LIBCPP_ENABLE_CXX17_REMOVED_AUTO_PTR",
      ]
    },

    biDrvs = [
      drvs.pkgconfMeson,
      drvs.libxml2Cmake,
      drvs.perl,
    ],
    pDrvs = [
      drvs.glibmm,
      # drvs.libsigcpp2,
    ],
  }
}
& {
  lib,
  drvs,
  libxmlplusplus26 | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://download.gnome.org/sources/libxml++/2.6/libxml%2B%2B-2.6.1.tar.bz2",
      sha256sum = "461b924966f1ca54623b90b47d84061331e546960d47b410c87410ba9b025782"
    },

    buildEnv = {
      EXTRA_CPPFLAGS = ["-I/usr/include/libxml2", ],
      EXTRA_CXXFLAGS = ["-std=c++14", ],
    },

    biDrvs = [
      drvs.pkgconfMeson,
      drvs.libxml2,
    ],
    pDrvs = [
      drvs.glibmm,
      # drvs.libsigcpp2,
    ],
  }
}
