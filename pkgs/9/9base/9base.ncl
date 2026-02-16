{
  lib,
  drvs,
  "9base" | lib.MakePackage = {
    singleSource = {
      uri = "git://git.suckless.org/9base",
      sha256sum = "63916da7bd6d73d9a405ce83fc4ca34845667cce"
    },
    buildEnv = {
      EXTRA_CFLAGS = [
        "-I./lib9",
        "-isystem./lib9",
        "-I.",
        "-isystem.",
        # "--verbose",
      ]
    },
    enableParallel = false,
    extraMakeArgs = [
      "CC=\"${CC} -c\"",
      "CFLAGS=\"${CFLAGS}\"",
      "LDFLAGS=\"${LDFLAGS}\"",
      "V=1",
      # "CPPFLAGS=\"{CPPFLAGS}\"",
      "-j1",
    ],
    extraMakeInstallArgs = [
      "PREFIX=/usr"
    ],
    biDrvs = [
      drvs.linuxHeaders,
    ]
  }
}