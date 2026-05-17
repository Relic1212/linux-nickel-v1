let s = {
  uri = "https://github.com/AvengeMedia/dgop/archive/refs/tags/v0.1.2.tar.gz",
  sha256sum = "15a85775b98adc00751943f274b58fc12088bbc0013565b6dbf5c6d7eb48c1cf"
}
in

{
  lib,
  drvs,
  danklinuxDgopSource | lib.DeterministicFetcher = {
    singleSource = s,
    separateBuildDir = false,
    configurePhase = [
      "export GOROOT=/usr/lib/go",
      "export GOMODCACHE=${SRC}/go-mod",
      # "export CGO_ENABLED=1",
      "mkdir /tmp/home",
      "export HOME=/tmp/home",
    ],
    buildPhase = [
      "go mod vendor -v",
      m%"find . -print0 | xargs -0r touch --no-dereference --date="@1302044400""%,
      "tar --sort=name -cf - . > ../build/%{outputFile}",
      # "tar cf - . > ../build/%{outputFile}",
    ],
    installPhase = [
      "install -m0755 ../build/%{outputFile} ${DEST}/%{outputFile}"
    ],
    outputFile = "source.tar",
    outputSha256sum = "22a342d8537a2f93a0dce28afb4a1c22abac4494e528dd14c36dffec74181163",

    biDrvs = [
      drvs.go_1_26,
      drvs.emptyResolvConf,
      drvs.caCertificates,
      (drvs.gnutar & { priority = 1 }),
    ]
  },
  danklinuxDgop | lib.Package = {

    separateBuildDir = false,
    configurePhase = [
      "export GOROOT=/usr/lib/go",
      "export GOMODCACHE=${SRC}/go-mod",
      "export CGO_ENABLED=1",
      "mkdir /tmp/home",
      "export HOME=/tmp/home",
    ],

    buildPhase = [
      "tar xf /source.tar",
      #   "go build -trimpath -ldflags \"-s -w -X main.Version=0.0.5\"",
      "cd cmd/cli",
      m%"go build -ldflags "-linkmode 'external' -extldflags '-static'" -o dgop"%,
    ],

    installPhase = [
      "install -dm0755 ${DEST}/usr/bin",
      "(cd ${SRC}/cmd/cli && install -m0755 dgop ${DEST}/usr/bin)",
    ],

    enableCcache = false,
    biDrvs = [
      drvs.danklinuxDgopSource,
      drvs.go_1_26,
      drvs.llvm,
      drvs.musl,
      drvs.gnumake,
      drvs.emptyResolvConf,
      drvs.caCertificates,
    ]
  }
}
