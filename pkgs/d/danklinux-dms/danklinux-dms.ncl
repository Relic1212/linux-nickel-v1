let s = {

  uri = "https://github.com/AvengeMedia/DankMaterialShell/archive/refs/tags/v1.6.3.tar.gz",
  sha256sum = "32e5a87130c5127391f5b1f307348e89a2b34f17e9f0d9c8c0ce09fba334e1fd",
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

     outputSha256sum = "040fc9a121f6cda4111989825d5a4029b32de09e77012ac38d23398e92ccd5cb", # vendor

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
    eofPatches = [
      {
        patch = import "dms-cp.patch" as 'Text,
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
