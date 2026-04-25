{
  lib,
  drvs,
  dinitEditGo | lib.Package = {
    singleSource = {
      uri = "https://github.com/davmac314/dinit/raw/refs/tags/v0.21.0/contrib/dinit-edit/dinit-edit.go",
      sha256sum = "215900b8e484671dd1037e871dd6ca71061e5bb56562df4e2001b118cbbb4c35",
    },
    enableCcache = false,
    separateBuildDir = false,
    buildPhase = [
      "export GOROOT=/usr/lib/go",
      "export GOMODCACHE=${SRC}/go-mod",
      "export CGO_ENABLED=1",
      "mkdir /tmp/home",
      "export HOME=/tmp/home",
      "go build dinit-edit.go"
    ],

    installPhase = [
      "install -Dm0755 dinit-edit ${DEST}/usr/bin/dinit-edit",
    ],

    biDrvs = [
      drvs.go_1_24,
      drvs.musl,
    ]
  }
}
