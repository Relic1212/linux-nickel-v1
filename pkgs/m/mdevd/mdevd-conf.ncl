{
  lib,
  mdevdConf | lib.MakePackage
    = {
      singleSource = {
        uri = "https://gitlab.alpinelinux.org/alpine/mdev-conf/-/archive/e83083ea00d1fbb8c53244746f8cea78d84d68a3/mdev-conf-e83083ea00d1fbb8c53244746f8cea78d84d68a3.tar.gz",
        sha256sum = "7f6dee59904ff39025bdface649f3cfcb6b309df855e9e0f64e73e54bebd59e7",
      },
      extraMakeInstallArgs = [
        "PREFIX=/usr",
      ],
    }
}
