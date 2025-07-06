{
  lib,
  pythonFull,

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
    buildPhase = [
      "./b2"
    ],
    biDrvs =
      lib.biMap [
        pythonFull,
      ],
    buildEnv = {
      CC = ["clang", "-static", "--static"],
      CXX = ["clang++", "-static", "--static"],
    },
    extraEnv = {
      B2_CXXFLAGS = buildEnv.CXXFLAGS,
      B2_CXX = buildEnv.CXX,
    },
  }
}
