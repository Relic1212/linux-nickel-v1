let s = {

  # uri = "https://github.com/AvengeMedia/DankMaterialShell/archive/refs/tags/v1.0.2.tar.gz",
  # sha256sum = "3cb952f15417487484137b010751efa997602a1f535605f472acd47d3d783161",
  # uri = "https://github.com/AvengeMedia/DankMaterialShell/archive/80bc87e76b61467918bdf5fa399289e81281eebb.tar.gz",
  # sha256sum = "f978c921c45690de6f7a2947ceea9c93ea7bd3be6fb84ae9af7bd0ee37d1b2e4",

  uri = "https://github.com/AvengeMedia/DankMaterialShell/archive/refs/tags/v1.2.3.tar.gz",
  sha256sum = "ce3d098441db44c835437f810e042c55aca97752bf2244d3d50ac83caf79b337",
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

    # outputSha256sum = "ce1fe457b9fa70302d2497006bbe1ba98d0274a9dd5abf421f825e38ab1da952",
    # outputSha256sum = "a3febee577c1dfdc9f58ecbe4a9b90010aaa62dce359731a8ce50552c64bddc4",
    outputSha256sum = "81fbd573140dc78315f8343f19a0751b72533c661af26cda1c8510c8ab8d7b25",

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
    ]
  }
}
