{
    lib,
    drvs,
    pipewire|lib.MesonPackage={
        singleSource={
            uri = "https://gitlab.freedesktop.org/pipewire/pipewire/-/archive/1.2.7/pipewire-1.2.7.tar.gz",
            sha256sum = "e75568ed18bcbe75e9779af57cb9cc256fd7ebfaadc12bb347a0717055d1d3a9"
        },
        biDrvs = [
            drvs.dbus,
            drvs.alsaLibs,


        


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
        drvs.glibDynamic,
        drvs.muslShared,
        drvs.hwdata,
        drvs.gobjectDynamic,
        drvs.cairoGobject,
        drvs.fribidi,
        drvs.gdkPixbufFull,
        drvs.libjpegTurbo,
        drvs.libepoxy,
        drvs.atSpi2Core,
        drvs.mesa2,
        drvs.libelf,
        drvs.libdrm,
        drvs.libpciaccess,
        drvs.llvmConfigStatic,
        drvs.spirvTools,
        drvs.spirvLlvmTranslator,

        drvs."gtk+3",

        drvs.eudev,
          drvs.kmod,
          drvs.xz,
          drvs.openssl,
          drvs.zstd,
          drvs.utilLinux,
        
        drvs.libevdev,

        (drvs.findutils & {priority = 1}),

      
        ],
        extraMesonArgs = [
            "-Dsession-managers=[]",
            "-Dvideotestsrc=disabled",
            "-Dvideoconvert=disabled",
            "-Dv4l2=disabled",
            "-Dsupport=enabled",
            "-Dspa-plugins=disabled",
            "-Dtests=disabled",
            "-Davb=disabled",
            "-Draop=disabled",
        ],
        preConfigurePhase = [
            m%"
            for f in $(find "${SRC}" -name meson.build); do
                sed -i 's@shared_library@library@g' "${f}"
            done
            "%
        ]
    }
}