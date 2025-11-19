let s = {
  # uri = "https://github.com/AvengeMedia/danklinux/archive/refs/tags/v0.2.2.tar.gz",
  # sha256sum = "ce8f339b8dbe3774bfa397d5e0007f14776b0c0efd09b8d1d845157f75c33dbf",

  # uri = "https://github.com/AvengeMedia/danklinux/archive/3c468ff5332748aa84852a05bdabcf703d956f7c.tar.gz",
  # sha256sum = "6ec725aaa93f5b8442fdeef8a139617aa408a648eafc89db3337f6277c915919",

  # uri = "https://github.com/AvengeMedia/danklinux/archive/refs/tags/v0.4.1.tar.gz",
  # sha256sum = "ff2d9c426651945e3444b9ec65b7c4212ca5c8523efdbd88f1ae5c1de67d6bff",

  uri = "https://github.com/AvengeMedia/DankMaterialShell/archive/refs/tags/v0.5.2.tar.gz",
  sha256sum = "fbee73ece21b037a187e310f0c39eba4a4d3b08d29213b3a430cb07482030cd9",
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
      "export GOMODCACHE=${SRC}/core/go-mod",
      "export CGO_ENABLED=1",
      "mkdir /tmp/home",
      "export HOME=/tmp/home",
    ],
    buildPhase = [
      "cd core",
      "go mod vendor -v",
      m%"find . -print0 | xargs -0r touch --no-dereference --date="@1302044400""%,
      "tar --sort=name -cf - . > ${BUILDDIR}/%{outputFile}",
    ],
    installPhase = [
      "install -m0755 ${BUILDDIR}/%{outputFile} ${DEST}/%{outputFile}"
    ],
    outputFile = "source.tar",
    # outputSha256sum = "81acc3aae11a61be8c19b4bed9d8f478798bd74e5615929598f7328d02ceef22",
    # outputSha256sum = "295aa1a69c07a42227c660b9906ea20f2a95db03a615664bcc518015ef8d6116",

    outputSha256sum = "ea86c62610cf63ae559997939eb3d130c4f0065f34361c2d8724619f25347491",

    biDrvs = [
      drvs.go_1_24,
      drvs.emptyResolvConf,
      drvs.caCertificates,
      (drvs.gnutar & { priority = 1 }),
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
