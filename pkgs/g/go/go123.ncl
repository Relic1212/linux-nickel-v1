{
  lib,
  drvs,
  go_1_23 | lib.Package = {
    singleSource = {
      uri = "https://go.dev/dl/go1.23.3.src.tar.gz",
      sha256sum = "8d6a77332487557c6afa2421131b50f83db4ae3c579c3bc72e670ee1f6968599",
    },
    configurePhase = [
      "export HOME=/tmp",
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
    biDrvs = [
      drvs.go_1_21,
      drvs.bash,
    ]
  }
}
& {
  lib,
  drvs,
  go_1_22 | lib.Package = {
    singleSource = {
      uri = "https://go.dev/dl/go1.22.9.src.tar.gz",
      sha256sum = "e81a362f51aee2125722b018e46714e6a055a1954283414c0f937e737013db22",
    },
    configurePhase = [
      "export HOME=/tmp",
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
    biDrvs = [
      drvs.go_1_9,
      drvs.bash,
    ]
  }
}
& {
  lib,
  drvs,
  go_1_21 | lib.Package = {
    singleSource = {
      uri = "https://go.dev/dl/go1.21.13.src.tar.gz",
      sha256sum = "71fb31606a1de48d129d591e8717a63e0c5565ffba09a24ea9f899a13214c34d",
    },
    configurePhase = [
      "export HOME=/tmp",
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
    biDrvs = [
      drvs.go_1_9,
      drvs.bash,
    ]
  }
}
