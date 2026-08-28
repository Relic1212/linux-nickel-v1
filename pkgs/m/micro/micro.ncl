{
  lib,
  drvs,

  microSource | lib.DeterministicFetcher = {
    singleSource = micro.singleSource,
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
      "tar --sort=name -cf  - . > ../build/%{outputFile}",
    ],
    installPhase = [
      "install -m0755 ../build/%{outputFile} ${DEST}/%{outputFile}"
    ],
    outputFile = "source.tar",

    outputSha256sum = "b276f1fd06fcca22a5ac4e105568b62ce0efcfb506ded5b546c5bde9df38bc62",

    biDrvs = [
      drvs.go_1_9,
      drvs.emptyResolvConf,
      drvs.caCertificates,
      (drvs.gnutar & { priority = 1 })
    ]
  },

  micro | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/zyedidia/micro/archive/refs/tags/v2.0.14.tar.gz",
      sha256sum = "40177579beb3846461036387b649c629395584a4bbe970f61ba7591bd9c0185a"
    },
    sourceInputs = [],
    configurePhase = [
      # "cd ${SRC}",
      "export GOROOT=/usr/lib/go",
      "export GOMODCACHE=${SRC}/go-mod",
      "export CGO_ENABLED=0",
      "mkdir /tmp/home",
      "export HOME=/tmp/home",
      "tar xf /source.tar",
      "export GOOS=linux",
      "export GOARCH=amd64",
    ],
    installPhase = [
      "install -dm0755 ${DEST}/usr/bin",
      "install -m0755 micro ${DEST}/usr/bin",
    ],

    biDrvs = [
      drvs.go_1_9,
      drvs.findutils,
      # drvs.libpam161,
      drvs.libpam,
      drvs.microSource,
    ]
  }
}
