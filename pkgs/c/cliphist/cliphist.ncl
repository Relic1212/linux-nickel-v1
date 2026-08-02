{
  lib,
  drvs,
  cliphist | lib.MakePackage = {
    sourceInputs = [
      {
        src = {
          uri = "https://github.com/sentriz/cliphist/archive/refs/tags/v0.7.0.tar.gz",
          sha256sum = "8d7dc7b4495e5812b5613274c250ba5d3900933d78888ce7921c01247f191cc8"
        }
      },
      {
        src = {
          uri = "https://slackware.lngn.net/pub/source/cliphist/cliphist-vendor-0.7.0.tar.xz",
          sha256sum = "196a7992308b1b3658517c9b0c42494a601707210e98251afe12b49dcb87bbee"
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
