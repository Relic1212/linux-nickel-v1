{
  lib,
  drvs,
  _kf,

  _plasma_sources = (import "./_plasma_sources.ncl"),

  _plasma = (
    _kf
    & {

      name,
      singleSource | priority -999 =
        let version = "6.5.2" in
        {
          uri = "https://download.kde.org/stable/plasma/%{version}/%{name}-%{version}.tar.xz",
          # uri = "https://download.kde.org/stable/plasma/6.4.5/%{name}-6.4.5.tar.xz",
          sha256sum = _plasma_sources."%{uri}",
        },

      biDrvs | priority -1 =
        _kf.biDrvs
        @ [
          drvs.gettext,
          drvs.karchive,
          drvs.kauth,
          drvs.kcmutils,
          drvs.kcodecs,
          drvs.kcolorscheme,
          drvs.kconfig,
          drvs.kcoreaddons,
          drvs.kcrash,
          drvs.kdbusaddons,
          drvs.kglobalaccel,
          drvs.kguiaddons,
          drvs.ki18n,
          drvs.kiconthemes,
          drvs.kidletime,
          drvs.kio,
          drvs.kirigami,
          drvs.knotifications,
          drvs.kpackage,
          drvs.kservice,
          drvs.ksvg,
          drvs.kwidgetsaddons,
          drvs.kwindowsystem,
          drvs.plasmaWaylandProtocols,
        ]
    }
  ),

  kdecoration =
    _plasma
    & {
      # singleSource = {
      #   uri = "https://download.kde.org/stable/plasma/6.4.3/kdecoration-6.4.3.tar.xz",
      #   sha256sum = "65672b9bd00d1c2d18ff028b028eb8054bc476d645e25afa7dc28add4301e10b"
      # },
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

      preConfigurePhase = [
        "sed -i 's@ SHARED@@g' ${SRC}/src/private/CMakeLists.txt",
        "sed -i 's@ SHARED@@g' ${SRC}/src/CMakeLists.txt",
      ]
    },

  kwayland =
    _plasma
    & {},
  kglobalacceld =
    _plasma
    & {
      cmakeExtraArgsRecord = {
        "-DWITH_X11" = false,
      },
      preConfigurePhase = [
        m%"sed -i 's|find_package(KF6JobWidgets ${KF6_MIN_VERSION} REQUIRED)|find_package(KF6Notifications ${KF6_MIN_VERSION} REQUIRED)\nfind_package(KF6JobWidgets ${KF6_MIN_VERSION} REQUIRED)|g' ${SRC}/CMakeLists.txt"%,
      ],
      buildEnv.EXTRA_LDFLAGS | priority 1 =
        _plasma.buildEnv.EXTRA_LDFLAGS
        @ [
          "$(pkg-config --libs --static alsa vorbis vorbisenc vorbisfile)",
        ],
      biDrvs =
        _plasma.biDrvs
        @ [
          drvs.utilLinuxWeak,
          drvs.kbookmarks,
          drvs.kcompletion,
          drvs.kitemviews,
          drvs.kjobwidgets,
          drvs.solid,
          drvs.bzip2,
          drvs.libcanberra,
          drvs.acl,
          drvs.attr,
          drvs.alsaLibs,
          drvs.libvorbis,
          drvs.libogg,
          drvs.libtool,
        ]
    },

  knighttime =
    _plasma
    & {
      biDrvs =
        _plasma.biDrvs
        @ [
          drvs.qtpositioning,
          drvs.kholidays,
        ]
    },

  plasmaActivities =
    _plasma
    & {
      #       singleSource = {
      #         uri = "https://download.kde.org/stable/plasma/6.4.3/plasma-activities-6.4.3.tar.xz",
      #         sha256sum = "aedd8bcbbb527f6a7da83d7cd72506608a486394805d9bf0037b2f899f0b7e53  plasma-activities-6.3.3.tar.xz
      # ",
      #       },

      # cmakeExtraArgsRecord = {
      #   "-DQT_NO_CREATE_VERSIONLESS_FUNCTIONS" = false
      # },
      preConfigurePhase = [
        m%"sed -i 's|qt_add_dbus_interface|qt6_add_dbus_interface|g' ${SRC}/src/lib/CMakeLists.txt"%
      ],
      biDrvs =
        _plasma.biDrvs
        @ [
          drvs.acl,
          drvs.alsaLibs,
          drvs.attr,
          drvs.boost,
          drvs.bzip2,
          drvs.kbookmarks,
          drvs.kcompletion,
          drvs.kitemviews,
          drvs.kjobwidgets,
          drvs.libcanberra,
          drvs.libogg,
          drvs.libtool,
          drvs.libvorbis,
          drvs.solid,
          drvs.utilLinuxWeak,
        ]
    },

  plasmaActivitiesStats =
    _plasma
    & {

      biDrvs =
        _plasma.biDrvs
        @ [
          drvs.acl,
          drvs.alsaLibs,
          drvs.attr,
          drvs.boost,
          drvs.bzip2,
          drvs.kbookmarks,
          drvs.kcompletion,
          drvs.kitemviews,
          drvs.kjobwidgets,
          drvs.libcanberra,
          drvs.libogg,
          drvs.libtool,
          drvs.libvorbis,
          drvs.solid,
          drvs.utilLinuxWeak,
          drvs.plasmaActivities,
        ]
    },

  libplasma =
    _plasma
    & {
      # singleSource = {
      #   uri = "https://download.kde.org/stable/plasma/6.4.3/libplasma-6.4.3.tar.xz",
      #   sha256sum = "c7afa64a9cc058515afb06dcb1d3f647904c2eea40bbae43540f9f02314488ac",
      # },
      cmakeExtraArgsRecord = {
        "-DWITHOUT_X11" = true
      },
      patches = [
        {
          sha256sum = "78de16567fec6f83a301968592bfcf31c09ebb4895b3555b067281609d60e4f1",
          file = "0001-libplasma.patch"
        }
      ],
      preConfigurePhase = [
        m%"sed -i 's|SHARED|STATIC|g' ${SRC}/src/plasmaquick/CMakeLists.txt"%,
        m%"sed -i 's|SHARED|STATIC|g' ${SRC}/templates/plasma6-wallpaper-with-qml-extension/plugin/CMakeLists.txt"%,
        m%"sed -i 's|SHARED|STATIC|g' ${SRC}/PlasmaMacros.cmake"%,
        m%"sed -i 's|MODULE|STATIC|g' ${SRC}/src/declarativeimports/kirigamiplasmastyle/CMakeLists.txt"%,
      ],
      biDrvs =
        _plasma.biDrvs
        @ [
          drvs.acl,
          drvs.alsaLibs,
          drvs.attr,
          drvs.boost,
          drvs.breeze,
          drvs.breezeIcons,
          drvs.bzip2,
          drvs.kbookmarks,
          drvs.kcompletion,
          drvs.kconfigwidgets,
          drvs.kitemviews,
          drvs.kjobwidgets,
          drvs.kxmlgui,
          drvs.libcanberra,
          drvs.libogg,
          drvs.libtool,
          drvs.libvorbis,
          drvs.plasmaActivities,
          drvs.solid,
          drvs.utilLinuxWeak,
          drvs.libxcb,
        ]
    },

  breeze =
    _plasma
    & {
      # singleSource = {
      #   uri = "https://download.kde.org/stable/plasma/6.4.3/breeze-6.4.3.tar.xz",
      #   sha256sum = "e07c95e26deb002a4b6f3422fc7cb8bd6df1d60a55064c92e9b17ff5a89796e4",
      # },
      cmakeExtraArgsRecord = {
        "-DBUILD_QT5" = false,

        # "-DWITH_DECORATIONS" = false,
      },
      preConfigurePhase = [
        m%"sed -i 's|MODULE|STATIC|g' ${SRC}/kdecoration/CMakeLists.txt"%,
        m%"sed -i 's|MODULE|STATIC|g' ${SRC}/kstyle/CMakeLists.txt"%,
      ],
      biDrvs =
        _plasma.biDrvs
        @ [
          drvs.acl,
          drvs.alsaLibs,
          drvs.attr,
          drvs.boost,
          drvs.breezeIcons,
          drvs.bzip2,
          drvs.kbookmarks,
          drvs.kcompletion,
          drvs.kconfigwidgets,
          drvs.kdecoration,
          drvs.kitemviews,
          drvs.kjobwidgets,
          drvs.kxmlgui,
          drvs.libcanberra,
          drvs.libogg,
          drvs.libtool,
          drvs.libvorbis,
          drvs.solid,
          drvs.utilLinuxWeak,
        ]
    },

  plasma5support =
    _plasma
    & {
      cmakeExtraArgsRecord = {
        "-DWITH_X11" = false,
      },

      preConfigurePhase = [
        m%"sed -i 's| SHARED| STATIC|g' ${SRC}/src/dataengines/weather/ions/CMakeLists.txt"%,
        m%"for f in $(find ${SRC} -type f -name CMakeLists.txt);do sed -i 's| MODULE| STATIC|g' ${f};done"%,
      ],
      biDrvs =
        _plasma.biDrvs
        @ [
          drvs.solid,
          drvs.kholidays,
          drvs.kunitconversion,
          drvs.utilLinuxWeak,
          drvs.libcanberra,
          drvs.kbookmarks,
          drvs.kcompletion,
          drvs.kitemviews,
          drvs.kjobwidgets,
          drvs.bzip2,
          drvs.breezeIcons,
          drvs.plasmaActivities,
          drvs.acl,
          drvs.attr,
        ]
    },

  kscreen =
    _plasma
    & {
      biDrvs =
        _plasma.biDrvs
        @ [
          drvs.solid,
          drvs.kholidays,
          drvs.kunitconversion,
          drvs.utilLinuxWeak,
          drvs.libcanberra,
          drvs.kbookmarks,
          drvs.kcompletion,
          drvs.kitemviews,
          drvs.kjobwidgets,
          drvs.bzip2,
          drvs.breezeIcons,
          drvs.plasmaActivities,
          drvs.acl,
          drvs.attr,
          drvs.kconfigwidgets,
          drvs.kxmlgui,
          drvs.libxcb,
          drvs.libkscreen,
          drvs.libplasma,
        ]
    },
  libksysguard =
    _plasma
    & {
      preConfigurePhase = [
        m%"sed -i 's|install(EXPORT libksysguardLibraryTargets|install(TARGETS dbusinterface Formatter_resources_1 processcore_resources_1 SensorFaces_resources_1 SensorFaces_resources_2 Sensors_resources_1 EXPORT libksysguardLibraryTargets ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})\ninstall(EXPORT libksysguardLibraryTargets|g' ${SRC}/CMakeLists.txt"%,
        m%"for f in $(find ${SRC} -type f -name CMakeLists.txt);do sed -i 's| MODULE| STATIC|g' ${f};done"%,
      ],
      biDrvs =
        _plasma.biDrvs
        @ [
          drvs.solid,
          drvs.kholidays,
          drvs.kunitconversion,
          drvs.utilLinuxWeak,
          drvs.libcanberra,
          drvs.kbookmarks,
          drvs.kcompletion,
          drvs.kitemviews,
          drvs.kjobwidgets,
          drvs.bzip2,
          drvs.breezeIcons,
          drvs.plasmaActivities,
          drvs.acl,
          drvs.attr,
          drvs.kconfigwidgets,
          drvs.kxmlgui,
          drvs.libxcb,
          drvs.libkscreen,
          drvs.libplasma,
          drvs.knewstuff,
          drvs.attica,
          drvs.libnl,
          drvs.lmSensors,
        ]
    },
  kscreenlocker =
    _plasma
    & {
      patches = [
        {
          sha256sum = "5e4b4dbc36700faabe5d32085e3c13c5b595fe14cedd7cba1afcca980944a194",

          file = "0001-kscreenlocker2.patch"
        }
      ],

      buildEnv = {
        EXTRA_LDFLAGS | priority 1 =
          _plasma.buildEnv.EXTRA_LDFLAGS
          @ [
            "-lcap",
            "-lpam_misc",
          ],
      },
      biDrvs =
        _plasma.biDrvs
        @ [
          drvs.solid,
          drvs.kholidays,
          drvs.kunitconversion,
          drvs.utilLinuxWeak,
          drvs.libcanberra,
          drvs.kbookmarks,
          drvs.kcompletion,
          drvs.kitemviews,
          drvs.kjobwidgets,
          drvs.bzip2,
          drvs.breezeIcons,
          drvs.plasmaActivities,
          drvs.acl,
          drvs.attr,
          drvs.kconfigwidgets,
          drvs.kxmlgui,
          drvs.libxcb,
          drvs.libkscreen,
          drvs.libplasma,
          drvs.xcbUtilKeysyms,
          drvs.layerShellQt,
          drvs.libpamFinalUdev,
          drvs.libx11,
          drvs.libxau,
          drvs.libxcursor,
          drvs.libxcvt,
          drvs.libxfixes,
          drvs.libxrender,
          drvs.xcbProto,
          drvs.xcbRenderutil,
          drvs.xorgMacros,
          drvs.xorgproto,
          drvs.xtrans,
          drvs.libcap,
        ]
    },

  libkscreen =
    _plasma
    & {
      # cmakeExtraArgs = {
      #   "-DCMAKE_DISABLE_FIND_PACKAGE_"
      # },
      preConfigurePhase = [
        m%"for f in $(find ${SRC} -type f -name CMakeLists.txt);do sed -i 's| SHARED| STATIC|g' ${f};done"%,
        m%"for f in $(find ${SRC} -type f -name CMakeLists.txt);do sed -i 's| MODULE| STATIC|g' ${f};done"%,
      ],

      patches = [
        {
          sha256sum = "d7f480c0dced2abc34aa2c879c198a5d5781ab70d28802d69dc0b80efd1a96b1",
          file = "0001-libkscreen.patch",
        }
      ],
      biDrvs =
        _plasma.biDrvs
        @ [
          drvs.solid,
          drvs.kholidays,
          drvs.kunitconversion,
          drvs.utilLinuxWeak,
          drvs.libcanberra,
          drvs.kbookmarks,
          drvs.kcompletion,
          drvs.kitemviews,
          drvs.kjobwidgets,
          drvs.bzip2,
          drvs.breezeIcons,
          drvs.plasmaActivities,
          drvs.acl,
          drvs.attr,
          drvs.kconfigwidgets,
          drvs.kxmlgui,
          drvs.libxcb,
        ]
    },

  layerShellQt =
    _plasma
    & {
      preConfigurePhase = [
        m%"for f in $(find ${SRC} -type f -name CMakeLists.txt);do sed -i 's| SHARED| STATIC|g' ${f};done"%,
        m%"for f in $(find ${SRC} -type f -name CMakeLists.txt);do sed -i 's| MODULE| STATIC|g' ${f};done"%,
      ],
      biDrvs =
        _plasma.biDrvs
        @ [
          drvs.solid,
          drvs.kholidays,
          drvs.kunitconversion,
          drvs.utilLinuxWeak,
          drvs.libcanberra,
          drvs.kbookmarks,
          drvs.kcompletion,
          drvs.kitemviews,
          drvs.kjobwidgets,
          drvs.bzip2,
          drvs.breezeIcons,
          drvs.plasmaActivities,
          drvs.acl,
          drvs.attr,
          drvs.kconfigwidgets,
          drvs.kxmlgui,
          drvs.libxcb,
        ]
    },
  plasmaWorkspace =
    _plasma
    & {
      singleSource,
      sourceInputs = [
        {
          src = singleSource
        },
        {
          src = {
            uri = "https://raw.githubusercontent.com/KDE/prison/c08826f0fc37b9a1e916d6abd73a42354727f7df/cmake/FindQRencode.cmake",
            sha256sum = "18997ffe9cf418c3f2d2225c59b54ef3560dcc5c42ae9dcd34c26acb1eafbb38"
          },
          dest = "cmake",
        }
      ],
      cmakeExtraArgsRecord = {
        "-DWITH_X11" = false,
        "-DQT_DEBUG_FIND_PACKAGE" = true,
      },

      buildEnv.EXTRA_LDFLAGS | priority 1 =
        _plasma.buildEnv.EXTRA_LDFLAGS
        @ [
          "$(pkg-config --static --libs libavdevice)",
          "$(pkg-config --static --libs libpulse)",
          "$(pkg-config --static --libs xcb)",
          "$(pkg-config --static --libs xcb-shm)",
          "$(pkg-config --static --libs x11-xcb)",
          "$(pkg-config --static --libs xau)",
        ],

      preConfigurePhase = [
        "rm -rf ${SRC}/xembed-sni-proxy"
      ],

      patches = [
        {
          sha256sum = "e7e835cb2870e69528b57efa6537022c2ee60a21442d27c0c0e80f1b641e3cf2",
          file = "0001-plasma-ws.patch",
        },
      ],
      biDrvs =
        if true then
          (
            _plasma.biDrvs
            @ [
              drvs.acl,
              drvs.alsaLibs,
              drvs.attr,
              drvs.boost,
              drvs.breeze,
              drvs.breezeIcons,
              drvs.bzip2,
              drvs.kbookmarks,
              drvs.kcompletion,
              drvs.kconfigwidgets,
              drvs.kitemviews,
              drvs.kjobwidgets,
              drvs.kxmlgui,
              drvs.libcanberra,
              drvs.libogg,
              drvs.libtool,
              drvs.libvorbis,
              drvs.plasmaActivities,
              drvs.solid,
              drvs.utilLinuxWeak,
              drvs.libxcb,
              drvs.libplasma,
              drvs.qtlocation,
              drvs.qtpositioning,
              drvs.qcoro,
              drvs.harfbuzz,
              drvs.kdeclarative,
              drvs.kdecoration,
              drvs.kded,
              drvs.kglobalacceld,
              drvs.kholidays,
              drvs.knewstuff,
              drvs.knighttime,
              drvs.kwallet,
              drvs.kwayland,
              drvs.lcms,
              drvs.libcap,
              drvs.libdisplayinfo,
              drvs.libx11,
              drvs.libxau,
              drvs.libxcursor,
              drvs.libxcvt,
              drvs.libxfixes,
              drvs.libxrender,
              # drvs.mesaExpKwin,
              drvs.pythonFull,
              # drvs.qtsensorsKwin,
              drvs.switcherooControl,
              drvs.vala,
              drvs.xcbProto,
              drvs.xcbRenderutil,
              drvs.xorgMacros,
              drvs.xorgproto,
              drvs.xtrans,
              drvs.attica,
              drvs.knotifyconfig,
              drvs.kparts,
              drvs.krunner,
              drvs.kstatusnotifieritem,
              drvs.syntaxHighlighting,
              drvs.ktexteditor,
              drvs.kitemmodels,
              drvs.ktextwidgets,
              drvs.sonnet,
              drvs.prison,
              drvs.hunspell,
              drvs.kunitconversion,
              drvs.plasma5support,
              drvs.plasmaActivitiesStats,
              drvs.libkscreen,
              drvs.layerShellQt,
              drvs.kwin,
              drvs.libpamFinalUdev,
              drvs.kscreenlocker,
              drvs.phonon,
              drvs.xcbUtilImage,
              drvs.xcbUtilWm,
              drvs.xcbUtilKeysyms,
              drvs.xcbUtilErrors,
              drvs.xcbUtilCursor,
              drvs.xcbUtil,
              drvs.libicu,
              drvs.polkit,
              drvs.elogindWithPolkit,
              drvs.duktape,
              drvs.polkitQt6,
              drvs.libnl,
              drvs.lmSensors,
              drvs.libksysguard,
              drvs.qtspeech,
              drvs.libqrencode,
              drvs.readline,
              drvs.sbc,
              drvs.pulseaudio17,
              drvs.pipewire,
              drvs.libsndfile,
              drvs.libusb,
              drvs.libjpegTurbo,
              drvs.libopus,
              drvs.ldacbt,
              drvs.jansson,
              drvs.fdkAac,
              drvs.ffmpeg,
              drvs.atSpi2Core,
              drvs.qtmultimedia,
              drvs.libxtst,
              drvs.libxi,
              drvs.libxext,
            ]
          )
        else
          [],
    },
}
