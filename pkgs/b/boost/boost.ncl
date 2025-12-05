{
  lib,
  drvs,
  boost | lib.AutotoolsPackage = {
    # generator = "Ninja",
    singleSource = {
      uri = "https://archives.boost.io/release/1.87.0/source/boost_1_87_0.tar.gz",
      sha256sum = "f55c340aa49763b1925ccf02b2e83f35fdcf634c9d5164a2acb87540173c741d"
    },
    configureScript = "${SRC}/bootstrap.sh",
    configureFlags = [
      "--prefix=/usr",
    ],
    separateBuildDir = false,

    buildPhase = [
      #"./b2"

      # https://github.com/alpinelinux/aports/blob/master/main/boost1.84/APKBUILD
      "./b2 --prefix=${DEST}/usr link=static toolset=clang --layout=system --without-graph_parallel --without-mpi",
    ],

    installPhase = [
      "echo INSTALLING",
      "./b2 --prefix=${DEST}/usr link=static toolset=clang --layout=system --without-graph_parallel --without-mpi --includedir=${DEST}/usr/include --libdir=${DEST}/usr/lib install",
    ],
    biDrvs = [
      drvs.pythonFull,
      drvs.muslShared,
      drvs.linuxHeaders,
      drvs.bzip2,
      drvs.zlibNg,
      drvs.zstd,
      drvs.xz,
    ],
    buildEnv = {
      CC = ["clang", "-static", "--static"],
      CXX = ["clang++", "-static", "--static"],
    },
    extraEnv = {
      B2_CXXFLAGS = buildEnv.CXXFLAGS,
      B2_CXX = buildEnv.CXX,
      # B2_VERBOSE_OPT = "0",
    },
  }
}
