{
  lib,

  jsonC | lib.CmakePackage
    = {
      name = "json-c",
      singleSource = {
        uri = "https://s3.amazonaws.com/json-c_releases/releases/json-c-0.18.tar.gz",
        sha256sum = "876ab046479166b869afc6896d288183bbc0e5843f141200c677b3e8dfb11724",
      },

      generator = "Ninja",
      buildEnv.CFLAGS = lib.CmakePackage.buildEnv.CFLAGS @ ["-Wno-error=unused-command-line-argument"],
      buildEnv.LDFLAGS = lib.CmakePackage.buildEnv.LDFLAGS @ ["-Wno-error=unused-command-line-argument"],
      buildEnv.CXXFLAGS = lib.CmakePackage.buildEnv.CXXFLAGS @ ["-Wno-error=unused-command-line-argument"],
    }
}
