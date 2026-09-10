let s = {

  uri = "https://github.com/AvengeMedia/DankMaterialShell/archive/refs/tags/v1.6.1.tar.gz",
  sha256sum = "abd50f97df1a4714526089825e5ba4bba2850e5d635f7618511c68a4a6276bbd",
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
      # "cd ..",
      "cd ${SRC}/core/go-mod",
      "chown -R root:root .",
      "chmod -R 755 .",
      m%"find . -print0 | xargs -0r touch --no-dereference --date="@1302044400""%,
      "tar --sort=name -cf - . > ${BUILDDIR}/%{outputFile}",
    ],
    installPhase = [
      "install -m0755 ${BUILDDIR}/%{outputFile} ${DEST}/%{outputFile}"
    ],
    outputFile = "source.tar",

    # outputSha256sum = "9a9436571def018b0e4ca6620ccb814d7476d031d8a8abe3f39ae73f737c4dc2", # "all"
    outputSha256sum = "a22b638e075237d69dd4a598f5cfdd33cbe867dfbae1488ffe436e5b20a14f34", # vendor

    biDrvs = [
      drvs.go_1_26,
      drvs.emptyResolvConf,
      drvs.caCertificates,
      (drvs.gnutar & { priority = 1 }),
      drvs.basefiles,
    ]
  },
  danklinuxDms | lib.MakePackage = {
    sourceInputs = [
      {
        src = s,
      },
      {
        src = {
          uri = "https://github.com/AvengeMedia/dank-qml-common/archive/26396ce432d6c71c3f5367438f96f4a8d667e160.tar.gz",
          sha256sum = "f5aa4d56a937a275c9ee504c567c36c141cb11297cae934f1b5cf3cf3620de10",
        },
        dest = "dank-qml-common",
      },
    ],

    separateBuildDir = false,
    configurePhase = [
      "export GOROOT=/usr/lib/go",
      "export GOMODCACHE=${SRC}/core/go-mod",
      #   "export CGO_ENABLED=1",
      "mkdir /tmp/home",
      "export HOME=/tmp/home",
      "mkdir core/go-mod",
      "(cd core/go-mod && tar xf /source.tar)",
    ],

    extraMakeInstallArgs = [
      "PREFIX=/usr"
    ],

    # buildPhase = [
    #   "tar xf /source.tar",
    #   "cd core/cmd/dms",
    #   #   "go build -trimpath -ldflags \"-s -w -X main.Version=0.0.5\"",
    #   m%"go build -ldflags "-linkmode 'external' -extldflags '-static'" "%,
    # ],

    # installPhase = [
    #   "install -dm0755 ${DEST}/usr/bin",
    #   "(cd ${SRC}/core/cmd/dms && install -m0755 dms ${DEST}/usr/bin)",
    # ],

    enableCcache = false,
    biDrvs = [
      drvs.danklinuxDmsSource,
      drvs.go_1_26,
      # drvs.llvm,
      # drvs.musl,
      drvs.basefiles,
      drvs.fish,
      drvs.zsh,
    ]
  }
}
