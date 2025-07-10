{
  lib,
  go_1_4,
  bash,

  go_1_9 | lib.Package = {
    singleSource = {
      uri = "http://golang.org/dl/go1.19.5.src.tar.gz",
      sha256sum = "8e486e8e85a281fc5ce3f0bedc5b9d2dbf6276d7db0b25d3ec034f313da0375f",
    },
    configurePhase = [
      "export CC=\"${CC} -static --static \"",
      "export DESTDIR=${DEST}",
      "cd ${SRC}",
      "cd src",
      "export GOROOT_FINAL=/usr/lib/go",
      "cp -r /usr/lib/go /tmp/go",
      "export GOROOT_BOOTSTRAP=/tmp/go",
      "env CGO_ENABLED=0 ./make.bash",
      "cd ..",
    ],
    installPhase = [
      "install -d -m 0755 ${DEST}/usr",
      "install -d -m 0755 ${DEST}/usr/bin",
      "install -d -m 0755 ${DEST}/usr/lib/go",
      "install  -m 0755 ${SRC}/bin/* ${DEST}/usr/bin/",
      "cp -r ${SRC}/* ${DEST}/usr/lib/go",
    ],
    biDrvs =
      lib.biMap [
        go_1_4,
        bash,
      ]
  }
}
