{
  lib,

  libtiff | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://download.osgeo.org/libtiff/tiff-4.7.0.tar.xz",
      sha256sum = "273a0a73b1f0bed640afee4a5df0337357ced5b53d3d5d1c405b936501f71017"
    }
  }
}
