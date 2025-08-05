{
  lib,
  drvs,
  liboil | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://liboil.freedesktop.org/download/liboil-0.3.17.tar.gz",
      sha256sum = "105f02079b0b50034c759db34b473ecb5704ffa20a5486b60a8b7698128bfc69"
    },
    buildEnv = {
      EXTRA_CFLAGS = [
        "-fheinous-gnu-extensions",
      ]
    }
  }
}
