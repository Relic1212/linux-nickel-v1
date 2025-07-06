{
  lib,
  linuxHeaders,

  strace | lib.AutotoolsPackage = {
    buildEnv,
    singleSource = {
      uri = "https://strace.io/files/6.13/strace-6.13.tar.xz",
      sha256sum = "e209daf0ee038ca5adcc4c277e9273b4d51f46a2ff86da575d36742ac3508a17",
    },
    extraConfigureFlags = [
      "--enable-mpers=no"
    ],
    biDrvs =
      lib.biMap [
        linuxHeaders,
      ],
    extraEnv = {
      CFLAGS_FOR_BUILD = buildEnv.STATIC_CFLAGS,
      LDFLAGS_FOR_BUILD = buildEnv.STATIC_LDFLAGS,
    },
    # separateBuildDir = false,
  }
}
