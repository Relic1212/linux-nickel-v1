{
  lib,
  mtools | lib.AutotoolsPackage = {
    name = "mtools",
    singleSource = {
      uri = "https://ftp.gnu.org/gnu/mtools/mtools-4.0.44.tar.bz2",
      sha256sum = "37dc4df022533c3d4b2ec1c78973c27c7e8b585374c2d46ab64c6a3db31eddb8",
    }
  }
}
