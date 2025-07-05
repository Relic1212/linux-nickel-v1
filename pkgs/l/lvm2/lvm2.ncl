{
  lib,
  # llvm,
  # gnumake,
  # busybox,
  # musl,
  # ccacheBin,
  # pkgconf,
  # linuxHeaders,
  drvs,
  lvm2 | lib.AutotoolsPackage = {
    name = "lvm2",
    singleSource = {
      uri = "https://sourceware.org/ftp/lvm2/LVM2.2.03.26.tgz",
      sha256sum = "72ea8b4f0e1610de5d119296b15ef2a2203431089541dcbebc66361f65fb35f5",
    },
    configureFlags =
      lib.AutotoolsPackage.configureFlags
      @ [
        "--enable-static_link",
        "--disable-cmdlib",
        "--disable-dmfilemapd",
        "--disable-dmeventd",
        "--disable-fsadm",
        "--disable-lvmpolld",
        "--with-mirrors=none",
        "--with-snapshots=none",
        "--with-thin=none",
        "--without-cache",
        "--enable-pkgconfig",
        "--with-symvers=no",
        "--with-thin-check=none",
        "--with-thin-dump=none",
        "--with-thin-repair=none",
        "--with-staticdir=bin",
        "--with-usrsbindir=bin",
      ],
    biDrvs = [
      drvs.pkgconf,
      drvs.linuxHeaders,
    ],
    buildPhase = [
      "make DESTDIR=${DEST} install_device-mapper",
    ],
    installPhase = []
  }
}
