{
  lib,
  drvs,
  j4MenuDesktop | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/enkore/j4-dmenu-desktop/archive/refs/tags/r3.1.tar.gz",
      sha256sum = "0e6cf25663cc220e3e3e2bc013fe957c3e4a44f900b5ee6a7609cd501021652d"
    },
    biDrvs = [
      drvs.fmt,
      drvs.spdlog,
      drvs.catch2,
      drvs.crazyComplete,
    ]
  }
}
& {
  lib,
  drvs,
  spdlog | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/gabime/spdlog/archive/refs/tags/v1.15.1.tar.gz",
      sha256sum = "25c843860f039a1600f232c6eb9e01e6627f7d030a2ae5e232bdd3c9205d26cc"
    },
    cmakeArgsRecord = {
      "-DSPDLOG_FMT_EXTERNAL" = true,
    },
    biDrvs = [
      drvs.fmt,
    ]
  }
}
& {
  lib,
  drvs,
  catch2 | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/catchorg/Catch2/archive/refs/tags/v3.8.0.tar.gz",
      sha256sum = "1ab2de20460d4641553addfdfe6acd4109d871d5531f8f519a52ea4926303087"
    },
    extraMesonArgs = [
      "-Dtests=false"
    ],
  }
}
& {
  lib,
  drvs,

  crazyComplete | lib.SetuptoolPackage = {
    singleSource = {
      uri = "https://github.com/crazy-complete/crazy-complete/archive/refs/tags/0.3.2.tar.gz",
      sha256sum = "99ae5b7bcb281d901516e4dc10f3dfa4d82cb4f02cdb80baa3dcef402c1e4653"
    }
  }
}
