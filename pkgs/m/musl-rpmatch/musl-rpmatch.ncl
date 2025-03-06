{
  lib,
  muslRpmatch | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/pullmoll/musl-rpmatch/archive/refs/tags/v1.0.tar.gz",
      sha256sum = "dcbd41909bd69eaeedd20f03435b165406b514465249186ff1ca68d04fd35953"
    }
  }
}
