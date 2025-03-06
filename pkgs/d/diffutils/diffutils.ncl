{
  lib,
  diffutils | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://mirrors.ocf.berkeley.edu/gnu/diffutils/diffutils-3.10.tar.xz",
      sha256sum = "90e5e93cc724e4ebe12ede80df1634063c7a855692685919bfe60b556c9bd09e",
    }
  }
}
