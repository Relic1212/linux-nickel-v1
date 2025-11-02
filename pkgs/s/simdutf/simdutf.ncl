{
  lib,
  drvs,
  simdutf | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/simdutf/simdutf/archive/refs/tags/v7.5.0.tar.gz",
      sha256sum = "3cad2f554912ecd77222272e5d1a7c1e5e33b4011bee823269cdc9095d2fdce2"
    }
  }
}
