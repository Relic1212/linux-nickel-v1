{
  lib,
  drvs,
  nspr | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://ftp.mozilla.org/pub/nspr/releases/v4.39/src/nspr-4.39.tar.gz",
      sha256sum = "bbd02ee87a55676063a63e5bc819e0227de2666b47307b2a0134414cdf42368e",
      # uri = "https://ftp.mozilla.org/pub/nspr/releases/v4.40/src/nspr-4.40.tar.gz",
      # sha256sum = "c0c1884c627f3db7a783f7c7314c695226b2043696791d15519e7e0578c19bdc",
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
