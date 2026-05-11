let s = {

  uri = "https://github.com/AvengeMedia/DankMaterialShell/archive/refs/tags/v1.4.4.tar.gz",
  sha256sum = "9a23a717eef088da3d25b355d4f13feff7499bbafe5e93c9fa379ee15e962709",
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
      "cd ..",
      "chown -R root:root .",
      "chmod -R 755 .",
      m%"find . -print0 | xargs -0r touch --no-dereference --date="@1302044400""%,
      "tar --sort=name -cf - . > ${BUILDDIR}/%{outputFile}",
    ],
    installPhase = [
      "install -m0755 ${BUILDDIR}/%{outputFile} ${DEST}/%{outputFile}"
    ],
    outputFile = "source.tar",

    outputSha256sum = "1f08e5b0a785c5e50a63998fa4b2fb7d230254b25aee9a46c9430919c54cc3b3",

    biDrvs = [
      drvs.go_1_26,
      drvs.emptyResolvConf,
      drvs.caCertificates,
      (drvs.gnutar & { priority = 1 }),
      drvs.basefiles,
    ]
  },
  danklinuxDms | lib.MakePackage = {

    separateBuildDir = false,
    configurePhase = [
      "export GOROOT=/usr/lib/go",
      "export GOMODCACHE=${SRC}/core/go-mod",
      #   "export CGO_ENABLED=1",
      "mkdir /tmp/home",
      "export HOME=/tmp/home",
      "tar xf /source.tar",
    ],

    extraMakeInstallArgs = [
      "PREFIX=${DEST}/usr"
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
