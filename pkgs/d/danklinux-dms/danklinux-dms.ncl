let s = {
  uri = "https://github.com/AvengeMedia/danklinux/archive/refs/tags/v0.1.14.tar.gz",
  sha256sum = "5c01673ea1007cf8e22423f63517c4816bd9f176054c7fadf998f0b67d6fc7a9"
}
in

{
  lib,
  drvs,
  danklinuxDmsSource | lib.DeterministicFetcher = {
    singleSource = s,
    separateBuildDir = false,
    configurePhase = [
      "export GOROOT=/usr/lib/go",
      "export GOMODCACHE=${SRC}/go-mod",
      "export CGO_ENABLED=1",
      "mkdir /tmp/home",
      "export HOME=/tmp/home",
    ],
    buildPhase = [
      "go mod vendor -v",
      m%"find . -print0 | xargs -0r touch --no-dereference --date="@1302044400""%,
      "tar cf - . > ../build/%{outputFile}",
    ],
    installPhase = [
      "install -m0755 ../build/%{outputFile} ${DEST}/%{outputFile}"
    ],
    outputFile = "source.tar",
    outputSha256sum = "0c6009af3b5a7a628f918dd3f237823c43693e73efd6af8cf149330605316941",

    biDrvs = [
      drvs.go_1_24,
      drvs.emptyResolvConf,
      drvs.caCertificates,
    ]
  },
  danklinuxDms | lib.Package = {

    separateBuildDir = false,
    configurePhase = [
      "export GOROOT=/usr/lib/go",
      "export GOMODCACHE=${SRC}/go-mod",
      #   "export CGO_ENABLED=1",
      "mkdir /tmp/home",
      "export HOME=/tmp/home",
    ],

    buildPhase = [
      "tar xf /source.tar",
      "cd cmd/dms",
      #   "go build -trimpath -ldflags \"-s -w -X main.Version=0.0.5\"",
      m%"go build -ldflags "-linkmode 'external' -extldflags '-static'" "%,
    ],

    installPhase = [
      "install -dm0755 ${DEST}/usr/bin",
      "(cd ${SRC}/cmd/dms && install -m0755 dms ${DEST}/usr/bin)",
    ],

    enableCcache = false,
    biDrvs = [
      drvs.danklinuxDmsSource,
      drvs.go_1_24,
      drvs.llvm,
      drvs.musl,
      drvs.emptyResolvConf,
      drvs.caCertificates,
    ]
  }
}
