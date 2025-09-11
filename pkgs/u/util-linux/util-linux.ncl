{
  lib,
  drvs,
  _utilLinux240 | lib.AutotoolsPackage =
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
  _utilLinux241 | lib.MesonPackage = {
    singleSource = {
      # uri = "https://www.kernel.org/pub/linux/utils/util-linux/v2.41/util-linux-2.41.1.tar.gz",
      # sha256sum = "c756213ed3f17b74c1525fc0ed839d6d09f1731ee443e2415c42071afed58ff9",

      uri = "https://github.com/util-linux/util-linux/archive/063d65949c6b1dbe25ccc7948debbd019f88a111.tar.gz",
      sha256sum = "f84cf67013bf53ecedaa2804aad151b9eca9d6fb25daeb1b198c0cb5474ab895",
    },
    # sourceInputs = [
    #   {src=singleSource},
    #   {
    #     src = {
    #       uri = "https://github.com/util-linux/util-linux/commit/f39ffccf2b9b8dcaaf2069346cc50735c2f0f95d.patch",
    #       sha256sum = "8c58d4b94efb47a2d5373184f441aaad3c104cc371f7029138d92c4e5530237b"
    #     }
    #   }
    # ],
    preConfigurePhase = [
      m%"sed -i 's@\/bin\/bash@\/usr\/bin\/bash@g' ${SRC}/tools/all_syscalls"%,
      m%"sed -i 's@\/bin\/bash@\/usr\/bin\/bash@g' ${SRC}/tools/all_errnos"%,

      # "(cd ${SRC} && patch -p1 < f39ffccf2b9b8dcaaf2069346cc50735c2f0f95d.patch)",

      # https://github.com/util-linux/util-linux/pull/3538/files
      m%"sed -i 's@#include <linux\/mount.h>@#include <linux\/mount.h>\n#include <linux\/unistd.h>@g' ${SRC}/include/mount-api-utils.h"%,

      # m%"sed -i 's@both_libraries@both_libraries@g' ${SRC}/libsmartcols/meson.build"%,

      # "lib_smartcols.get_static_lib()"
      m%"for f in $(find ${SRC} -name meson.build); do sed -i 's@both_libraries@library@g' ${f};done"%,
      m%"for f in $(find ${SRC} -name meson.build); do sed -i 's@.get_static_lib()@@g' ${f};done"%,
    ]
    # @ (
    #   let
    #     pr = ["text-utils/column.c", "disk-utils/partx.c", "lib/strutils.c", "include/strutils.h"],
    #     ps = [
    #       "disk-utils/cfdisk.c",
    #       "disk-utils/fdisk.c",
    #       "libfdisk/src/script.c",
    #       "include/strutils.h",
    #       "libfdisk/src/gpt.c",
    #       "sys-utils/lscpu-topology.c",
    #       "lib/strutils.c",
    #     ]
    #   in
    #   (
    #     (std.array.map (fun f => "sed -i 's|parse_range|util_linux__parse_range|g' ${SRC}/%{f}") pr)
    #     @ (std.array.map (fun f => "sed -i 's|parse_size(|util_linux__parse_size(|g' ${SRC}/%{f}") ps)
    #   )
    # )
    ,

    extraMesonArgs = [
      "-Dprogram-tests=false",
      "-Dfs-search-path=/usr/bin",
      "-Dbuild-python=disabled",
      "-Dbuild-pylibmount=disabled",
      "-Dbuild-fdisks=enabled",
    ],

    biDrvs = [
      drvs.linuxHeaders,
      drvs.bash,
      drvs.bison,
      drvs.flex,
      drvs.m4,
      (drvs.coreutils & { priority = 1 }),
      drvs.ncurses,
    ]
  },

  utilLinuxLogin =
    _utilLinux241
    & {
      debug = true,
      biDrvs | priority 1 = _utilLinux241.biDrvs @ [drvs.libpam131],
      extraMesonArgs | priority 1 = _utilLinux241.extraMesonArgs @ ["-Dbuild-login=enabled"],
    }
}
& {
  _utilLinux240,
  _utilLinux241,

  # utilLinux241 = _utilLinux241,
  # utilLinux = _utilLinux240,

  utilLinux = _utilLinux241,
  utilLinux240 = _utilLinux240,
}
