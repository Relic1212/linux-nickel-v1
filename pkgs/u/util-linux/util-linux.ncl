{
  lib,
  linuxHeaders,
  bash,

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

      biDrvs =
        lib.biMap [
          linuxHeaders,
          bash,
        ]
    }
}
