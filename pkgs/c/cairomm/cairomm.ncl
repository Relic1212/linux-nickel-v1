{
  lib,
  drvs,
  cairomm | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/cairo/cairomm/-/archive/1.19.1/cairomm-1.19.1.tar.bz2",
      sha256sum = "ffc9a607e0ecc004808e7727ab90815e983e486dc3002c87b22f85717c2e9d84"
    },
    biDrvs = [
      drvs.perl,
    ],
    pDrvs = [
      # drvs.pixman,
      # drvs.zlibNg,
      # drvs.freetype,
      # drvs.fontconfig,
      # drvs.libpng,
      # drvs.expat,
      drvs.cairo,
      drvs.libsigcpp
    ]
  }
}
& {
  lib,
  drvs,
  cairomm_1_0 | lib.MesonPackage = {
    singleSource = {
      uri = "https://www.cairographics.org/releases/cairomm-1.14.5.tar.xz",
      sha256sum = "70136203540c884e89ce1c9edfb6369b9953937f6cd596d97c78c9758a5d48db"
    },
    biDrvs = [
      drvs.perl,
      drvs.pixman,
      drvs.zlibNg,
      drvs.freetype,
      drvs.fontconfig,
      drvs.libpng,
      drvs.expat,
      drvs.cairo,
      drvs.libsigcpp2
    ]
  }
}
& {
  lib,
  drvs,
  cairomm_1_16 | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/cairo/cairomm/-/archive/1.16.0/cairomm-1.16.0.tar.gz",
      sha256sum = "96b281441b6836bf579139c3beeac527d1ae8cc6040344f52b20e6842a1bd937"
    },
    biDrvs = [
      drvs.perl,
      drvs.pixman,
      drvs.zlibNg,
      drvs.freetype,
      drvs.fontconfig,
      drvs.libpng,
      drvs.expat,
      drvs.cairo,
      drvs.libsigcpp
    ]
  }
}
