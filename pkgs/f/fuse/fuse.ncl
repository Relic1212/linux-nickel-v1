{
  lib,

  drvs,
  fuse | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/libfuse/libfuse/archive/refs/tags/fuse-3.18.3.tar.gz",
      sha256sum = "a26f46edc8db4e2cbf1b46d36d3e18ea208871671e56434d9ceb8f7887a690d2",
    },
    extraMesonArgs = [
      "-Dexamples=false",
      "-Duseroot=false",
    ],
    biDrvs = [
      drvs.linuxHeaders,
    ],
  }
}
