{
  lib,
  go_1_9,
  findutils,
  libpam,

  fscrypt | lib.MakePackage = {
    #name = "fscrypt",
    sourceInputs = [
      {
        src = {
          uri = "https://github.com/google/fscrypt/archive/refs/tags/v0.3.4.tar.gz",
          sha256sum = "fe3c51ecb936226087bb3a62dddda5b7f5cd77dd3be7bf1feb270e1c55eddfa3",
        }
      },
      {
        src = {
          uri = "https://dev.gentoo.org/~flow/distfiles/fscrypt/fscrypt-0.3.4-deps.tar.xz",
          sha256sum = "37f0ebea5fd2db70d51ebecd8971163901c1d861ab8c4456a74c361cdcc01d84"
        },
        dest = "go-mod",
      }
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
    buildPhase = [
      "make bin/fscrypt"
    ],
    installPhase = [
      "install -d -m0755 ${DEST}/usr/bin",
      "install -m0755 bin/fscrypt ${DEST}/usr/bin"
    ],
    biDrvs =
      lib.biMap [
        go_1_9,
        findutils,
        libpam,
      ]
  }
}
