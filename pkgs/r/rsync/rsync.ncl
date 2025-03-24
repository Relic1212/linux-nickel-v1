{
  lib,
  drvs,
  rsync
    |
    # lib.AutomakePackage
    lib.AutotoolsPackage
    = {
      singleSource = {
        uri = "https://download.samba.org/pub/rsync/src/rsync-3.4.0.tar.gz",
        sha256sum = "8e942f95a44226a012fe822faffa6c7fc38c34047add3a0c941e9bc8b8b93aa4"
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
        drvs.libcap,
      ],
      extraConfigureFlags = [
        "--disable-md2man",
        "--disable-xxhash",
        # "--with-included-popt=no",
        # "--with-included-zlib=no",
        #  "--disable-zstd" ,"--disable-lz4",
        "--enable-roll-simd",
        "--enable-acl-support",
        "--enable-xattr-support",
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
