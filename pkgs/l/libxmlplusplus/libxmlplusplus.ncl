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
      drvs.linuxHeaders,
      drvs.pkgconf,
      # drvs.libxml2DynamicCmake,
      drvs.libxml2Cmake,
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.glib,
      drvs.libsigcpp2,
      drvs.glibmm,
      drvs.perl,
    ]
  }
}
