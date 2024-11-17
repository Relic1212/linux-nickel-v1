{
  lib,
  drvs,
  strace | lib.AutotoolsPackage
    = {
      buildEnv,
      singleSource = {
        uri = "https://strace.io/files/6.11/strace-6.11.tar.xz",
        sha256sum = "83262583a3529f02c3501aa8b8ac772b4cbc03dc934e98bab6e4883626e283a5",
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
