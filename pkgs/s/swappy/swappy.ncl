{
    lib,
    drvs,

    swappy | lib.MesonPackage = {
        singleSource = {
            uri = "https://github.com/jtheoof/swappy/archive/2aa3ae2433ee671ddc73e36ece8598e68f7f3632.zip",
            sha256sum = "718e41fa65ac2e20291f009dd1edfc44414683489b93ee9a7a3fd3a7714fedd7"
        },
        biDrvs = [
           # drvs."gtk+3" ,
            drvs.fontconfig,
        drvs.freetype,
        drvs.zlibNg,
        drvs.gperf,
        drvs.pixman,
        drvs.wayland,
        drvs.waylandProtocols,
        drvs.libffi,
        drvs.libxkbcommon,
        drvs.expat,
        drvs.linuxHeaders,
        drvs.ncurses,
        drvs.readline,
        drvs.pcre2,
        drvs.pango,
        drvs.cairo,
        drvs.libpng,
        drvs.harfbuzz,
        drvs.glib,
        drvs.hwdata,
        drvs.cairoGobjectEmpty,
        drvs.fribidi,
        drvs.gdkPixbufFull,
        drvs.libjpegTurbo,
        drvs.libepoxy,
        drvs.atSpi2Core,
        ]

    }
}