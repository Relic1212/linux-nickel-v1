{
  lib,
  drvs,
  strace | lib.AutotoolsPackage = {
    buildEnv,
    singleSource = {
      uri = "https://strace.io/files/7.0/strace-7.0.tar.xz",
      sha256sum = "6c92419be3f2ec560b31728a4652217c59864c8642ba7b1b3771b1b013ad074b",
    },
    extraConfigureFlags = [
      "--enable-mpers=no"
    ],
    biDrvs = [
      drvs.linuxHeaders,
    ],
    extraEnv = {
      CFLAGS_FOR_BUILD = buildEnv.STATIC_CFLAGS,
      LDFLAGS_FOR_BUILD = buildEnv.STATIC_LDFLAGS,
    },
    # separateBuildDir = false,
  }
}
