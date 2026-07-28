{
  lib,
  drvs,
  gptfdisk | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/samangh/gptfdisk/archive/0e13e907ced9981024d0bdec7e2dc1b2081c9cbe.tar.gz",
      sha256sum = "93247694ad9da174f764c3c16fb41ca91edeee44ac52ec72fb3f00c5b3265e4e",
    },
    extraMakeArgs = [
      "PREFIX=/usr",
    ],
    preConfigurePhase = [
      m%"sed -i 's@ncursesw/ncurses.h@ncurses.h@g' ${SRC}/gptcurses.cc"%,
    ],

    installPhase =
      let executables = [
        "cgdisk",
        "fixparts",
        "gdisk",
        "sgdisk",
      ]
      # ,
      # manpages = [
      #   "cgdisk.8",
      #   "fixparts.8",
      #   "gdisk.8",
      #   "sgdisk.8",
      # ]
      in (
        [
          "install -dm0755 ${DEST}/usr/bin",
          "install -dm0755 ${DEST}/usr/share/man/man8",
        ]
        @ (
          std.array.map
            (fun s => "install -m0755 %{s} ${DEST}/usr/bin\ninstall -m0755 %{s}.8 ${DEST}/usr/share/man/man8"
            )
            executables
        )
      ),

    biDrvs = [
      drvs.linuxHeaders,
    ],
    pDrvs = [
      drvs.utilLinux,
      drvs.ncurses,
      drvs.popt,
    ]
  }
}
