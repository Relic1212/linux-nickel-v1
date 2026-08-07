{
  lib,
  drvs,
  nspr | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://ftp.mozilla.org/pub/nspr/releases/v4.39/src/nspr-4.39.tar.gz",
      sha256sum = "bbd02ee87a55676063a63e5bc819e0227de2666b47307b2a0134414cdf42368e",
    },
    configureScript = "${SRC}/nspr/configure",
    extraConfigureFlags = [
      "--enable-64bit",
      "--disable-x32",
    ],
    postInstallPhase = [
      "llvm-objcopy --redefine-sym=poll=nspr_poll ${DEST}/usr/lib/libnspr4.a",
    ],
  }
}
