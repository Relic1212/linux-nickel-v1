{
  lib,
  drvs,
  rsync
    |
    # lib.AutomakePackage
    lib.AutotoolsPackage
    = {
      singleSource = {
        uri = "https://download.samba.org/pub/rsync/src/rsync-3.3.0.tar.gz",
        sha256sum = "7399e9a6708c32d678a72a63219e96f23be0be2336e50fd1348498d07041df90"
      },

      # separateBuildDir=false,

      biDrvs = [
        # drvs.xxhash,
        drvs.zstd,
        drvs.lz4,
        drvs.openssl,
        # drvs.mandoc,
        # drvs.pythonFull,
        # drvs.m4,
        # drvs.libtool,
        drvs.pkgconf,
        drvs.zlibNg,
        drvs.xz,
        drvs.mawk,

        # optional
        drvs.attr,
        drvs.acl,
      ],
      extraConfigureFlags = [
        "--disable-md2man",
        "--disable-xxhash",
        # "--with-included-popt=no",
        # "--with-included-zlib=no",
        #  "--disable-zstd" ,"--disable-lz4",
        "--enable-roll-simd",
      ],
      buildEnv = {
        EXTRA_CFLAGS = [
          "-DINET6",
        ],
      },
      preConfigurePhase = [
        "rm  ${SRC}/testsuite/*.test",
        "install -d -m0755 /tmp/workdir/build/bin",
        "ln -s /usr/bin/mawk /tmp/workdir/build/bin/awk",
        "export PATH=/tmp/workdir/build/bin:$PATH",
      ]
    }
}
