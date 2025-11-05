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
          drvs.kcoreaddons,
          drvs.kcodecs,
          drvs.kconfig,
          drvs.kguiaddons,
          drvs.ki18n,
          drvs.gettext,
          drvs.kwidgetsaddons,
          drvs.kcolorscheme,
          drvs.kauth,
          drvs.kglobalaccel,
          drvs.kpackage,
          drvs.kidletime,
          drvs.kcrash,
          drvs.kservice,
          drvs.ksvg,
          drvs.kdbusaddons,
          drvs.plasmaWaylandProtocols,
          drvs.kwindowsystem,
          drvs.kirigami,
          drvs.karchive,
          drvs.kiconthemes,
          drvs.kio,
          drvs.knotifications,
          drvs.kcmutils,
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
}
