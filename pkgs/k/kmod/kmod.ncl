{
  lib,
  drvs,
  kmod | lib.MesonPackage = {
    singleSource = {
      # uri = "https://github.com/kmod-project/kmod/archive/refs/tags/v33.tar.gz",
      # sha256sum = "c72120a2582ae240221671ddc1aa53ee522764806f50f8bf1522bbf055679985",

      uri = "https://github.com/kmod-project/kmod/archive/refs/tags/v34.tar.gz",
      sha256sum = "cb47be49366b596e4554eeeb7595b128feb261619c7675603e004b07c5ebbd5b"
    },

    patches = [
      {
        file = "kmod-ln.patch",
        sha256sum = "f7f1b17209e55a14b075758c9c606be7453d0fecc0cc8f8893bbf1d27fcff00d"
      },
    ],
    # preConfigurePhase = [
    #   # "cd ${SRC}"
    #   #  "./autogen.sh",
    #   "(cd ${SRC}; ./autogen.sh)",
    # ],
    # configureFlags | force = [
    #   "--disable-gtk-doc",
    #   "--prefix=/usr",
    #   "--exec_prefix=/usr",
    #   "--bindir=/usr/bin",
    #   "--sbindir=/usr/bin",
    #   "--libexecdir=/usr/libexec",
    #   "--datadir=/usr/share",
    #   "--sysconfdir=/etc",
    #   "--sharedstatedir=/com",
    #   "--localstatedir=/var",
    #   "--libdir=/usr/lib",
    #   "--includedir=/usr/include",
    #   "--oldincludedir=/usr/include",
    #   "--infodir=/usr/share/info",
    #   "--mandir=/usr/share/man",
    #   "--disable-manpages",
    #   "--with-module-directory=/usr/lib/modules",
    #   "--with-openssl",
    #   "--with-zlib",
    #   "--with-xz",
    #   "--with-zstd",
    # ],

    # extraMesonArgs = [
    #   "-Dmoduledir='//usr/lib/modules'"
    # ],

    preConfigurePhase = [
      # m%"sed -i "s|\/bin\/bash|\/usr\/bin\/bash|g" ${SRC}/scripts/build-scdoc.sh"%,
      m%"sed -i "s|\/bin\/bash|/bin\/sh|g" ${SRC}/scripts/build-scdoc.sh"%,
      m%"sed -i "s|o pipefail||g" ${SRC}/scripts/build-scdoc.sh"%,
      m%"sed -i "s|shared_library|library|g" ${SRC}/meson.build"%,
      m%"sed -i "s|\/lib\/modules|\/usr\/lib\/modules|g" ${SRC}/meson.build"%,
    ],

    biDrvs = [
      drvs.xz,
      drvs.zlibNg,
      drvs.zstd,
      drvs.openssl,
      drvs.scdoc,
      # drvs.bash,
    ],
  }
}
