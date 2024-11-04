{
  lib,
  drvs,
  syslogNg | lib.AutotoolsPackage
    = {
      singleSource = {
        uri = "https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-4.8.1/syslog-ng-4.8.1.tar.gz",
        sha256sum = "e8b8b98c60a5b68b25e3462c4104c35d05b975e6778d38d8a81b8ff7c0e64c5b",
      },
      # generator="Ninja",
      biDrvs = [
        drvs.bison,
        drvs.jsonC,
        drvs.glib,
        drvs.pcre2,
        drvs.openssl,
        drvs.flex,
        drvs.libnet,
        drvs.m4,
        drvs.libtool,
        drvs.pkgconf,
        drvs.linuxHeaders,
        drvs.ivykis,
      ],
      # cmakeArgsRecord={
      #     "-DBUILD_TESTING"="OFF",
      # },
      extraConfigureFlags = [
        "--disable-geoip2",
        "--disable-java",
        "--disable-java-modules",
        "--disable-linux-caps",
        "--disable-mongodb",
        "--disable-python-modules",
        "--disable-riemann",
        "--disable-smtp",
        "--disable-systemd",
        "--disable-stomp",
        "--disable-geoip",
        "--disable-python",
        "--enable-cpp",
        "--disable-amqp",
        "--with-ivykis=system",
      ]
    },
}
