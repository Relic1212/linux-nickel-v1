{
  # See this for inspiration:
  # https://github.com/alpinelinux/aports/tree/330d303d57c584df80b7ec5ebe459b7f61132055/main/go

  lib,
  drvs,
  varTmpDirectory | lib.Package = {
    name = "var-tmp-directory",

    installPhase = [
      "install -d -m 0755 ${DEST}/var",
      "install -d -m 0755 ${DEST}/tmp",
      "cd ${DEST}/var",
      "ln -s /tmp tmp"
    ]
  },

  go_1_4 | lib.Package = {

    name = go_1_4,

    singleSource = {
      uri = "http://golang.org/dl/go1.4.2.src.tar.gz",
      sha256sum = "299a6fd8f8adfdce15bc06bde926e7b252ae8e24dd5b16b7d8791ed79e7b5e9b",
    },
    buildEnv,
    # extraEnv={
    #     GO_LDFLAGS=buildEnv.LDFLAGS,
    #     GO_CCFLAGS=buildEnv.CFLAGS,
    # },
    configurePhase = [
      "export CC=\"${CC} -static --static \"",
      "cd ${SRC}",
      m%"sed -i 's@"-Werror",@@g' src/cmd/dist/build.c"%,
      "cd src",
      "export GOROOT_FINAL=/usr/lib/go",
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
      drvs.musl,
      drvs.llvm,
      drvs.gnumake,
      drvs.ccacheBin,
      drvs.varTmpDirectory,
      drvs.bash,
    ],
  }
}
