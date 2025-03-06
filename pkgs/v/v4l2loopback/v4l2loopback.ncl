{
  lib,
  drvs,
  v4l2loopback | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/umlaeute/v4l2loopback/archive/refs/tags/v0.13.2.tar.gz",
      sha256sum = "1e57e1e382d7451aa2a88d63cc9f146eab1f425b90e76104d4c3d73127e34771"
    },
    biDrvs = [
      drvs.linuxHeaders,
      drvs.linuxWithBuild,
      (drvs.kmod & { priority = 1 }),
      drvs.rsync,
    ],
    extraMakeArgs = [
      "KERNELRELEASE=6.10.0-standard",
      "KERNEL_DIR=/usr/lib/modules/6.10.0-standard/build",
      "INSTALL_MOD_STRIP=1",
      "LLVM=1",
      "INSTALL_MOD_PATH=/tmp/workdir/out/destdir",
      #        "DEPMOD=true",
      "MODLIB=${DEST}/usr/lib/modules/6.10.0-standard",
    ],
    extraMakeInstallArgs =
      extraMakeArgs
      @ [
        "PREFIX=/usr"
      ],
    postInstallPhase = [
      m%"rsync -a --no-compress --no-o --no-g --perms --acls --xattrs --exclude="build/" /usr/lib/modules/6.10.0-standard/ ${DEST}/usr/lib/modules/6.10.0-standard/"%,
      "cp -r /boot ${DEST}",
    ]
  }
}
& {
  lib,
  drvs,
  linux,
  linuxWithBuild | lib.MakePackage =
    linux
    & {
      biDrvs | priority 1 = linux.biDrvs @ [drvs.rsync],
      postInstallPhase | priority 1 =
        linux.postInstallPhase
        @ [
          "rm ${DEST}/usr/lib/modules/6.10.0-standard/build",
          "mkdir ${DEST}/usr/lib/modules/6.10.0-standard/build",

          # "rsync -a --no-compress --no-o --no-g --perms --acls --xattrs --exclude=drivers ${SRC}/ ${DEST}/usr/lib/modules/6.10.0-standard/build/",
          m%"rsync -a --no-compress --no-o --no-g --perms --acls --xattrs --exclude="*.o" --exclude="*.ko" --exclude="*.a" ${SRC}/ ${DEST}/usr/lib/modules/6.10.0-standard/build/"%,

          #"cp -r ${SRC} ${DEST}/usr/lib/modules/6.10.0-standard/build",
        ]
    }
}
