{
    lib,
    drvs,
    xcbUtilErrors|lib.AutotoolsPackage = {
        singleSource = {
            uri = "https://xorg.freedesktop.org/archive/individual/lib/xcb-util-errors-1.0.1.tar.xz",
            sha256sum = "5628c87b984259ad927bacd8a42958319c36bdf4b065887803c9d820fb80f357"
        },
        biDrvs = [
             drvs.libxcursor,
        drvs.xorgMacros,
        drvs.xorgproto,
        drvs.xtrans,
        drvs.libxcb,
        drvs.xcbProto,
        drvs.libxau,
        drvs.libx11,
        drvs.libxrender,
        drvs.libxfixes,
        drvs.pkgconf,
        drvs.zlibNg,
        drvs.xcbRenderutil,
        drvs.m4,
        drvs.pythonFull,
        ]
    }
}