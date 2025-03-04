 

{
    lib,
    drvs,
    _kf | lib.CmakePackage={
        generator = "Ninja",
      
        llvmProvider = drvs.llvmFull,


    biDrvs = [
        drvs.pixman,
        drvs.expat,
        drvs.libffi,
        drvs.libevdev,
        drvs.mtdev,
        drvs.pango,
        drvs.cairo,
        drvs.libpng,
        drvs.freetype,
        drvs.fontconfig,
        drvs.zlibNg,
        drvs.harfbuzz,
        drvs.glib,
        drvs.hwdata,
        drvs.linuxHeaders,
       
        drvs.libjpegTurboStatic,

        drvs.libspng,

        drvs.file,
        drvs.libwebp,
        drvs.dbusForQt,

        drvs.qtdeclarative,
        drvs.qtbase,
        drvs.qtshadertools,
        drvs.qtwayland,
        drvs.qt5compat,
        drvs.qtTools,
        drvs.qtsensors,
        drvs.qtsvg,



        drvs.mesa2,
        # drvs.pkgconf,
        drvs.libelf,
        drvs.libdrm,
        drvs.pythonMako,
        drvs.pythonPackaging,
        drvs.pythonMarkupsafe,
        drvs.libpciaccess,
        drvs.bison,
        drvs.flex,
        drvs.wayland,
        drvs.waylandProtocols,
        drvs.m4,
        drvs.pyyaml,
        drvs.llvmConfigStatic,
        drvs.spirvTools,
        drvs.spirvLlvmTranslator,
        ###
        drvs.jsonC,
        drvs.pcre2,
        drvs.libxkbcommon,
        drvs.openssl,

        drvs.kmod,
        drvs.zstd,
        drvs.xz,
        drvs.eudev,
        drvs.libinput,
        drvs.ecm,
    ],
    buildEnv = {
        EXTRA_LDFLAGS= [
          
            "$(pkg-config --libs --static gbm glesv2 egl dri wayland-client)",



        ]
    },
    cmakeExtraArgsRecord = {


        "-DCMAKE_MODULE_LINKER_FLAGS:STRING"="\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -lglapi -ldrm $(pkg-config --libs --static dri glesv2 gbm egl wayland-client)\""
    },
    }
}

&

{
    lib, drvs,_kf,
    kconfig | lib.CmakePackage = _kf &{
          singleSource ={
            uri="https://download.kde.org/stable/frameworks/6.11/kconfig-6.11.0.tar.xz",
            sha256sum = "c71072aaf2771295b591fc62d4fb657cefb38df29f240ef9c7120854b42d0f7f"
        },
    },
    kcoreaddons | lib.CmakePackage = _kf &{
          singleSource ={
            uri="https://download.kde.org/stable/frameworks/6.11/kcoreaddons-6.11.0.tar.xz",
            sha256sum = "ff691c6e0933493ea3e8c4a0ba41fa46ced7b9394e6f35ef9dee349ccfcc3a39"
        },
        cmakeExtraArgsRecord={
            "-DBUILD_TESTING" = false,
        }
    },

    kauth | lib.CmakePackage = _kf &{
          singleSource ={
            uri="https://download.kde.org/stable/frameworks/6.11/kauth-6.11.0.tar.xz",
            sha256sum = "479660eabe97198c31f228a18271bc739b234943c68e95383c361a835131179b"
        },
    },
kdbusaddons | lib.CmakePackage = _kf &{
          singleSource ={
            uri="https://download.kde.org/stable/frameworks/6.11/kdbusaddons-6.11.0.tar.xz",
            sha256sum = "62e0f3b0487ef1ab729fc85bcb5498c9449e0b74fe8049779434158bb8b12a87"
        },
    },

kcolorscheme | lib.CmakePackage = _kf &{
          singleSource ={
            uri="https://download.kde.org/stable/frameworks/6.11/kcolorscheme-6.11.0.tar.xz",
            sha256sum = "8b27bddb830f0173f44ae9aac05213579909b85fa696a2871b2ee11cb239bcc8"
        },
    },

kconfigwidgets | lib.CmakePackage = _kf &{
          singleSource ={
            uri="https://download.kde.org/stable/frameworks/6.11/kconfigwidgets-6.11.0.tar.xz",
            sha256sum = "28a1bb125161fe9ab0dbfa899433512e928669be31ce149fa25191a24a50242a"
        },
    },

}