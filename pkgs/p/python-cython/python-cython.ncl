{
  lib,
  drvs,
  pythonCython | lib.SetuptoolPackage = {
    singleSource = {
      uri = "https://github.com/cython/cython/archive/refs/tags/3.3.0.tar.gz",
      sha256sum = "405332595ffe256fb1d2e8311798de44d5e1a54883331d15484c2d6cc8446af2",
    },
    biDrvs = [
      drvs.llvm,
      drvs.musl,
    ],
  }
}
