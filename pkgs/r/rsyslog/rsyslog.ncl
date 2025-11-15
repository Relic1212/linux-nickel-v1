{
  lib,
  drvs,
  rsyslog | lib.AutomakePackage = {
    singleSource = {
      # uri = "https://github.com/rsyslog/rsyslog/archive/refs/tags/v8.2410.0.tar.gz",
      # sha256sum = "0e4e6fcb1d72a1cb65438d85dd2bbf37a8f82115d7e271788535d1e7fbcf6838",

      uri = "https://github.com/rsyslog/rsyslog/archive/refs/tags/v8.2510.0.tar.gz",
      sha256sum = "ccc65a73e43318debbd011c05c7e0f2eac9bd8bf556d44aa4f5ee5cebac903cf",
    },
    separateBuildDir = false,

    extraConfigureFlags = [
      "--enable-regexp",
      # "--disable-fmhash",
      "--disable-klog",
      "--disable-uuid",
      "--disable-gnutls-tests",
      "--disable-fmhttp",
      "--disable-default-tests",
      "--disable-helgrind",
      "--disable-imfile-tests",
      "--disable-libgcrypt",
      "--disable-inet",
      "--enable-kafka-static",
      "--enable-qpidproton_static",
      "--disable-rsyslogrt",
      "--enable-liblogging-stdlog",
    ],

    biDrvs = [
      drvs.libestr,
      drvs.libfastjson,
      drvs.zlibNg,
      drvs.bison,
      drvs.flex,
      drvs.liblogging,
    ],
  }
}
