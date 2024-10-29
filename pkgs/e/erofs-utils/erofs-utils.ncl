{
  lib,
  pkgs,
  erofsUtils | lib.AutomakePackage
    = {
      singleSource = {
        uri = "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-1.8.1.tar.gz",
        sha256sum = "5dbf7b492f7682462b97a77121d43ca7609cd90e65f8c96931aefc820a6f0da3",
      },
      biDrvs =
        lib.biMap [
          pkgs.utilLinux,
        ]
    }
}
