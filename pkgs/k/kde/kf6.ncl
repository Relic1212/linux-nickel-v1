{
  lib,
  drvs,
  _kf | lib.CmakePackage = {
    generator = "Ninja",

    llvmProvider = drvs.llvmFull,
    symlinkBuldInputs = true,

    options = {
      waylandSyms = false,
    },

    biDrvs | priority -2 =
      [
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
        # drvs.harfbuzz,
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
        drvs.harfbuzzFull,
      ]
      @ (
        if options.waylandSyms then
          [
            drvs.waylandWeaksyms
          ]
        else
          [
            drvs.wayland
          ]
      )
      @ [
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
        "$(pkg-config --libs --static gbm glesv2 egl dri wayland-client glib-2.0 gmodule-2.0 expat)",
      ]
    },
    cmakeExtraArgsRecord = {
      "-DCMAKE_MODULE_LINKER_FLAGS:STRING" = "\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -lglapi -ldrm $(pkg-config --libs --static dri glesv2 gbm egl wayland-client glib-2.0 gmodule-2.0 expat)\"",

      #"-DCMAKE_MODULE_LINKER_FLAGS:STRING" = "\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -lglapi -ldrm $(pkg-config --libs --static dri glesv2 gbm egl wayland-client)\""
    },
  }
}
& {
  lib,
  drvs,
  _kf,
  kconfig =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.16/kconfig-6.16.0.tar.xz",
        sha256sum = "ba6cc58f025fef9525bc640f7967b7c09053b592c42368e096d97a94661a3525"
      },
    },
  kcoreaddons =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.16/kcoreaddons-6.16.0.tar.xz",
        sha256sum = "798a2744c296d13b216eadd7e5d801a6fd6956944a2147ab2830c399930ae2a0"
      },
      cmakeExtraArgsRecord = {
        "-DBUILD_TESTING" = false,
      }
    },

  kglobalaccel =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.16/kglobalaccel-6.16.0.tar.xz",
        sha256sum = "6663461a82798b5dccb9f44e91c0c37e12c951f87e295c3ba7f465dac7bd4aa1"
      },
      biDrvs =
        _kf.biDrvs
        @ [
          drvs.kcoreaddons
        ],
      cmakeExtraArgsRecord = {
        "-DBUILD_TESTING" = false,
        "-DWITH_X11" = false,
      }
    },

  kpackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.16/kpackage-6.16.0.tar.xz",
        sha256sum = "a45fce1026db3b65cdd1dd0e11374808e2686914a062f6644ebaa8ed308ee3cb"
      },
      biDrvs =
        _kf.biDrvs
        @ [
          drvs.kcoreaddons,
          drvs.karchive,
          drvs.bzip2,
          drvs.ki18n,
          drvs.gettext
        ],
      preConfigurePhase = [
        m%"sed -i 's@NOT BUILD_SHARED_LIBS@FALSE@g' ${SRC}/src/kpackage/CMakeLists.txt"%,
      ],
      # patches = [
      #   {
      #     sha256sum = "e3bee168feb7c615f984b3af01fd7712fdb2774c7851cf601998f4d037dfe622",
      #     file = "kpackage-no-common.patch",
      #   }
      # ]
    },
  kdoctools =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.16/kdoctools-6.16.0.tar.xz",
        sha256sum = "5c0c531a7978650f593a63a2aba1a641d590537e74c644aa361c63584b115aa2"
      },
      biDrvs =
        _kf.biDrvs
        @ [
          drvs.kcoreaddons,
          drvs.karchive,
          drvs.bzip2,
          drvs.ki18n,
          drvs.gettext,
        ]
    },

  kidletime =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.16/kidletime-6.16.0.tar.xz",
        sha256sum = "57a7a40d7093d7a6697f9a43ff55cbcb2629ec5d28ece4a37aa4000efaa61b2d"
      },
      biDrvs =
        _kf.biDrvs
        @ [
          drvs.kcoreaddons,
          drvs.plasmaWaylandProtocols,
          drvs.libxml2,
          drvs.libxslt,
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

  kcrash =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.16/kcrash-6.16.0.tar.xz",
        sha256sum = "06e3a109ba597a395154330250495c3e03a774b7d6f213a352789ad9c3691dc3"
      },
      biDrvs =
        _kf.biDrvs
        @ [
          drvs.kcoreaddons
        ],
      cmakeExtraArgsRecord = {
        "-DWITH_X11" = false,
      }
    },

  kservice =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.16/kservice-6.16.0.tar.xz",
        sha256sum = "ee5ec9ea9315a9d1e52d3e6de1db8bb8f3d945c4260a8523cbe34897b1cc081e"
      },
      biDrvs =
        _kf.biDrvs
        @ [
          drvs.kcoreaddons,
          drvs.kconfig,
          drvs.ki18n,
          drvs.gettext,
        ]
    },

  ksvg =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.16/ksvg-6.16.0.tar.xz",
        sha256sum = "ee3bf0726e84137c131ccd5c61c17f08edc0c0d8e9fa27d26cd3a4524f5cf6c3"
      },
      biDrvs =
        _kf.biDrvs
        @ [
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

  kirigami =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.16/kirigami-6.16.0.tar.xz",
        sha256sum = "16d1142aacd8514f95cf9bdb44b2a720f3397b5ee68a489a54c86a560af55516"
      },
      biDrvs =
        _kf.biDrvs
        @ [
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

  kdbusaddons =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.16/kdbusaddons-6.16.0.tar.xz",
        sha256sum = "3ba1b9628483a38a13b7bce6aac0ae2d6f116f62601930786e254da4dfd5d145"
      },
      cmakeExtraArgsRecord = {
        "-DWITH_X11" = false,
      }
    },

  kcolorscheme =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.16/kcolorscheme-6.16.0.tar.xz",
        sha256sum = "46026d0a3d522943389fa3ef66a129d9fc76e5e6295c84f817d12baaa2687303"
      },
      biDrvs =
        _kf.biDrvs
        @ [
          drvs.kcoreaddons,
          drvs.kconfig,
          drvs.plasmaWaylandProtocols,
          drvs.kguiaddons,
          drvs.ki18n,
          drvs.gettext,
        ]
    },

  kconfigwidgets =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.16/kconfigwidgets-6.16.0.tar.xz",
        sha256sum = "61c0256fdae049b12586bd1e0d931e80515d3c702f1785a88994ee54eee2d5c5"
      },
      biDrvs =
        _kf.biDrvs
        @ [
          drvs.kcoreaddons,
          drvs.kcodecs,
          drvs.kconfig,
          drvs.kguiaddons,
          drvs.ki18n,
          drvs.gettext,
          drvs.kwidgetsaddons,
          drvs.kcolorscheme,
        ],
      cmakeExtraArgsRecord = {
        "-DBUILD_TESTING" = false,
        "-DBUILD_DESIGNERPLUGIN" = false,
      }
    },

  kwidgetsaddons =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.16/kwidgetsaddons-6.16.0.tar.xz",
        sha256sum = "7663f88052fd8ca947b9fe0bbead04ff228e884f124498a328cc30e9f172915c"
      },
      biDrvs =
        _kf.biDrvs
        @ [
          drvs.kcoreaddons,
          drvs.kcodecs,
          drvs.kconfig,
          drvs.kguiaddons,
          drvs.ki18n,
          drvs.gettext,
        ],
      cmakeExtraArgsRecord = {
        "-DBUILD_TESTING:BOOL" = "OFF",
        "-DBUILD_DESIGNERPLUGIN:BOOL" = "OFF",
      }
    },

  kio = (
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.16/kio-6.16.0.tar.xz",
        sha256sum = "675ebf8a0c72bfdfd434ef73530cb7ae92127aeff0968896d67cc5aa22333e8c"
      },
      biDrvs =
        _kf.biDrvs
        @ [
          drvs.acl,
          drvs.attr,
          drvs.breezeIcons,
          drvs.bzip2,
          drvs.gettext,
          drvs.karchive,
          drvs.kauth,
          drvs.kbookmarks,
          drvs.kcodecs,
          drvs.kcolorscheme,
          drvs.kcompletion,
          drvs.kconfig,
          drvs.kconfigwidgets,
          drvs.kcoreaddons,
          drvs.kcrash,
          drvs.kdbusaddons,
          drvs.kded,
          drvs.kglobalaccel,
          drvs.kguiaddons,
          drvs.ki18n,
          drvs.kiconthemes,
          drvs.kidletime,
          drvs.kirigami,
          drvs.kitemviews,
          drvs.kjobwidgets,
          drvs.knotifications,
          drvs.kpackage,
          drvs.kservice,
          drvs.ksolid,
          drvs.ksvg,
          drvs.kwidgetsaddons,
          drvs.kwindowsystem,
          drvs.libcanberra,
          drvs.libogg,
          drvs.libtool,
          drvs.libvorbis,
          drvs.plasmaWaylandProtocols,
          drvs.switcherooControl,
          drvs.utilLinuxWeak,
          drvs.vala,
          drvs.kwallet,
          drvs.alsaLibs,
        ],

      cmakeExtraArgsRecord = {
        # "-DBUILD_TESTING" = false,
        # "-DBUILD_DESIGNERPLUGIN" = false,
        "-DBUILD_TESTING" = false,
        "-DCMAKE_MODULE_LINKER_FLAGS:STRING" | priority 1 = "\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -lglapi -ldrm $(pkg-config --libs --static dri glesv2 gbm egl wayland-client glib-2.0 gmodule-2.0 expat gpgme libcanberra vorbisfile)\"",
      },
      # symlinkBuldInputs | priority 1 = false,
      # buildEnv = {
      #   EXTRA_LDFLAGS | priority 1 = _kf.buildEnv.EXTRA_LDFLAGS @ ["-lltdl"],
      # },

      buildEnv = {
        EXTRA_LDFLAGS | priority 1 = [
          "$(pkg-config --libs --static gbm glesv2 egl dri wayland-client glib-2.0 gmodule-2.0 expat gpgme libcanberra vorbisfile)",
        ]
      },
      patches = [
        {
          file = "0001-kio.patch",
          sha256sum = "3c6f7893391fc6e03eb65cb450c401af635139d17c5c22e85d4a343bd0c2cf08"
        }
      ]
    }
  ),

  kded = (
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.16/kded-6.16.0.tar.xz",
        sha256sum = "49372fb01dd53c25b2789603ed6ae85fe54a712ed7f7426c884d075d31381b2a"
      },
      biDrvs =
        _kf.biDrvs
        @ [
          drvs.kcoreaddons,
          drvs.kcodecs,
          drvs.kconfig,
          drvs.kguiaddons,
          drvs.ki18n,
          drvs.gettext,
          drvs.karchive,
          drvs.bzip2,
          drvs.kservice,
          drvs.kwidgetsaddons,
          drvs.kcolorscheme,
          drvs.kconfigwidgets,
          drvs.ksolid,
          drvs.utilLinuxWeak,
          drvs.kcrash,
          drvs.kbookmarks,
          drvs.kcompletion,
          drvs.kiconthemes,
          drvs.breezeIcons,
          drvs.kitemviews,
          drvs.kjobwidgets,
          drvs.knotifications,
          drvs.vala,
          drvs.libtool,
          drvs.libogg,
          drvs.libvorbis,
          drvs.libcanberra,
          drvs.kwindowsystem,
          drvs.kauth,
          drvs.kdbusaddons,
        ],

      cmakeExtraArgsRecord = {
        "-DBUILD_TESTING" = false,
        "-DBUILD_DESIGNERPLUGIN" = false,
      }
    }
  ),

  knotifications =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.16/knotifications-6.16.0.tar.xz",
        sha256sum = "423da41059657a496345e9d7528ab0e0dde53f678160f2fae2cbbc583ca93b9f"
      },
      biDrvs =
        _kf.biDrvs
        @ [
          drvs.kcoreaddons,
          drvs.kcodecs,
          drvs.kconfig,
          drvs.kguiaddons,
          drvs.ki18n,
          drvs.gettext,
          drvs.vala,
          drvs.libtool,
          drvs.libogg,
          drvs.libvorbis,
          drvs.libcanberra,
          drvs.kwidgetsaddons,
          drvs.kcolorscheme,
          drvs.kconfigwidgets,
        ],

      buildEnv = {
        EXTRA_LDFLAGS | priority 1 = _kf.buildEnv.EXTRA_LDFLAGS @ ["-lltdl"],
      },
      cmakeExtraArgsRecord = {
        "-DBUILD_TESTING" = false,
      },
    },

  kiconthemes =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.16/kiconthemes-6.16.0.tar.xz",
        sha256sum = "a73a2976cc49361c8fa0c612f53ca81afcf2c74a6c4d55ac8a2916f57d07e402"
      },
      biDrvs =
        _kf.biDrvs
        @ [
          drvs.kcoreaddons,
          drvs.kcodecs,
          drvs.kconfig,
          drvs.kguiaddons,
          drvs.ki18n,
          drvs.gettext,
          drvs.karchive,
          drvs.bzip2,
          drvs.kconfigwidgets,
          drvs.kwidgetsaddons,
          drvs.kcolorscheme,
          drvs.breezeIcons,
        ],

      cmakeExtraArgsRecord = {
        "-DBUILD_TESTING" = false,
        "-DBUILD_DESIGNERPLUGIN" = false,
      },
      preConfigurePhase = [
        "sed -i 's@ MODULE @ @g' ${SRC}/src/CMakeLists.txt",
      ]
    },

  ksolid =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.16/solid-6.16.0.tar.xz",
        sha256sum = "00ec609d799335bafb97b6a7d4a5c061ab4a0eb10e4089e8e104942321beb8a0"
      },
      biDrvs =
        _kf.biDrvs
        @ [
          drvs.kcoreaddons,
          drvs.kcodecs,
          drvs.kconfig,
          drvs.kguiaddons,
          drvs.ki18n,
          drvs.gettext,
          drvs.karchive,
          drvs.bzip2,
          drvs.kconfigwidgets,
          drvs.utilLinuxWeak,
        ],
      buildEnv = {
        EXTRA_LDFLAGS | priority 1 = _kf.buildEnv.EXTRA_LDFLAGS @ ["-lblkid"],
      }
    },
  kcmutils =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.16/kcmutils-6.16.0.tar.xz",
        sha256sum = "403f5eb3288ffbbc64cb6741048007dde82be390da2c50ba147cb474921e3344"
      },
      biDrvs =
        _kf.biDrvs
        @ [
          drvs.kcoreaddons,
          drvs.kcodecs,
          drvs.kconfig,
          drvs.kguiaddons,
          drvs.ki18n,
          drvs.gettext,
          drvs.kio,
          drvs.libtool,
        ],
    },
  kbookmarks =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.16/kbookmarks-6.16.0.tar.xz",
        sha256sum = "ca4656ad49add524b4b68bc286071a5ae47f83ec46a1fd8e0c3713d70ad6adb5"
      },
      biDrvs =
        _kf.biDrvs
        @ [
          drvs.kcoreaddons,
          drvs.kcodecs,
          drvs.kconfig,
          drvs.kguiaddons,
          drvs.ki18n,
          drvs.gettext,
          drvs.karchive,
          drvs.bzip2,
          drvs.kservice,
          drvs.kwidgetsaddons,
          drvs.kcolorscheme,
          drvs.kconfigwidgets,
        ]
    },

  kcompletion =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.16/kcompletion-6.16.0.tar.xz",
        sha256sum = "3f71d7f24ca704529322eead7d2132331e9461eb91ab489d6e3d990d9d7ca133"
      },
      biDrvs =
        _kf.biDrvs
        @ [
          drvs.kcoreaddons,
          drvs.kcodecs,
          drvs.kconfig,
          drvs.kguiaddons,
          drvs.ki18n,
          drvs.gettext,
          drvs.karchive,
          drvs.bzip2,
          drvs.kservice,
          drvs.kwidgetsaddons,
          drvs.kcolorscheme,
          drvs.kconfigwidgets,
        ],
      cmakeExtraArgsRecord = {
        "-DBUILD_TESTING" = false,
        "-DBUILD_DESIGNERPLUGIN" = false,
      }
    },

  kitemviews =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.16/kitemviews-6.16.0.tar.xz",
        sha256sum = "c45541d85ec1b06d160b819c03f073cf001a60411f1d45706a611d9eab9214dd"
      },
      biDrvs =
        _kf.biDrvs
        @ [
          drvs.kcoreaddons,
          drvs.kcodecs,
          drvs.kconfig,
          drvs.kguiaddons,
          drvs.ki18n,
          drvs.gettext,
          drvs.karchive,
          drvs.bzip2,
          drvs.kservice,
          drvs.kwidgetsaddons,
          drvs.kcolorscheme,
          drvs.kconfigwidgets,
        ],

      cmakeExtraArgsRecord = {
        "-DBUILD_TESTING" = false,
        "-DBUILD_DESIGNERPLUGIN" = false,
      },
    },

  kjobwidgets =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.16/kjobwidgets-6.16.0.tar.xz",
        sha256sum = "517703f0188ec7dd759af38da2c0322ee2a7631225189853626af9aff0b94b2a"
      },
      biDrvs =
        _kf.biDrvs
        @ [
          drvs.kcoreaddons,
          drvs.kcodecs,
          drvs.kconfig,
          drvs.kguiaddons,
          drvs.ki18n,
          drvs.gettext,
          drvs.karchive,
          drvs.bzip2,
          drvs.kservice,
          drvs.kwidgetsaddons,
          drvs.kcolorscheme,
          drvs.kconfigwidgets,
          drvs.knotifications,
          drvs.vala,
          drvs.libtool,
          drvs.libogg,
          drvs.libvorbis,
          drvs.libcanberra,
        ],

      cmakeExtraArgsRecord = {
        "-DBUILD_TESTING" = false,
        "-DBUILD_DESIGNERPLUGIN" = false,
        "-DWITH_X11" = false,
      },
    },

  karchive =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.16/karchive-6.16.0.tar.xz",
        sha256sum = "dba18ff2be1d0b57a1812a33de660d4cf7623dcfaa8f9c0d64efde2152409cff"
      },
      biDrvs =
        _kf.biDrvs
        @ [
          drvs.kcoreaddons,
          drvs.bzip2,
        ]
    },

  kcodecs =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.16/kcodecs-6.16.0.tar.xz",
        sha256sum = "d8d23cdc853aa832bf39886c6b673fee87279e258cf01abeb0acfea5f718e595"
      },
      biDrvs =
        _kf.biDrvs
        @ [
          drvs.kcoreaddons,
          drvs.gperf
        ]
    },
  ki18n =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.16/ki18n-6.16.0.tar.xz",
        sha256sum = "c52ad10b14365e60c4a219cb66706d114476645297cb2a9f15498747cf4421d7"
      },
      biDrvs =
        _kf.biDrvs
        @ [
          drvs.kcoreaddons,
          drvs.gperf,
          drvs.isoCodes,
          drvs.pythonFull,
          drvs.gettext,
        ]
    },

  kguiaddons =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.16/kguiaddons-6.16.0.tar.xz",
        sha256sum = "9e1d53a4fbe1eb7ccc10610a1737d9b2560756f89bf650940a74356daa7db2e2"
      },
      biDrvs =
        _kf.biDrvs
        @ [
          drvs.kcoreaddons,
          drvs.plasmaWaylandProtocols,
        ],
      cmakeExtraArgsRecord = {
        "-DWITH_X11" = false,
      }
    },

  kwindowsystem =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.16/kwindowsystem-6.16.0.tar.xz",
        sha256sum = "dc3b5ac5e5eaea5b76af8e85f065ddbce91ff7e3fcc13c6d600ad53bb53b1b31"
      },
      options.waylandSyms = true,
      biDrvs =
        (std.array.filter (fun x => (x.name != "wayland")) _kf.biDrvs)
        @ [
          drvs.kcoreaddons,
          drvs.plasmaWaylandProtocols,
          drvs.waylandWeaksyms,
        ],
      cmakeExtraArgsRecord = {
        "-DKWINDOWSYSTEM_X11" = false,
      },
      preConfigurePhase = [
        "sed -i 's@MODULE@STATIC@g' ${SRC}/src/platforms/wayland/CMakeLists.txt"
      ]
    },

  kauth =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.16/kauth-6.16.0.tar.xz",
        sha256sum = "04f3e84fda5e8ceb7f100266e3569a34e8289b1046af4ec750599efad6034963"
      },
      biDrvs =
        _kf.biDrvs
        @ [
          drvs.kcoreaddons
        ],
      cmakeExtraArgsRecord = {
        "-DBUILD_TESTING" = false,
        "-DKAUTH_BUILD_CODEGENERATOR_ONLY" = false,
      },
      preConfigurePhase = [
        "sed -i 's@ MODULE @ @g' ${SRC}/src/CMakeLists.txt"
      ]
    },

  breezeIcons =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/frameworks/6.16/breeze-icons-6.16.0.tar.xz",
        sha256sum = "946e793b674126db984e2f783be4b348e9c68c2527d34ddd725f9cb0862936b4",
      },
      biDrvs =
        _kf.biDrvs
        @ [
          drvs.kcoreaddons,
          drvs.gperf,
          drvs.isoCodes,
          drvs.pythonFull,
          drvs.gettext,
        ]
    },

  plasmaWaylandProtocols =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/plasma-wayland-protocols/plasma-wayland-protocols-1.16.0.tar.xz",
        sha256sum = "da3fbbe3fa5603f9dc9aabe948a6fc8c3b451edd1958138628e96c83649c1f16"
      },
      biDrvs =
        _kf.biDrvs
        @ [
          drvs.kcoreaddons
        ],
    },
}
& {
  lib,
  drvs,
  utilLinux,
  utilLinuxWeak =
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
  drvs,
  switcherooControl | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/hadess/switcheroo-control/-/archive/2.6/switcheroo-control-2.6.tar.gz",
      sha256sum = "b6413630b346aa132fb27ff1ee890061d3e86e0db42a991efe50b98eafd478b7"
    },
    biDrvs = [
      drvs.glib,
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.gudev,
      drvs.eudev,
    ],

    extraMesonArgs = [
      "-Dsystemdsystemunitdir=no"
    ]
  }
}
