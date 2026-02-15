{
  lib,
  drvs,
  linuxWithBuild,
  v4l2loopback | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/umlaeute/v4l2loopback/archive/refs/tags/v0.15.3.tar.gz",
      sha256sum = "2758ea287da8dd34a0421c0dd50094a0342d22414e1bbccbbe92f41bbaa26b2d"
    },
    options = { version = linuxWithBuild.options.version },
    biDrvs = [
      drvs.linuxHeaders,
      drvs.linuxWithBuild,
      (drvs.kmod & { priority = 1 }),
      drvs.rsync,
      drvs.zstd,
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
  drvs,
  linux,
  linuxFedora,
  linuxWithBuild | lib.MakePackage =
    linuxFedora
    & {
      biDrvs | priority 1 =
        linuxFedora.biDrvs
        @ [
          drvs.rsync
        ],
      options,
      postInstallPhase | priority 1 =
        linuxFedora.postInstallPhase
        @ [
          "rm ${DEST}/usr/lib/modules/%{options.version}-standard/build",
          "mkdir ${DEST}/usr/lib/modules/%{options.version}-standard/build",

          # "rsync -a --no-compress --no-o --no-g --perms --acls --xattrs --exclude=drivers ${SRC}/ ${DEST}/usr/lib/modules/%{options.version}-standard/build/",
          m%"rsync -a --no-compress --no-o --no-g --perms --acls --xattrs --exclude="*.o" --exclude="*.ko" --exclude="*.a" ${SRC}/ ${DEST}/usr/lib/modules/%{options.version}-standard/build/"%,

          #"cp -r ${SRC} ${DEST}/usr/lib/modules/%{options.version}-standard/build",
        ]
    }
}
