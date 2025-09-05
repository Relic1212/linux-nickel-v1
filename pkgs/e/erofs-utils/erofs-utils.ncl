{
  lib,
  drvs,
  erofsUtils | lib.AutomakePackage = {
    singleSource = {
      uri = "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-1.8.10.tar.gz",
      sha256sum = "05eb4edebe11decce6ecb34e98d2f80c8cd283c2f2967d8ba7efd58418570514",
    },
    extraConfigureFlags = [
      "--enable-multithreading",
      "--with-xxhash",
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
