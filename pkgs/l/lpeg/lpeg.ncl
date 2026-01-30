{
  lib,
  drvs,
  lpeg | lib.MakePackage = {
    # generator = "Ninja",
    singleSource = {
      # uri = "https://github.com/OneLuaPro/LPeg/archive/4190cdb9f4ae1f82a1013950b41a699e5847761a.tar.gz",
      # sha256sum = "6b99d4cfa0e40f1246da5f51e6c417f9e1b3a1f32cc50192180188660c12817d",
      uri = "https://www.inf.puc-rio.br/~roberto/lpeg/lpeg-1.1.0.tar.gz",
      sha256sum = "4b155d67d2246c1ffa7ad7bc466c1ea899bbc40fef0257cc9c03cecbaed4352a",
    },
    extraMakeArgs = [
      "CC=clang",
    ],
    makeTargets = ["lpvm.o", "lpcap.o", "lptree.o", "lpcode.o", "lpprint.o", "lpcset.o"],

    preInstallPhase = [
      "${AR} rcs lpeg.a %{ std.string.join " " makeTargets }",
      "ranlib lpeg.a",
    ],

    installPhase = [
      "install -dm0755 ${DEST}/usr/lib",
      "install -m0755 lpeg.a ${DEST}/usr/lib",
    ],

    biDrvs = [
      drvs.lua,
    ],
  }
}
