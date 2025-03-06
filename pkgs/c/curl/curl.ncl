{
  lib,
  drvs,
  curl | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://curl.se/download/curl-8.10.1.tar.gz",
      sha256sum = "d15ebab765d793e2e96db090f0e172d127859d78ca6f6391d7eafecfd894bbc0",
    },
    biDrvs = [
      drvs.openssl,
      drvs.libpsl,
      drvs.perl,
      drvs.zlibNg,
      drvs.caCertificates,
    ],
    extraConfigureFlags = [
      "--with-openssl",
      "--with-ca-fallback",
      "--with-ca-path=/etc/ssl/certs",
      "--with-ca-bundle=/etc/ssl/cert.pem",

      #
      #
      # https://github.com/kiss-community/repo/blob/master/core/curl/build
      "--enable-ipv6",
      "-enable-unix-sockets",
    ]
  }
}
