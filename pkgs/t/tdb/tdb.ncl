{
  lib,
  drvs,
  tdb | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://www.samba.org/ftp/tdb/tdb-1.4.13.tar.gz",
      sha256sum = "5ee276e7644d713e19e4b6adc00b440afb5851ff21e65821ffaed89e15a5e167"
    },
    extraEnv = {
      #HOST_CC = [ "clang", "-static"]
    },
    biDrvs = [
      drvs.pythonFull,
      drvs.muslShared,
      drvs.linuxHeaders,
      drvs.libbsd,
      drvs.libmd,
      drvs.openssl,
    ],
    #   extraMakeArgs = [
    #     "HOST_CC='clang -static --static'",
    #     "HOST_CXX='clang++ -static --static'",
    #   ],
    separateBuildDir = false,
    buildEnv = {
      EXTRA_CFLAGS = ["-v"],
      EXTRA_LDFLAGS = ["-v"],
    },

    configureFlags | force = [
      "--prefix=/usr",
      # "--exec_prefix=/usr",
      "--bindir=/usr/bin",
      "--sbindir=/usr/bin",
      "--libexecdir=/usr/libexec",
      "--datadir=/usr/share",
      "--sysconfdir=/etc",
      "--sharedstatedir=/com",
      "--localstatedir=/var",
      "--libdir=/usr/lib",
      "--includedir=/usr/include",
      "--oldincludedir=/usr/include",
      "--infodir=/usr/share/info",
      "--mandir=/usr/share/man",
      # "--enable-static",
      # "--disable-shared",

      # https://github.com/alpinelinux/aports/blob/97bb462b84ed78f318fdd67b02713969eccfbd04/main/tdb/APKBUILD#L4
      "--bundled-libraries=NONE",
      "--builtin-libraries=replace",
      "--disable-rpath",
      "--disable-warnings-as-errors",
      "--disable-dependency-tracking",
    ]
  }
}
