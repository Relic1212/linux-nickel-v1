{
  lib,
  linuxHeaders,
  linuxWithBuild,
  rsync,
  kmod,

  linuxWithBuild,
  v4l2loopback | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/umlaeute/v4l2loopback/archive/refs/tags/v0.13.2.tar.gz",
      sha256sum = "1e57e1e382d7451aa2a88d63cc9f146eab1f425b90e76104d4c3d73127e34771"
    },
    options = { version = linuxWithBuild.options.version },
    biDrvs =
      lib.biMap [
        linuxHeaders,
        linuxWithBuild,
        (kmod & { priority = 1 }),
        rsync,
      ],
    extraMakeArgs = [
      "KERNELRELEASE=%{options.version}-standard",
      "KERNEL_DIR=/usr/lib/modules/%{options.version}-standard/build",
      "INSTALL_MOD_STRIP=1",
      "LLVM=1",
      "INSTALL_MOD_PATH=/tmp/workdir/out/destdir",
      #        "DEPMOD=true",
      "MODLIB=${DEST}/usr/lib/modules/%{options.version}-standard",
    ],
    extraMakeInstallArgs =
      extraMakeArgs
      @ [
        "PREFIX=/usr"
      ],
    postInstallPhase = [
      m%"rsync -a --no-compress --no-o --no-g --perms --acls --xattrs --exclude="build/" /usr/lib/modules/%{options.version}-standard/ ${DEST}/usr/lib/modules/%{options.version}-standard/"%,
      "cp -r /boot ${DEST}",
    ]
  }
}
& {
  lib,

  linux,
  rsync,

  linuxWithBuild | lib.MakePackage =
    linux
    & {
      biDrvs | priority 1 =
        linux.biDrvs
        @ lib.biMap [
          rsync
        ],
      options,
      postInstallPhase | priority 1 =
        linux.postInstallPhase
        @ [
          "rm ${DEST}/usr/lib/modules/%{options.version}-standard/build",
          "mkdir ${DEST}/usr/lib/modules/%{options.version}-standard/build",

          # "rsync -a --no-compress --no-o --no-g --perms --acls --xattrs --exclude=drivers ${SRC}/ ${DEST}/usr/lib/modules/%{options.version}-standard/build/",
          m%"rsync -a --no-compress --no-o --no-g --perms --acls --xattrs --exclude="*.o" --exclude="*.ko" --exclude="*.a" ${SRC}/ ${DEST}/usr/lib/modules/%{options.version}-standard/build/"%,

          #"cp -r ${SRC} ${DEST}/usr/lib/modules/%{options.version}-standard/build",
        ]
    }
}
