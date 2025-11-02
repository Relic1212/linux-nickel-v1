{
  lib,

  jsonC | lib.CmakePackage = {
    name = "json-c",
    singleSource = {
      # uri = "https://s3.amazonaws.com/json-c_releases/releases/json-c-0.18.tar.gz",
      # sha256sum = "876ab046479166b869afc6896d288183bbc0e5843f141200c677b3e8dfb11724",

      uri = "https://github.com/json-c/json-c/archive/refs/tags/json-c-0.18-20240915.tar.gz",
      sha256sum = "3112c1f25d39eca661fe3fc663431e130cc6e2f900c081738317fba49d29e298",
    },

    cmakeExtraArgsRecord = {
      "-DCMAKE_POLICY_VERSION_MINIMUM" = "3.5"
    },

    generator = "Ninja",
    buildEnv.EXTRA_CFLAGS = ["-Wno-error=unused-command-line-argument"],
    buildEnv.EXTRA_LDFLAGS = ["-Wno-error=unused-command-line-argument"],
    buildEnv.EXTRA_CXXFLAGS = ["-Wno-error=unused-command-line-argument"],
  }
}
