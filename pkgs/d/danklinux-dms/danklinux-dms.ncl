let s = {

  # uri = "https://github.com/AvengeMedia/DankMaterialShell/archive/refs/tags/v1.0.2.tar.gz",
  # sha256sum = "3cb952f15417487484137b010751efa997602a1f535605f472acd47d3d783161",
  uri = "https://github.com/AvengeMedia/DankMaterialShell/archive/ff506548d35d8cc733c34dad9361fd39dd21eb00.tar.gz",
  sha256sum = "3b1f0e9954be9e905d183ff6248ad046a6348481ed1ce115e7ee8f71852b13c0"
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
    outputSha256sum = "d01ded5e5e187a7049f5e80fc58ce0305a34ca0f7d2be0186251c44e76bcb8f3",

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
