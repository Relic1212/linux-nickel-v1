{
  lib,
  drvs,
  sassc | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/sass/sassc/archive/refs/tags/3.6.2.tar.gz",
      sha256sum = "608dc9002b45a91d11ed59e352469ecc05e4f58fc1259fc9a9f5b8f0f8348a03"
    },
    biDrvs = [
      drvs.libsass,
    ]
  }
}
& {
  lib,
  drvs,
  libsass | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/sass/libsass/archive/refs/tags/3.6.6.tar.gz",
      sha256sum = "11f0bb3709a4f20285507419d7618f3877a425c0131ea8df40fe6196129df15d"
    }
  }
}
& {
  lib,
  drvs,
  sass | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/sass/sass/archive/refs/tags/embedded-protocol-3.2.0.tar.gz",
      sha256sum = "4e1f81684bc1666f03e52ddc790d0c2c22d99a5313fa2efe1dde4a5b5733c186"
    }
  }
}
& {
  lib,
  drvs,
  dartSass | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/sass/dart-sass/archive/refs/tags/1.89.2.tar.gz",
      sha256sum = "4a2f78270eef196ecb24d37b0563a7da642463c678666e58f6f2028cb06aeb29"
    }
  }
}
