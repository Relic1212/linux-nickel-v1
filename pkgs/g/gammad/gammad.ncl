{
  lib,
  drvs,
  gammad | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/nedimzecic/gammad/archive/refs/tags/v1.0.1.tar.gz",
      sha256sum = "07fe7ef2174a4064057f1fc0bcbe4e5ec554fccafc261cd8be842bf3f262a70c",
    },
    buildEnv = {
      EXTRA_CFLAGS = [
        "-I/usr/include/libdrm",
      ],
      EXTRA_LDFLAGS = [
        "$(pkg-config --libs --static libdrm)",
      ],
    },
    extraMakeArgs = [
      "CC=\"${CC}\"",
      "CFLAGS=\"${CFLAGS}\"",
      "LDFLAGS=\"${LDFLAGS}\"",
    ],

    installPhase = [
      "install -Dm0755 gammad ${DEST}/usr/bin/gammad",
    ],
    biDrvs = [
      drvs.libpciaccess,
      drvs.linuxHeaders,
      drvs.libdrm,
      drvs.pkgconfMeson,
    ],
  }
}
