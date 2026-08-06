{
  lib,
  drvs,
  esbuild | lib.Package = {
    singleSource = {
      #   uri = "https://github.com/evanw/esbuild/archive/refs/tags/v0.28.1.tar.gz",
      #   sha256sum = "65c756fa87d43178ac4a5242454c2bd0fde325f8ecf77997f8fa4b88f94d5cd2",
      #
      #   uri = "https://github.com/evanw/esbuild/archive/refs/tags/v0.27.3.tar.gz",
      #   sha256sum = "05d56070104b46d24c8921bfc4c83209d71cf583eb0396c13d0f359705bb5b61",
      #

      uri = "https://github.com/evanw/esbuild/archive/refs/tags/v0.25.1.tar.gz",
      sha256sum = "5e84e44d7d2c2751f0b67e8cf909def3b0189b8e9549bcd663cadab582ab2947",
    },
    sourceInputs = [
      {
        src = singleSource,
      },
      {
        src = {
          #   uri = "https://deps.gentoo.zip/dev-util/esbuild/esbuild-0.27.3-vendor.tar.xz",
          #   sha256sum = "ae1b603e9bc2947d306ddb5445cadc7319d1667dfe40b4e7793670c319cb82ba",

          uri = "https://deps.gentoo.zip/dev-util/esbuild/esbuild-0.25.1-vendor.tar.xz",
          sha256sum = "0cbf483099c869e69886ac816c9965826ab4d247494133b2ed8eb3ebb46c1d13",
        },
        # dest = "go-mod",
      },
    ],
    extraEnv = {
      GOROOT = "/usr/lib/go",
      HOME = "/tmp/home",
    },
    separateBuildDir = false,
    preConfigurePhase = [
      "mkdir -p $HOME",
      #   "mv ${SRC}/go-mod/vendor ",
      "export GOMODCACHE=${SRC}/vendor",
    ],
    buildPhase = [
      m%"CGO_ENABLED=0 go build -mod=vendor "-ldflags=-s -w" -trimpath ./cmd/esbuild"%,
    ],
    installPhase = [
      "install -Dm0755 esbuild ${DEST}/usr/bin/esbuild",
    ],
    biDrvs = [
      drvs.go_1_26,
      #   drvs.nodejs,
    ],
  }
}
