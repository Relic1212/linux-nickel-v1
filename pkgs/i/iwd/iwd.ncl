{
  lib,
  drvs,
  iwd | lib.AutotoolsPackage = {
    name = "iwd",
    singleSource = {
      uri = "https://mirrors.edge.kernel.org/pub/linux/network/wireless/iwd-2.21.tar.xz",
      sha256sum = "d911398242cdae78a474fe712de7bd138ddc39122f52709b52c8c3bf03716392",
    },
    biDrvs =
      [
        drvs.expat,
        drvs.zlibNg,
        drvs.readline,
        drvs.ncurses,
        drvs.dbus,
        drvs.linuxHeaders,
        drvs.pkgconf,
      ],
    extraConfigureFlags = [
      "--disable-systemd-service",
      "--enable-tools",
    ],
    preConfigurePhase = [
      "cd ${SRC}",
      "sed -i 's@ -t ell @ @g' ${SRC}/Makefile.am",
      "sed -i 's@ -t ell @ @g' ${SRC}/Makefile.in",
    ],
    preBuildPhase = [
      "sed -i 's@ -lreadline@ -lreadline -lncursesw@g' Makefile"
    ]
  }
}
