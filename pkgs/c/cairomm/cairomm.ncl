{
  lib,
  drvs,
  cairomm | lib.MesonPackage
    = {
      singleSource = {
        uri = "https://gitlab.freedesktop.org/cairo/cairomm/-/archive/1.18.0/cairomm-1.18.0.tar.gz",
        sha256sum = "aec941f5b1c25392fec2b079edbd322d54520efc7c6a7a48eef111e14a67ca64"
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
        drvs."libsigc++"
      ]
    }
}
& {
  lib,
  drvs,
  "cairomm-1.0" | lib.MesonPackage
    = {
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
        drvs."libsigc++2"
      ]
    }
}


&
{
  lib,
  drvs,
  "cairomm-1.16" | lib.MesonPackage
    = {
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
        drvs."libsigc++"
      ]
    }
}
