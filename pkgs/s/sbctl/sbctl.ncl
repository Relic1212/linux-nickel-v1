{
  lib,
  drvs,
  sbctl | lib.MakePackage = {
    sourceInputs = [
      {
        src = {
          uri = "https://github.com/Foxboron/sbctl/releases/download/0.15.4/sbctl-0.15.4.tar.gz",
          sha256sum = "0435097f79fc30c9b3567a50a8beb8d7d71fcea6121533b5da543ca64241cfff"
        }
      },
      {
        src = {
          uri = "https://dev.gentoo.org/~ajak/distfiles/app-crypt/sbctl/sbctl-0.15.4-deps.tar.xz",
          sha256sum = "69a1fef7f76f7e399cce6439843e52f3cd27ce6888036242617f28fa281dfb80"
        },
        dest = "go-mod",
      }
    ],
    biDrvs = [
      drvs.go_1_23,
      drvs.utilLinux,
    ],
    configurePhase = [
      "export GOROOT=/usr/lib/go",
      "export GOMODCACHE=${SRC}/go-mod",
      "export CGO_ENABLED=0",
      "mkdir /tmp/home",
      "export HOME=/tmp/home",
    ],
    makeTargets = [
      "sbctl"
    ],
    buildPhase = [
      m%"
        go build  -ldflags="-extldflags -static -X github.com/foxboron/sbctl.Version=0.15.4" -o sbctl ./cmd/sbctl


        "%
    ],

    installPhase = [
      m%"
        export DESTDIR=$DEST
        export BINDIR=/usr/bin
        export LIBDIR=/usr/lib
        export SHRDIR=/usr/share
        export PROGNM=sbctl

        install -Dm755 sbctl -t ${DESTDIR}${BINDIR}

        install -Dm755 contrib/kernel-install/91-sbctl.install ${DESTDIR}${LIBDIR}/kernel/install.d/91-sbctl.install
        install -Dm644 LICENSE -t ${DESTDIR}${SHRDIR}/licenses/${PROGNM}


        "%
    ]
  }
}
