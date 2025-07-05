{
  lib,
  drvs,
  nwgDrawer | lib.MakePackage = {
    sourceInputs = [
      {
        src = {
          uri = "https://github.com/nwg-piotr/nwg-drawer/archive/refs/tags/v0.5.2.tar.gz",
          sha256sum = "7fc913001bf49a6856b09f47d192bcd806d7737fe6b64fee0876a4dd15a43f07",
        }
      },
      # {
      #   src = {
      #     uri = "https://dev.gentoo.org/~flow/distfiles/fscrypt/fscrypt-0.3.4-deps.tar.xz",
      #     sha256sum = "37f0ebea5fd2db70d51ebecd8971163901c1d861ab8c4456a74c361cdcc01d84"
      #   },
      #   dest = "go-mod",
      # }
    ],
    separateBuildDir = false,
    configurePhase = [
      # "cd ${SRC}",
      "export GOROOT=/usr/lib/go",
      "export GOMODCACHE=${SRC}/go-mod",
      "export CGO_ENABLED=1",
      "mkdir /tmp/home",
      "export HOME=/tmp/home",
    ],

    biDrvs = [
      drvs.go_1_9,
      drvs.findutils,
    ]
  }
}
