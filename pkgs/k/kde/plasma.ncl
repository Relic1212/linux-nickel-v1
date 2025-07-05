{
  lib,
  drvs,
  _kf,

  _plasma | lib.CmakePackage = (
    _kf
    & {

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
        ]
    }
  ),

  kdecorations | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/plasma/6.3.3/kdecoration-6.3.3.tar.xz",
        sha256sum = "65672b9bd00d1c2d18ff028b028eb8054bc476d645e25afa7dc28add4301e10b"
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

      preConfigurePhase = [
        "sed -i 's@ SHARED@@g' ${SRC}/src/private/CMakeLists.txt",
        "sed -i 's@ SHARED@@g' ${SRC}/src/CMakeLists.txt",
      ]
    },

  kwayland | lib.CmakePackage =
    _plasma
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/plasma/6.3.3/kwayland-6.3.3.tar.xz",
        sha256sum = "e6221e1021b2d7e686d377e23784a7546d14b52d24937d73ee7c6865a2a40dfa"
      },
    },

  plasmaActivities | lib.CmakePackage =
    _plasma
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/plasma/6.3.3/plasma-activities-6.3.3.tar.xz",
        sha256sum = "aedd8bcbbb527f6a7da83d7cd72506608a486394805d9bf0037b2f899f0b7e53",
      }
    },

  libplasma | lib.CmakePackage =
    _plasma
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/plasma/6.3.3/libplasma-6.3.3.tar.xz",
        sha256sum = "c7afa64a9cc058515afb06dcb1d3f647904c2eea40bbae43540f9f02314488ac",
      }
    },

  breeze | lib.CmakePackage =
    _plasma
    & {
      singleSource = {
        uri = "https://download.kde.org/stable/plasma/6.3.3/breeze-6.3.3.tar.xz",
        sha256sum = "e07c95e26deb002a4b6f3422fc7cb8bd6df1d60a55064c92e9b17ff5a89796e4",
      },
      cmakeExtraArgsRecord = {
        "-DBUILD_QT5" = false,
      },
    },
}
