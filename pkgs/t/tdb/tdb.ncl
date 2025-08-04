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
      drvs.pythonDynamic,
      drvs.muslShared,
    ],
    #   extraMakeArgs = [
    #     "HOST_CC='clang -static --static'",
    #     "HOST_CXX='clang++ -static --static'",
    #   ],
    separateBuildDir = false,

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
      # "--disable-shared"
    ]
  }
}
