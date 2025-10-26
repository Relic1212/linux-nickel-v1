let s = {
  # uri = "https://github.com/AvengeMedia/danklinux/archive/refs/tags/v0.2.2.tar.gz",
  # sha256sum = "ce8f339b8dbe3774bfa397d5e0007f14776b0c0efd09b8d1d845157f75c33dbf",

  uri = "https://github.com/AvengeMedia/danklinux/archive/3c468ff5332748aa84852a05bdabcf703d956f7c.tar.gz",
  sha256sum = "6ec725aaa93f5b8442fdeef8a139617aa408a648eafc89db3337f6277c915919",
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
    # outputSha256sum = "81acc3aae11a61be8c19b4bed9d8f478798bd74e5615929598f7328d02ceef22",
    outputSha256sum = "5b4ab3c3d3ad18e5480a15b02e0491f7ee8df6df3364afb97c33473019f2afed",

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
