{
  lib,
  drvs,
  utilLinux | lib.AutotoolsPackage =
    let conf =
      lib.AutotoolsPackage.configureFlags
      @ [
        "--disable-use-tty-group",
        "--disable-makeinstall-chown",
        "--disable-liblastlog2",
        "--disable-login-stat-mail",
      ]
    in

    {
      name = "util-linux",
      singleSource = {
        uri = "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.40/util-linux-2.40.tar.xz",
        sha256sum = "d57a626081f9ead02fa44c63a6af162ec19c58f53e993f206ab7c3a6641c2cd7"
      },
      configureFlags = conf,
      configurePhase =
        [
          m%"sed -i 's@\/bin\/bash@\/usr\/bin\/bash@g' ${SRC}/tools/all_syscalls"%,
          m%"sed -i 's/\/sbin/\/bin/g' ${SRC}/configure"%
        ]
        @ (lib.AutotoolsPackage & { configureFlags = conf }).configurePhase,

      biDrvs = [
        drvs.linuxHeaders,
        drvs.bash,
      ]
    }
}
& {
  lib,
  drvs,
  utilLinux241 | lib.MesonPackage = {
    singleSource = {
      uri = "https://www.kernel.org/pub/linux/utils/util-linux/v2.41/util-linux-2.41.tar.gz",
      sha256sum = "c014b5861695b603d0be2ad1e6f10d5838b9d7859e1dd72d01504556817d8a87"
    },
    biDrvs = [
      drvs.linuxHeaders,
      drvs.bash,
    ],
    preConfigurePhase = [
      m%"sed -i 's@\/bin\/bash@\/usr\/bin\/bash@g' ${SRC}/tools/all_syscalls"%,
      m%"sed -i 's/\/sbin/\/bin/g' ${SRC}/configure"%
    ],
    # extraConfigureFlags=[

    # "--disable-use-tty-group",
    # "--disable-makeinstall-chown",
    # "--disable-liblastlog2",
    # "--disable-login-stat-mail",

    # ]
  }
}
