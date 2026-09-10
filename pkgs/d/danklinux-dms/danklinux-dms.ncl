let s = {

  uri = "https://github.com/AvengeMedia/DankMaterialShell/archive/refs/tags/v1.5.3.tar.gz",
  sha256sum = "2d665870f7019700fb38d59d043202e298e1aad1d3f1cb96360a75acbd3be9ca",
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

    outputSha256sum = "99457824a0e2191715243420886fe41864c5edcdf1257cdb4994b45d84899469",

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
