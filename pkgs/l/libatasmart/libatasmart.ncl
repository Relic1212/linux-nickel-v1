{
  lib,
  drvs,
  libatasmart | lib.AutotoolsPackage = {
    singleSource = {
      # uri = "https://0pointer.de/public/libatasmart-0.19.tar.xz",
      uri = "https://web.archive.org/web/20240518094635/https://0pointer.de/public/libatasmart-0.19.tar.xz",
      sha256sum = "61f0ea345f63d28ab2ff0dc352c22271661b66bf09642db3a4049ac9dbdb0f8d"
    },
    biDrvs = [
      drvs.gperf,
      drvs.kmod,
      drvs.zlibNg,
      drvs.xz,
      drvs.openssl,
      drvs.zstd,
      drvs.utilLinux,
      drvs.linuxHeaders,
      drvs.eudev,
      drvs.pkgconf
    ],
  }
}
