{
  lib,
  glib,
  pcre2,
  libffi,
  zlibNg,
  gudev,
  eudev,
  llvmFull,
  pixman,
  expat,
  libffi,
  libevdev,
  mtdev,
  pango,
  cairo,
  libpng,
  freetype,
  fontconfig,
  zlibNg,
  harfbuzz,
  glib,
  hwdata,
  linuxHeaders,
  libjpegTurboStatic,
  libspng,
  file,
  libwebp,
  dbusForQt,
  qtdeclarative,
  qtbase,
  qtshadertools,
  qtwayland,
  qt5compat,
  qtTools,
  qtsensors,
  qtsvg,
  mesa2,
  # pkgconf,
  libelf,
  libdrm,
  pythonMako,
  pythonPackaging,
  pythonMarkupsafe,
  libpciaccess,
  bison,
  flex,

  waylandWeaksyms,

  wayland,
  waylandProtocols,
  m4,
  pyyaml,
  llvmConfigStatic,
  spirvTools,
  spirvLlvmTranslator,
  ###
  jsonC,
  pcre2,
  libxkbcommon,
  openssl,
  kmod,
  zstd,
  xz,
  eudev,
  libinput,
  ecm,

  _kf | lib.CmakePackage = {
    generator = "Ninja",

    llvmProvider = lib.singleBiMap llvmFull,
    symlinkBuldInputs = true,

    options = {
      waylandSyms = false,
    },

    biDrvs | priority -2 =
      lib.biMap (
        [
          pixman,
          expat,
          libffi,
          libevdev,
          mtdev,
          pango,
          cairo,
          libpng,
          freetype,
          fontconfig,
          zlibNg,
          harfbuzz,
          glib,
          hwdata,
          linuxHeaders,
          libjpegTurboStatic,
          libspng,
          file,
          libwebp,
          dbusForQt,
          qtdeclarative,
          qtbase,
          qtshadertools,
          qtwayland,
          qt5compat,
          qtTools,
          qtsensors,
          qtsvg,
          mesa2,
          # pkgconf,
          libelf,
          libdrm,
          pythonMako,
          pythonPackaging,
          pythonMarkupsafe,
          libpciaccess,
          bison,
          flex,
        ]
        @ (
          if options.waylandSyms then
            [
              waylandWeaksyms
            ]
          else
            [
              wayland
            ]
        )
        @ [
          waylandProtocols,
          m4,
          pyyaml,
          llvmConfigStatic,
          spirvTools,
          spirvLlvmTranslator,
          ###
          jsonC,
          pcre2,
          libxkbcommon,
          openssl,
          kmod,
          zstd,
          xz,
          eudev,
          libinput,
          ecm,
        ]
      ),
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
      biDrvs =
        _kf.biDrvs
        @ lib.biMap [
          kcoreaddons
        ]
    },

  kglobalaccel | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kglobalaccel-6.11.0.tar.xz",
        sha256sum = "0552e4e5c58a244733af49cfdd0c8fc04a63828b6c2346b36820222d5e3bcef5"
      },
      biDrvs =
        _kf.biDrvs
        @ lib.biMap [
          kcoreaddons
        ],
      cmakeExtraArgsRecord = {
        "-DBUILD_TESTING" = false,
        "-DWITH_X11" = false,
      }
    },
  bzip2,
  gettext,
  kpackage | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kpackage-6.11.0.tar.xz",
        sha256sum = "bfc704ea1708f37150a9d14edcbb9eed8ebf8d54753930da63432cda954a1ea7"
      },
      biDrvs =
        _kf.biDrvs
        @ lib.biMap [
          kcoreaddons,
          karchive,
          bzip2,
          ki18n,
          gettext
        ],
      patches = [
        {
          sha256sum = "e3bee168feb7c615f984b3af01fd7712fdb2774c7851cf601998f4d037dfe622",
          file = "kpackage-no-common.patch",
        }
      ]
    },
  kdoctools | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kdoctools-6.11.0.tar.xz",
        sha256sum = "dfcdc6a0258f5cc2e55d248f616cc7c6224e1b06140deb687e401b537959fc08"
      },
      biDrvs =
        _kf.biDrvs
        @ lib.biMap [
          kcoreaddons,
          karchive,
          bzip2,
          ki18n,
          gettext,
        ]
    },

  libxml2,
  libxslt,

  kidletime | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kidletime-6.11.0.tar.xz",
        sha256sum = "96efb0b533a37ddb2e1888dff7d4722c19c47d660f74d1b0a422eb95718f4882"
      },
      biDrvs =
        _kf.biDrvs
        @ lib.biMap [
          kcoreaddons,
          plasmaWaylandProtocols,
          libxml2,
          libxslt,
        ],
      cmakeExtraArgsRecord = {
        "-DWITH_X11" = false,
        "-DBUILD_DESIGNERPLUGIN" = false,
        "-DBUILD_TESTING" = false,
      },
      preConfigurePhase = [
        "sed -i 's@add_subdirectory(examples)@#add_subdirectory(examples)@g' ${SRC}/CMakeLists.txt",
        m%"
        for f in $(find ${SRC} -name CMakeLists.txt); do
          sed -i 's@ MODULE@@g' ${f}
        done
        "%
      ]
    },

  kcrash | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kcrash-6.11.0.tar.xz",
        sha256sum = "ba13e9f5dd2b40125d5d61d29b612db6383315dc0f510cc1f0e33bb6c9b0ae89"
      },
      biDrvs =
        _kf.biDrvs
        @ lib.biMap [
          kcoreaddons
        ],
      cmakeExtraArgsRecord = {
        "-DWITH_X11" = false,
      }
    },

  kservice | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kservice-6.11.0.tar.xz",
        sha256sum = "161cd296577ff9802b088b06866ec5ab4c1c1a6fe19f76bb5134cdf8a6ab4005"
      },
      biDrvs =
        _kf.biDrvs
        @ lib.biMap [
          kcoreaddons,
          kconfig,
          ki18n,
          gettext,
        ]
    },

  ksvg | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/ksvg-6.11.0.tar.xz",
        sha256sum = "053092e36b76deeffe19629ae12a372b172f947bee3cc2034c68e7ba4e1da6cf"
      },
      biDrvs =
        _kf.biDrvs
        @ lib.biMap [
          kcoreaddons,
          karchive,
          kconfig,
          kcolorscheme,
          kguiaddons,
          bzip2,
          plasmaWaylandProtocols,
          ki18n,
          gettext,
          kirigami,
        ]
    },

  kirigami | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kirigami-6.11.0.tar.xz",
        sha256sum = "22392c95bb835f11626250f0728ce73590db638814e7181148fcf66a1f442ea6"
      },
      biDrvs =
        _kf.biDrvs
        @ lib.biMap [
          kcoreaddons,
          karchive,
          kconfig,
          kcolorscheme,
          kguiaddons,
          bzip2,
          plasmaWaylandProtocols,
          ki18n,
          gettext,
        ]
    },

  kdbusaddons | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kdbusaddons-6.11.0.tar.xz",
        sha256sum = "62e0f3b0487ef1ab729fc85bcb5498c9449e0b74fe8049779434158bb8b12a87"
      },
      cmakeExtraArgsRecord = {
        "-DWITH_X11" = false,
      }
    },

  kcolorscheme | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kcolorscheme-6.11.0.tar.xz",
        sha256sum = "8b27bddb830f0173f44ae9aac05213579909b85fa696a2871b2ee11cb239bcc8"
      },
      biDrvs =
        _kf.biDrvs
        @ lib.biMap [
          kcoreaddons,
          kconfig,
          plasmaWaylandProtocols,
          kguiaddons,
          ki18n,
          gettext,
        ]
    },

  kconfigwidgets | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kconfigwidgets-6.11.0.tar.xz",
        sha256sum = "28a1bb125161fe9ab0dbfa899433512e928669be31ce149fa25191a24a50242a"
      },
      biDrvs =
        _kf.biDrvs
        @ lib.biMap [
          kcoreaddons,
          kcodecs,
          kconfig,
          kguiaddons,
          ki18n,
          gettext,
          kwidgetsaddons,
          kcolorscheme,
        ],
      cmakeExtraArgsRecord = {
        "-DBUILD_TESTING" = false,
        "-DBUILD_DESIGNERPLUGIN" = false,
      }
    },

  kwidgetsaddons | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kwidgetsaddons-6.11.0.tar.xz",
        sha256sum = "1c64e7354804845db0cd83ae671dfb5d2cb08308551a0b6c7b8a339aa6dcb436"
      },
      biDrvs =
        _kf.biDrvs
        @ lib.biMap [
          kcoreaddons,
          kcodecs,
          kconfig,
          kguiaddons,
          ki18n,
          gettext,
        ],
      cmakeExtraArgsRecord = {
        "-DBUILD_TESTING:BOOL" = "OFF",
        "-DBUILD_DESIGNERPLUGIN:BOOL" = "OFF",
      }
    },

  acl,
  attr,
  breezeIcons,
  bzip2,
  gettext,
  karchive,
  kauth,
  kbookmarks,
  kcodecs,
  kcolorscheme,
  kcompletion,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kded,
  kglobalaccel,
  kguiaddons,
  ki18n,
  kiconthemes,
  kidletime,
  kirigami,
  kitemviews,
  kjobwidgets,
  knotifications,
  kpackage,
  kservice,
  ksolid,
  ksvg,
  kwidgetsaddons,
  kwindowsystem,
  libcanberra,
  libogg,
  libtool,
  libvorbis,
  plasmaWaylandProtocols,
  switcherooControl,
  utilLinuxWeak,
  vala,

  kio | lib.CmakePackage = (
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kio-6.11.0.tar.xz",
        sha256sum = "fe511e43a5386f963c9afef93a21c0df44a2c24fcc417777e4d0569102477ff8"
      },
      biDrvs =
        _kf.biDrvs
        @ lib.biMap [
          acl,
          attr,
          breezeIcons,
          bzip2,
          gettext,
          karchive,
          kauth,
          kbookmarks,
          kcodecs,
          kcolorscheme,
          kcompletion,
          kconfig,
          kconfigwidgets,
          kcoreaddons,
          kcrash,
          kdbusaddons,
          kded,
          kglobalaccel,
          kguiaddons,
          ki18n,
          kiconthemes,
          kidletime,
          kirigami,
          kitemviews,
          kjobwidgets,
          knotifications,
          kpackage,
          kservice,
          ksolid,
          ksvg,
          kwidgetsaddons,
          kwindowsystem,
          libcanberra,
          libogg,
          libtool,
          libvorbis,
          plasmaWaylandProtocols,
          switcherooControl,
          utilLinuxWeak,
          vala,
        ],

      #    cmakeExtraArgsRecord = {
      #   "-DBUILD_TESTING" = false,
      #   "-DBUILD_DESIGNERPLUGIN" = false,

      # }
      symlinkBuldInputs | priority 1 = false,
      buildEnv = {
        EXTRA_LDFLAGS | priority 1 = _kf.buildEnv.EXTRA_LDFLAGS @ ["-lltdl"],
      }
    }
  ),

  kded | lib.CmakePackage = (
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kded-6.11.0.tar.xz",
        sha256sum = "55c9921114299abd9bdc5e601ccc6a750ff2d331fc0836d79670ccbc508e06a4"
      },
      biDrvs =
        _kf.biDrvs
        @ lib.biMap [
          kcoreaddons,
          kcodecs,
          kconfig,
          kguiaddons,
          ki18n,
          gettext,
          karchive,
          bzip2,
          kservice,
          kwidgetsaddons,
          kcolorscheme,
          kconfigwidgets,
          ksolid,
          utilLinuxWeak,
          kcrash,
          kbookmarks,
          kcompletion,
          kiconthemes,
          breezeIcons,
          kitemviews,
          kjobwidgets,
          knotifications,
          vala,
          libtool,
          libogg,
          libvorbis,
          libcanberra,
          kwindowsystem,
          kauth,
          kdbusaddons,
        ],

      cmakeExtraArgsRecord = {
        "-DBUILD_TESTING" = false,
        "-DBUILD_DESIGNERPLUGIN" = false,
      }
    }
  ),

  knotifications | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/knotifications-6.11.0.tar.xz",
        sha256sum = "a2e0815ea6e5c294fdd36316ca9792a406f5c123ec01a1c73a7e54cb0be2ea31"
      },
      biDrvs =
        _kf.biDrvs
        @ lib.biMap [
          kcoreaddons,
          kcodecs,
          kconfig,
          kguiaddons,
          ki18n,
          gettext,
          vala,
          libtool,
          libogg,
          libvorbis,
          libcanberra,
          kwidgetsaddons,
          kcolorscheme,
          kconfigwidgets,
        ],

      buildEnv = {
        EXTRA_LDFLAGS | priority 1 = _kf.buildEnv.EXTRA_LDFLAGS @ ["-lltdl"],
      }
    },

  kiconthemes | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kiconthemes-6.11.0.tar.xz",
        sha256sum = "1671ab3fd9b1e0753a7062bab80f5489f3ac750ecb30b91db99a6689988afb87"
      },
      biDrvs =
        _kf.biDrvs
        @ lib.biMap [
          kcoreaddons,
          kcodecs,
          kconfig,
          kguiaddons,
          ki18n,
          gettext,
          karchive,
          bzip2,
          kconfigwidgets,
          kwidgetsaddons,
          kcolorscheme,
          breezeIcons,
        ],

      cmakeExtraArgsRecord = {
        "-DBUILD_TESTING" = false,
        "-DBUILD_DESIGNERPLUGIN" = false,
      },
      preConfigurePhase = [
        "sed -i 's@ MODULE @ @g' ${SRC}/src/CMakeLists.txt",
      ]
    },

  ksolid | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/solid-6.11.0.tar.xz",
        sha256sum = "cdecc7665b801a508b9ad0929b025ac93fe287be503589c8d8c38a520c2508d7"
      },
      biDrvs =
        _kf.biDrvs
        @ lib.biMap [
          kcoreaddons,
          kcodecs,
          kconfig,
          kguiaddons,
          ki18n,
          gettext,
          karchive,
          bzip2,
          kconfigwidgets,
          utilLinuxWeak,
        ],
      buildEnv = {
        EXTRA_LDFLAGS | priority 1 = _kf.buildEnv.EXTRA_LDFLAGS @ ["-lblkid"],
      }
    },
  kcmutils | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kcmutils-6.11.0.tar.xz",
        sha256sum = "64d2c5cd8165189c2d741bb543aab72b5bc8db5c540ca4e88c2f8d0f93e77990"
      },
      biDrvs =
        _kf.biDrvs
        @ lib.biMap [
          kcoreaddons,
          kcodecs,
          kconfig,
          kguiaddons,
          ki18n,
          gettext,
          kio,
          libtool,
        ],
    },
  kbookmarks | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kbookmarks-6.11.0.tar.xz",
        sha256sum = "b5c677453c70314b9eecc0011a73103f045eabc94bc5f2f223b5979780c801c7"
      },
      biDrvs =
        _kf.biDrvs
        @ lib.biMap [
          kcoreaddons,
          kcodecs,
          kconfig,
          kguiaddons,
          ki18n,
          gettext,
          karchive,
          bzip2,
          kservice,
          kwidgetsaddons,
          kcolorscheme,
          kconfigwidgets,
        ]
    },

  kcompletion | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kcompletion-6.11.0.tar.xz",
        sha256sum = "c812b60de4530de3003916e45fbab121c5f9f576e2430ab2cdf0e3e4c9041852"
      },
      biDrvs =
        _kf.biDrvs
        @ lib.biMap [
          kcoreaddons,
          kcodecs,
          kconfig,
          kguiaddons,
          ki18n,
          gettext,
          karchive,
          bzip2,
          kservice,
          kwidgetsaddons,
          kcolorscheme,
          kconfigwidgets,
        ],
      cmakeExtraArgsRecord = {
        "-DBUILD_TESTING" = false,
        "-DBUILD_DESIGNERPLUGIN" = false,
      }
    },

  kitemviews | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kitemviews-6.11.0.tar.xz",
        sha256sum = "e3625368e3f8cf6127218cc3e847fbf0176a5978c86228b11a320ad96fea2cbc"
      },
      biDrvs =
        _kf.biDrvs
        @ lib.biMap [
          kcoreaddons,
          kcodecs,
          kconfig,
          kguiaddons,
          ki18n,
          gettext,
          karchive,
          bzip2,
          kservice,
          kwidgetsaddons,
          kcolorscheme,
          kconfigwidgets,
        ],

      cmakeExtraArgsRecord = {
        "-DBUILD_TESTING" = false,
        "-DBUILD_DESIGNERPLUGIN" = false,
      },
    },

  kjobwidgets | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kjobwidgets-6.11.0.tar.xz",
        sha256sum = "2bb342e554f8ecf84d7218a6567628dcc73c1b914d0c5aad1c8bf7753986ddd7"
      },
      biDrvs =
        _kf.biDrvs
        @ lib.biMap [
          kcoreaddons,
          kcodecs,
          kconfig,
          kguiaddons,
          ki18n,
          gettext,
          karchive,
          bzip2,
          kservice,
          kwidgetsaddons,
          kcolorscheme,
          kconfigwidgets,
          knotifications,
          vala,
          libtool,
          libogg,
          libvorbis,
          libcanberra,
        ],

      cmakeExtraArgsRecord = {
        "-DBUILD_TESTING" = false,
        "-DBUILD_DESIGNERPLUGIN" = false,
        "-DWITH_X11" = false,
      },
    },

  karchive | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/karchive-6.11.0.tar.xz",
        sha256sum = "12fc4ac53591fb1dd81d6c5243b900a6d48066559263fc66eb2f4995ceb9e380"
      },
      biDrvs =
        _kf.biDrvs
        @ lib.biMap [
          kcoreaddons,
          bzip2,
        ]
    },

  kcodecs | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kcodecs-6.11.0.tar.xz",
        sha256sum = "fbddc437ba9969d89635b75f0ef7e41c925c61c64dac1fff008c2e9138139fe4"
      },
      biDrvs =
        _kf.biDrvs
        @ lib.biMap [
          kcoreaddons,
          gperf
        ]
    },
  ki18n | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/ki18n-6.11.0.tar.xz",
        sha256sum = "658a05ceca184ba31ce58a6e9c51ee76f2829459c56dbcd3bad3aa157eaf11fe"
      },
      biDrvs =
        _kf.biDrvs
        @ lib.biMap [
          kcoreaddons,
          gperf,
          isoCodes,
          pythonFull,
          gettext,
        ]
    },

  kguiaddons | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kguiaddons-6.11.0.tar.xz",
        sha256sum = "ef0925f609ae5b62ed689451dfe9937719ce4ec26714952b5496e3e128d5cc5c"
      },
      biDrvs =
        _kf.biDrvs
        @ lib.biMap [
          kcoreaddons,
          plasmaWaylandProtocols,
        ],
      cmakeExtraArgsRecord = {
        "-DWITH_X11" = false,
      }
    },
  waylandWeaksyms,

  kwindowsystem | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/kwindowsystem-6.11.0.tar.xz",
        sha256sum = "d872e85d0915dd5cf1e2baf89fbef62e9855ff3317ecc5939882bc1724628d5a"
      },
      options.waylandSyms = true,
      biDrvs =
        (std.array.filter (fun x => (x.name != "wayland")) _kf.biDrvs)
        @ lib.biMap [
          kcoreaddons,
          plasmaWaylandProtocols,
          waylandWeaksyms,
        ],
      cmakeExtraArgsRecord = {
        "-DKWINDOWSYSTEM_X11" = false,
      },
      preConfigurePhase = [
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
      biDrvs =
        _kf.biDrvs
        @ lib.biMap [
          kcoreaddons
        ],
      cmakeExtraArgsRecord = {
        "-DBUILD_TESTING" = false,
        "-DKAUTH_BUILD_CODEGENERATOR_ONLY" = false,
      },
      preConfigurePhase = [
        "sed -i 's@ MODULE @ @g' ${SRC}/src/CMakeLists.txt"
      ]
    },

  gperf,
  isoCodes,
  pythonFull,

  breezeIcons | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.11/breeze-icons-6.11.0.tar.xz",
        sha256sum = "f9cd9ec1b6a4111467cba31a7eed50ee5f03846fb1f5c32b3abdbf68877f8a4e",
      },
      biDrvs =
        _kf.biDrvs
        @ lib.biMap [
          kcoreaddons,
          gperf,
          isoCodes,
          pythonFull,
          gettext,
        ]
    },

  plasmaWaylandProtocols | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/plasma-wayland-protocols/plasma-wayland-protocols-1.16.0.tar.xz",
        sha256sum = "da3fbbe3fa5603f9dc9aabe948a6fc8c3b451edd1958138628e96c83649c1f16"
      },
      biDrvs =
        _kf.biDrvs
        @ lib.biMap [
          kcoreaddons
        ],
    },
}
& {
  lib,

  utilLinux,
  utilLinuxWeak | lib.AutotoolsPackage =
    utilLinux
    & {
      postInstallPhase | priority 1 =
        utilLinux.postInstallPhase
        @ [
          "objcopy -W strappend ${DEST}/usr/lib/libmount.a",
          "objcopy -W split ${DEST}/usr/lib/libmount.a",
          "objcopy -W strappend ${DEST}/usr/lib/libblkid.a",
          "objcopy -W split ${DEST}/usr/lib/libblkid.a",
        ]
    }
}
& {
  lib,
  glib,
  pcre2,
  libffi,
  zlibNg,
  gudev,
  eudev,

  switcherooControl | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/hadess/switcheroo-control/-/archive/2.6/switcheroo-control-2.6.tar.gz",
      sha256sum = "b6413630b346aa132fb27ff1ee890061d3e86e0db42a991efe50b98eafd478b7"
    },
    biDrvs =
      lib.biMap [
        glib,
        pcre2,
        libffi,
        zlibNg,
        gudev,
        eudev,
      ],

    extraMesonArgs = [
      "-Dsystemdsystemunitdir=no"
    ]
  }
}
