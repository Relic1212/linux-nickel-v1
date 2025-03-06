{
  lib,
  drvs,
  kbd | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://mirrors.edge.kernel.org/pub/linux/utils/kbd/kbd-2.6.4.tar.gz",
      sha256sum = "99b2a39e1c5475ffe8e1bb2004345cb8849c3cc1aedbe541beee2d45e270975f",
    },
    biDrvs = [
      drvs.libpam,
      drvs.linuxHeaders,
    ],
    extraConfigureFlags = [
      "--disable-tests",
      "--disable-nls",
    ],
    #installPhase = [
    #  "mkdir destdir",
    #  "make DESTDIR=$(realpath ./destdir) install",
    #  "install -d -m 0755 ${DEST}/usr/bin",
    #  "install -m 0755 ./destdir/usr/bin/loadkeys ${DEST}/usr/bin",
    #  "cp -r ./destdir/usr/share ${DEST}/usr/",
    #],
  }
}
