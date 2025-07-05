{
  lib,
  drvs,
  superd | lib.MakePackage = {
    singleSource = {
      uri = "https://git.sr.ht/~craftyguy/superd/archive/0.7.1.tar.gz",
      sha256sum = "59de58f43bd237c12d0e73425df954eb14dd4e87e11d990e8191aa6921ee08d3"
    },
    configurePhase = [
      # "cd ${SRC}",
      "export GOROOT=/usr/lib/go",
      "export GOMODCACHE=${SRC}/go-mod",
      "export CGO_ENABLED=1",
      "mkdir /tmp/home",
      "export HOME=/tmp/home",
    ],
    biDrvs = [
      drvs.go_1_9,
    ]
  }
}
