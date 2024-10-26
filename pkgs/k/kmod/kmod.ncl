{
  lib,
  pkgs,
  kmod | lib.AutomakePackage
    = {
      name = "kmod",
      singleSource = {
        uri = "https://github.com/kmod-project/kmod/archive/refs/tags/v33.tar.gz",
        sha256sum = "c72120a2582ae240221671ddc1aa53ee522764806f50f8bf1522bbf055679985",
      },
      preConfigurePhase = [
        # "cd ${SRC}"
        #  "./autogen.sh",
        "(cd ${SRC}; ./autogen.sh)",
      ],
      configureFlags | force
        = [
          "--disable-gtk-doc",
          "--prefix=/usr",
          "--exec_prefix=/usr",
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
          "--disable-manpages",
        ],

      biPkgs = [
        pkgs.xz,
        pkgs.zlibNg,
        pkgs.openssl,
      ],
    }
}
