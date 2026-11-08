let s = {

  uri = "https://github.com/duxlabs-dev/dux-shell/archive/refs/tags/v2.1.2.tar.gz",
  sha256sum = "4990fcd6c359b63b8ce32d97c8b09e3dddb0f71096abec6f1a535445b0039a7f",
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

    outputSha256sum = "b6d60eb74d0e39328e2b10b3fbc48073b0889b3fc5fbc1da4c76e10234f97418", # vendor

    biDrvs = [
      drvs.go_1_27,
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
          uri = "https://github.com/duxlabs-dev/dux-qml-common/archive/refs/tags/v2.0.0.tar.gz",
          sha256sum = "dc08721f6df0fbd7717486e1fd3aa29e0b6ec0c687c68efd6b4576751b0752ca",
        },
        dest = "dux-qml-common",
      },
    ],
    # eofPatches = [
    #   {
    #     patch = import "dms-cp.patch" as 'Text,
    #   },
    # ],
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
      drvs.go_1_27,
      # drvs.llvm,
      # drvs.musl,
      drvs.basefiles,
      drvs.fish,
      drvs.zsh,
    ]
  }
}
