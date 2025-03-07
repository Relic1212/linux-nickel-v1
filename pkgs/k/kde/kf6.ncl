{
  lib,
  drvs,
  _kf | lib.CmakePackage = {
    generator = "Ninja",

    llvmProvider = drvs.llvmFull,
    symlinkBuldInputs = true,

    options = {
      waylandSyms =false,
    },

    biDrvs | priority -1 = [
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
    ] @ (if options.waylandSyms then [ drvs.waylandWeaksyms ] else [drvs.wayland]) @[
      
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
      EXTRA_LDFLAGS = [
        "$(pkg-config --libs --static gbm glesv2 egl dri wayland-client)",
      ]
    },
    cmakeExtraArgsRecord = {

      "-DCMAKE_MODULE_LINKER_FLAGS:STRING" = "\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -lglapi -ldrm $(pkg-config --libs --static dri glesv2 gbm egl wayland-client)\""
    },
  }
}
& {
  lib,
  drvs,
  _kf,
  kconfig | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kconfig-6.11.0.tar.xz",
        sha256sum = "c71072aaf2771295b591fc62d4fb657cefb38df29f240ef9c7120854b42d0f7f"
      },
    },
  kcoreaddons | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kcoreaddons-6.11.0.tar.xz",
        sha256sum = "ff691c6e0933493ea3e8c4a0ba41fa46ced7b9394e6f35ef9dee349ccfcc3a39"
      },
      cmakeExtraArgsRecord = {
        "-DBUILD_TESTING" = false,
      }
    },

  kauth | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kauth-6.11.0.tar.xz",
        sha256sum = "479660eabe97198c31f228a18271bc739b234943c68e95383c361a835131179b"
      },
      biDrvs = _kf.biDrvs @ [drvs.kcoreaddons]
    }, 
    
     kglobalaccel | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kglobalaccel-6.11.0.tar.xz",
        sha256sum = "0552e4e5c58a244733af49cfdd0c8fc04a63828b6c2346b36820222d5e3bcef5"
      },
      biDrvs = _kf.biDrvs @ [drvs.kcoreaddons],
      cmakeExtraArgsRecord = {
        "-DBUILD_TESTING" = false,
        "-DWITH_X11" = false,

      }
    },
    
     kpackage | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kpackage-6.11.0.tar.xz",
        sha256sum = "bfc704ea1708f37150a9d14edcbb9eed8ebf8d54753930da63432cda954a1ea7"
      },
      biDrvs = _kf.biDrvs @ [drvs.kcoreaddons,drvs.karchive,drvs.bzip2,drvs.ki18n,drvs.gettext]
    },
   kdoctools | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kdoctools-6.11.0.tar.xz",
        sha256sum = "dfcdc6a0258f5cc2e55d248f616cc7c6224e1b06140deb687e401b537959fc08"
      },
      biDrvs = _kf.biDrvs @ [drvs.kcoreaddons,drvs.karchive,drvs.bzip2,drvs.ki18n,drvs.gettext]
    },

       kidletime   | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kidletime-6.11.0.tar.xz",
        sha256sum = "96efb0b533a37ddb2e1888dff7d4722c19c47d660f74d1b0a422eb95718f4882"
      },
      biDrvs = _kf.biDrvs @ [drvs.kcoreaddons,drvs.plasmaWaylandProtocols,
      drvs.libxml2,
      drvs.libxslt,
      ],
        cmakeExtraArgsRecord = {
        "-DWITH_X11" = false,
                        "-DBUILD_DESIGNERPLUGIN"=false,
                        "-DBUILD_TESTING" = false,

      },
      preConfigurePhase=[
        "sed -i 's@add_subdirectory(examples)@#add_subdirectory(examples)@g' ${SRC}/CMakeLists.txt",
        m%"
        for f in $(find ${SRC} -name CMakeLists.txt); do
          sed -i 's@ MODULE@@g' ${f}
        done
        "%
      ]
    },


       kcrash   | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kcrash-6.11.0.tar.xz",
        sha256sum = "ba13e9f5dd2b40125d5d61d29b612db6383315dc0f510cc1f0e33bb6c9b0ae89"
      },
      biDrvs = _kf.biDrvs @ [drvs.kcoreaddons],
        cmakeExtraArgsRecord = {
        "-DWITH_X11" = false,
      }
    },


      kservice   | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kservice-6.11.0.tar.xz",
        sha256sum = "161cd296577ff9802b088b06866ec5ab4c1c1a6fe19f76bb5134cdf8a6ab4005"
      },
      biDrvs = _kf.biDrvs @ [drvs.kcoreaddons,drvs.kconfig,drvs.ki18n,drvs.gettext,]
    },

      ksvg   | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/ksvg-6.11.0.tar.xz",
        sha256sum = "053092e36b76deeffe19629ae12a372b172f947bee3cc2034c68e7ba4e1da6cf"
      },
      biDrvs = _kf.biDrvs @ [
        drvs.kcoreaddons,
        drvs.karchive,
        drvs.kconfig,
        drvs.kcolorscheme,
        drvs.kguiaddons,
        drvs.bzip2,
                  drvs.plasmaWaylandProtocols,
 drvs.ki18n,
drvs.gettext,
drvs.kirigami,
        ]
    },


      kirigami   | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kirigami-6.11.0.tar.xz",
        sha256sum = "22392c95bb835f11626250f0728ce73590db638814e7181148fcf66a1f442ea6"
      },
      biDrvs = _kf.biDrvs @ [
        drvs.kcoreaddons,
        drvs.karchive,
        drvs.kconfig,
        drvs.kcolorscheme,
        drvs.kguiaddons,
        drvs.bzip2,
                  drvs.plasmaWaylandProtocols,
 drvs.ki18n,
drvs.gettext,
        ]
    },



  kdbusaddons | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kdbusaddons-6.11.0.tar.xz",
        sha256sum = "62e0f3b0487ef1ab729fc85bcb5498c9449e0b74fe8049779434158bb8b12a87"
      },
      cmakeExtraArgsRecord={
        "-DWITH_X11"=false,
      }
    },

  kcolorscheme | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kcolorscheme-6.11.0.tar.xz",
        sha256sum = "8b27bddb830f0173f44ae9aac05213579909b85fa696a2871b2ee11cb239bcc8"
      },
      biDrvs = _kf.biDrvs @ [drvs.kcoreaddons, drvs.kconfig,
            drvs.plasmaWaylandProtocols,
drvs.kguiaddons,
drvs.ki18n,
drvs.gettext,
      ]
    },

  kconfigwidgets | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kconfigwidgets-6.11.0.tar.xz",
        sha256sum = "28a1bb125161fe9ab0dbfa899433512e928669be31ce149fa25191a24a50242a"
      },
      biDrvs = _kf.biDrvs @ [
        drvs.kcoreaddons,
        drvs.kcodecs,
        drvs.kconfig,
        drvs.kguiaddons,
        drvs.ki18n,
        drvs.gettext,
        drvs.kwidgetsaddons,
        drvs.kcolorscheme,
        ],
                  cmakeExtraArgsRecord  = {
        "-DBUILD_TESTING" = false,
                "-DBUILD_DESIGNERPLUGIN"=false,

      }
    },
  kwidgetsaddons | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kwidgetsaddons-6.11.0.tar.xz",
        sha256sum = "1c64e7354804845db0cd83ae671dfb5d2cb08308551a0b6c7b8a339aa6dcb436"
      },
      biDrvs = _kf.biDrvs @ [
        drvs.kcoreaddons,
        drvs.kcodecs,
        drvs.kconfig,
        drvs.kguiaddons,
        drvs.ki18n,
        drvs.gettext,
        ],
             cmakeExtraArgsRecord  = {
        "-DBUILD_TESTING" = false,
        "-DBUILD_DESIGNERPLUGIN"=false,
      }
    },

    karchive | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/karchive-6.11.0.tar.xz",
        sha256sum = "12fc4ac53591fb1dd81d6c5243b900a6d48066559263fc66eb2f4995ceb9e380"
      },
      biDrvs = _kf.biDrvs @ [drvs.kcoreaddons,drvs.bzip2,]
    },


    kcodecs | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kcodecs-6.11.0.tar.xz",
        sha256sum = "fbddc437ba9969d89635b75f0ef7e41c925c61c64dac1fff008c2e9138139fe4"
      },
      biDrvs = _kf.biDrvs @ [drvs.kcoreaddons,drvs.gperf]
    },
  ki18n | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/ki18n-6.11.0.tar.xz",
        sha256sum = "658a05ceca184ba31ce58a6e9c51ee76f2829459c56dbcd3bad3aa157eaf11fe"
      },
      biDrvs = _kf.biDrvs @ [drvs.kcoreaddons,drvs.gperf,drvs.isoCodes,drvs.pythonFull,drvs.gettext,]
    },



    kguiaddons | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kguiaddons-6.11.0.tar.xz",
        sha256sum = "ef0925f609ae5b62ed689451dfe9937719ce4ec26714952b5496e3e128d5cc5c"
      },
      biDrvs = _kf.biDrvs @ [
        drvs.kcoreaddons,
      drvs.plasmaWaylandProtocols,
      ],
     cmakeExtraArgsRecord = {
        "-DWITH_X11" = false,
      }
    },

    kwindowsystem | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kwindowsystem-6.11.0.tar.xz",
        sha256sum = "d872e85d0915dd5cf1e2baf89fbef62e9855ff3317ecc5939882bc1724628d5a"
      },
      options.waylandSyms = true,
      biDrvs = (std.array.filter (fun x => (x.name != "wayland")) _kf.biDrvs) @ [
        drvs.kcoreaddons,
        drvs.plasmaWaylandProtocols,
        drvs.waylandWeaksyms,
        ],
      cmakeExtraArgsRecord = {
        "-DKWINDOWSYSTEM_X11" = false,
      },
      preConfigurePhase=[
        "sed -i 's@MODULE@STATIC@g' ${SRC}/src/platforms/wayland/CMakeLists.txt"
      ]
    },

    kauth | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kauth-6.11.0.tar.xz",
        sha256sum = "479660eabe97198c31f228a18271bc739b234943c68e95383c361a835131179b"
      },
      biDrvs = _kf.biDrvs @ [drvs.kcoreaddons],
      cmakeExtraArgsRecord  = {
        "-DBUILD_TESTING" = false,
        "-DKAUTH_BUILD_CODEGENERATOR_ONLY"=true,
      }
    },


    plasmaWaylandProtocols | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/plasma-wayland-protocols/plasma-wayland-protocols-1.16.0.tar.xz",
        sha256sum = "da3fbbe3fa5603f9dc9aabe948a6fc8c3b451edd1958138628e96c83649c1f16"
      },
      biDrvs = _kf.biDrvs @ [drvs.kcoreaddons],
 
    },


}
