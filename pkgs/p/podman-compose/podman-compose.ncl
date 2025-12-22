{
  lib,
  drvs,
  podmanCompose | lib.gpepPackage = {
    singleSource = {
      uri = "https://github.com/containers/podman-compose/archive/refs/tags/v1.5.0.tar.gz",
      sha256sum = "83624b850fd0727f0cc3a574e17471cd003e1d85c46af91854bdab67299058fa"
    }
  }
}
