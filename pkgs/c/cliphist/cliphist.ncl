{
  lib,
  drvs,
  cliphist | lib.MakePackage = {
    sourceInputs = [
      {
        src = {
          uri = "https://github.com/sentriz/cliphist/archive/refs/tags/v0.6.1.tar.gz",
          sha256sum = "db0f25ba3e9173dcb257d66cb1293e277a8bdfed11cc8d6b38b7473b0947781d"
        }
      },
      {
        src = {
          uri = "https://slackware.lngn.net/pub/source/cliphist/cliphist-vendor-0.6.1.tar.xz",
          sha256sum = "29b05beb0e1802c7a37bd15e70b48f807f281183aa9633de7eeda0a66a53da4e"
        },
        dest = "vendor"
      }
    ],

    configurePhase = [
      # "cd ${SRC}",
      "export GOROOT=/usr/lib/go",
      "export GOMODCACHE=${SRC}/vendor",
      "export CGO_ENABLED=0",
      "mkdir /tmp/home",
      "export HOME=/tmp/home",
    ],

    # from https://github.com/sentriz/cliphist/blob/master/.github/workflows/upload-binaries.yaml
    buildPhase = [
      m%"go build -a -ldflags '-extldflags "-static"' -o cliphist"%
    ],
    installPhase = [
      "install -d -m0755 ${DEST}/usr/bin",
      "install -m0755 cliphist ${DEST}/usr/bin",
    ],

    biDrvs = [
      drvs.go_1_24,
    ]
  }
}
