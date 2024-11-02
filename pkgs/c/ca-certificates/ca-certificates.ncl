{
  lib,
  caCertificates | lib.Package
    = {
      singleSource = {
        uri = "https://curl.se/ca/cacert-2024-09-24.pem",
        sha256sum = "189d3cf6d103185fba06d76c1af915263c6d42225481a1759e853b33ac857540",
      },
      installPhase = [
        "install -d -m0755 ${DEST}/etc/ssl",
        "install -m 0755 ${SRC}/cacert*.pem ${DEST}/etc/ssl/cert.pem",
      ]
    }
}
