{
  lib,
  linuxHeaders,
  file,

  keyutils | lib.MakePackage = {
    singleSource = {
      uri = "https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/keyutils.git/snapshot/keyutils-1.6.3.tar.gz",
      sha256sum = "a61d5706136ae4c05bd48f86186bcfdbd88dd8bd5107e3e195c924cfc1b39bb4"
    },
    biDrvs =
      lib.biMap [
        linuxHeaders,
        file,
      ],
    buildEnv = {
      EXTRA_CFLAGS = ["-Wall"],
      EXTRA_CXXFLAGS = ["-Wall"],
    },
    extraMakeArgs = [
      "CFLAGS=\"${CFLAGS}\"",
      "CXXFLAGS=\"${CXXFLAGS}\"",
      # "LDFLAGS=\"${LDFLAGS}\"",
      "BINDIR=/usr/bin",
      "SBINDIR=/usr/bin",
      "LIBDIR=/usr/lib",
      "USRLIBDIR=/usr/lib",
      "NO_SOLIB=1",
      "DEVELLIB=libkeyutils.a",
    ],
    extraMakeInstallArgs = extraMakeArgs,
  }
}
