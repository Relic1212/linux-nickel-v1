{
    lib,
    drvs,
    sysboard | lib.MakePackage = {
        singleSource = {
            uri = "https://github.com/System64fumo/sysboard/archive/90ceddb67bcf3a609e7892bc67e8c7ca806b85bc.zip",
            sha256sum = "47ce97a1ddf7e591109de1f60413598432b255c4e5ccfaec9677dcf01dd59202"
        },
        
      llvmProvider = drvs.llvmFull,
    #   pythonProvider = drvs.pythonDynamic,

      biDrvs = [
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
        #drvs.pango, #??
         drvs."pango-1.56",

        drvs.cairo,
        drvs.libpng,
        drvs.harfbuzzFull,
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
        drvs.gtk4,
        drvs.vala,
        drvs.pythonSetuptools,
      
      
        drvs.libtiff,
        drvs.graphene,

        drvs.gtkmm4,


        drvs."libsigc++",

        drvs."cairomm-1.16",
        drvs."pangomm-2.48",
        drvs."glibmm-2.82" ,
        drvs.gtk4LayerShell,


        drvs.pkgconf,






      ],

      preConfigurePhase = [
        #"sed -i 's@-fno-exceptions@@g' ${SRC}/Makefile",
        "sed -i 's@pkg-config@pkg-config --static@g' ${SRC}/Makefile",
        "sed -i 's@-shared@-static@g' ${SRC}/Makefile",


        "sed -i 's@LDFLAGS += -Wl,-O1,--as-needed,-z,now,-z,pack-relative-relocs@#LDFLAGS += -Wl,-O1,--as-needed,-z,now,-z,pack-relative-relocs@g' ${SRC}/Makefile",

        "sed -i 's@CXXFLAGS += -Os -s -Wall -flto=auto -fno-exceptions -fPIC@#CXXFLAGS += -Os -s -Wall -flto=auto -fno-exceptions -fPIC@g' ${SRC}/Makefile",

        "sed -i 's@libsysboard.so@ libsysboard.a@g' ${SRC}/Makefile",


      ]

        
    }
}