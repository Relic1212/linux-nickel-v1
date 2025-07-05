{
  lib,
  drvs,
  qemu | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://download.qemu.org/qemu-9.2.3.tar.xz",
      sha256sum = "baed494270c361bf69816acc84512e3efed71c7a23f76691642b80bc3de7693e",
    }
  }
}
