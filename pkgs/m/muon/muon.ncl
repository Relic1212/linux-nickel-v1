{
  lib,
  drvs,
  muon | lib.Package = {
    singleSource = {
      uri = "https://github.com/muon-build/muon/archive/refs/tags/0.5.0.tar.gz",
      sha256sum = "565c1b6e1e58f7e90d8813fda0e2102df69fb493ddab4cf6a84ce3647466bee5"
    },
    separateBuildDir = false,
    enableCcache = false,
    biDrvs = [
      drvs.llvm,
      drvs.pkgconf,
      drvs.musl,
      # libarchive and curl are only for wrap
    ],
    buildPhase = [
      "./bootstrap.sh ../build",
      "../build/muon-bootstrap setup -Dstatic=true -Dprefix=/usr ../build",
      "../build/muon-bootstrap -C ../build samu",
      "../build/muon-bootstrap -C ../build test",
    ],
    installPhase = [
      "DESTDIR=${DEST} ../build/muon-bootstrap -C ../build install",
      "(cd ${DEST}/usr/bin && ln -s muon meson)",
    ]
  }
}
