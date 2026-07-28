{
  lib,
  drvs,
  libvpx | lib.AutotoolsPackage = {
    singleSource = {
      # uri = "https://github.com/webmproject/libvpx/archive/refs/tags/v1.16.0.tar.gz",
      # sha256sum = "7a479a3c66b9f5d5542a4c6a1b7d3768a983b1e5c14c60a9396edc9b649e015c",

      uri = "https://github.com/webmproject/libvpx/archive/refs/tags/v1.15.2.tar.gz",
      sha256sum = "26fcd3db88045dee380e581862a6ef106f49b74b6396ee95c2993a260b4636aa",
    },

    configureFlags = [
      "--prefix=/usr",
      #   "--exec_prefix=/usr",
      #   "--bindir=/usr/bin",
      #   "--sbindir=/usr/bin",
      #   "--libexecdir=/usr/libexec",
      #   "--datadir=/usr/share",
      #   "--sysconfdir=/etc",
      #   "--sharedstatedir=/com",
      #   "--localstatedir=/var",
      "--libdir=/usr/lib",
      #   "--includedir=/usr/include",
      #   "--oldincludedir=/usr/include",
      #   "--infodir=/usr/share/info",
      #   "--mandir=/usr/share/man",
      "--enable-static",
      "--disable-shared",
    ],

    biDrvs = [
      drvs.diffutils & { priority = 1 },
      drvs.perl,
    ],
  }
}
