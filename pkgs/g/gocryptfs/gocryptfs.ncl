{
  lib,
  drvs,
  gocryptfs | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/rfjakob/gocryptfs/releases/download/v2.6.1/gocryptfs_v2.6.1_src-deps.tar.gz",
      sha256sum = "9a966c1340a1a1d92073091643687b1205c46b57017c5da2bf7e97e3f5729a5a",
    },

    preConfigurePhase = [
      "export GOROOT=/usr/lib/go",
      "export CGO_ENABLED=0",
      "mkdir /tmp/home",
      "export HOME=/tmp/home",
      "for f in $(find ${SRC} -name '*.bash'); do sed -i 's|bin/bash|usr/bin/bash|g' ${f};done",
    ],

    buildPhase = [
      "./build.bash",
    ],
    # installPhase = [
    #   "install -Dm755 -t \"$DEST/usr/bin/\" gocryptfs",
    #   "install -Dm755 -t \"$DEST/usr/bin/\" gocryptfs-xray/gocryptfs-xray",
    # ],

    biDrvs = [
      drvs.go_1_26,
      drvs.bash,
    ],
  }
}
