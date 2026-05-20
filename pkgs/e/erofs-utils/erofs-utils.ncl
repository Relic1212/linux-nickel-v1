{
  lib,
  drvs,
  erofsUtils | lib.AutomakePackage = {
    singleSource = {
      uri = "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-1.9.1.tar.gz",
      sha256sum = "a9ef5ab67c4b8d2d3e9ed71f39cd008bda653142a720d8a395a36f1110d0c432",
    },
    extraConfigureFlags = [
      "--enable-multithreading",
      "--enable-lz4",
      # "--with-libdeflate",
      "--with-xxhash",
      "--enable-static-fuse",
      "--enable-fuse",
    ],
    biDrvs = [
      drvs.utilLinux,
      drvs.lz4,
      drvs.xz,
      drvs.zlibNg,
      drvs.zstd,
      drvs.xxhash,
      drvs.linuxHeaders,
    ]
  }
}
