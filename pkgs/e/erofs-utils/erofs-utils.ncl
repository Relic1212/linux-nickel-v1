{
  lib,
  drvs,
  distro,
  erofsUtils | lib.AutomakePackage = {
    singleSource = {
      uri = "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-1.9.4.tar.gz",
      sha256sum = "7d135aa2550326a5acf20f53c518aea5a8900015ce50700044e40f818c31dd80",
    },
    options = {
      selinux | default = distro.selinux,
      # selinux = false,
    },
    extraConfigureFlags =
      [
        "--enable-multithreading",
        "--enable-lz4",
        # "--with-libdeflate",
        "--with-xxhash",
        "--enable-static-fuse",
        "--enable-fuse",
      ]
      @ (if options.selinux then ["--with-selinux"] else []),
    biDrvs = [
      drvs.utilLinux,
      drvs.lz4,
      drvs.xz,
      drvs.zstd,
      drvs.xxhash,
      drvs.linuxHeaders,
    ],
    pDrvs = (
      if options.selinux then
        [drvs.selinux]
      else
        [
          drvs.zlibNg,
        ]
    ),
  }
}
