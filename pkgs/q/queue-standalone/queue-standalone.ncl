{
  lib,
  drvs,
  queueStandalone | lib.Package = {
    singleSource = {
      uri = "https://gitweb.gentoo.org/repo/gentoo.git/plain/sys-libs/queue-standalone/files/queue.h?id=03c401b573029575f6cf59d709a562f719ad50b1",
      sha256sum = "8b284031772b1ba2035d9b05b24f2cb9b23e7bd324bcccb5e3fcc57d34aafa48",
    },

    separateBuildDir = false,
    installPhase = [
      "install -dm0755 ${DEST}/usr/include/sys",
      "install -m0755 queue.h?id=03c401b573029575f6cf59d709a562f719ad50b1 ${DEST}/usr/include/sys/queue.h",
    ]
  }
}
