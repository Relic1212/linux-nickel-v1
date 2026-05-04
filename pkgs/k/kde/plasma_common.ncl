let srcData = import "_plasma_misc.ncl"
in

{
  _plasmaCommon = {
    orderedNames = [
      "kdecoration",
      "breeze",
      "kglobalacceld",
      "knighttime",
      "libkscreen",
      "plasma-activities",
      "libplasma",
      "layer-shell-qt",
      "kscreen",
      "kscreenlocker",
      "kwayland",
      # "kwin",
      "libksysguard",
      "plasma-activities-stats",
      "plasma5support",
      "kwin",
      "plasma-workspace",
    ],

    sources = (std.array.map (fun p => srcData."%{p}" & { dest = p }) orderedNames),
  },
  lib,
  drvs,
  _plasmaBase | lib.QtPackage = {

    generator = "Ninja",

    llvmProvider = drvs.llvmFull,
    # 

    options = {
      #   version = "6.6.4",

      waylandSyms = false,
      xkbcommonX11 | default = false,
      extraInputs | default = [],
    },
    options.pythonProvider | default = drvs.pythonFull,
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
        drvs.mesaExpKwin,
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
      ]
      @ (
        if options.xkbcommonX11 then
          [
            drvs.libxkbcommonX11,
          ]
        else
          [
            drvs.libxkbcommon,
          ]
      )
      @ [
        drvs.openssl,
        drvs.kmod,
        drvs.zstd,
        drvs.xz,
        drvs.bzip2,
        drvs.eudev,
        drvs.libinput,
        drvs.ecm,
        drvs.plasmaWaylandProtocols,
        drvs.gperf,
        drvs.isoCodes,
        options.pythonProvider,
        drvs.gettext,
        drvs.libqrencode,
        drvs.libdmtx,
        drvs.zxing,
        drvs.utilLinux,
        drvs.hunspell,
        drvs.perl,
        drvs.kftier1,
        drvs.kftier2,
        drvs.kftier3,
        drvs.kftier3b,
        drvs.libcanberra,
        drvs.libogg,
        drvs.libtool,
        drvs.libvorbis,
        # drvs.pythonLxml,
        # drvs.muslShared & { priority = -1 },
        drvs.qtmultimedia,
        drvs.qtspeech,
        drvs.acl,
        drvs.attr,
        drvs.readline,
        drvs.sbc,
        drvs.pulseaudio17,
        drvs.pipewire,
        drvs.libsndfile,
        drvs.libusb,
        drvs.libjpegTurbo,
        drvs.libopus,
        drvs.ldacbt,
        drvs.libcap,
        drvs.jansson,
        drvs.fdkAac,
        drvs.ffmpeg,
        drvs.alsaLibs,
        drvs.atSpi2Core,
        drvs.libgcrypt,
        drvs.libgpgError,
        drvs.gpgmeForCmake,
        drvs.lmdb,
        drvs.qca,
        drvs.libsecret,
        drvs.libassuan,
        drvs.qtpositioning,
        drvs.libxcb,
        drvs.xcbUtilImage,
        drvs.xcbUtilWm,
        drvs.xcbUtilKeysyms,
        drvs.xcbUtilErrors,
        drvs.xcbUtilCursor,
        drvs.xcbUtil,
        drvs.libx11,
        drvs.libxau, # kscreenlocker
        drvs.libxcursor, # kscreenlocker
        drvs.libxcvt, # kscreenlocker
        drvs.libxfixes, # kscreenlocker
        drvs.libxrender, # kscreenlocker
        drvs.xcbProto, # kscreenlocker
        drvs.xcbRenderutil, # kscreenlocker
        drvs.xorgMacros, # kscreenlocker
        drvs.xorgproto, # kscreenlocker
        drvs.xtrans, # kscreenlocker
        drvs.libpamFinalUdev, # kscreenlocker
        drvs.libdisplayinfo, # kwin
        drvs.lcms, # kwin
        drvs.libepoxyCompat, # kwin
        drvs.libnl, # libksysguard
        drvs.lmSensors, # libksysguard
        drvs.qtlocation, # plasma-workspace
        drvs.qcoro, # plasma-workspace
        drvs.polkit, # plasma-workspace
        drvs.elogindWithPolkit, # plasma-workspace
        drvs.duktape, # plasma-workspace
        drvs.polkitQt6, # plasma-workspace
        drvs.libicu, # plasma-workspace
      ]
      @ options.extraInputs,
    buildEnv =
      let common_flags = ["-DQT_STATICPLUGIN"] in
      {
        EXTRA_CFLAGS = common_flags,
        EXTRA_CPPFLAGS = common_flags,
        EXTRA_CXXFLAGS = common_flags,

        BASE_LDFLAGS | priority 1 = [],
        EXTRA_LDFLAGS = [
          "$(pkg-config --libs --static gbm glesv2 egl dri wayland-client glib-2.0 gmodule-2.0 expat)",
        ]
      },
    cmakeExtraArgsRecord = {

      "-DBUILD_TESTING" = false,
      "-DWITH_X11" = false,
      "-DBUILD_DESIGNERPLUGIN" = false,
      "-DBUILD_QT5" = false,
      "-DWITHOUT_X11" = true,

      # kwin

      "-DKWIN_BUILD_DECORATIONS" = true,
      "-DKWIN_BUILD_KCMS" = false,
      "-DKWIN_BUILD_NOTIFICATIONS" = true,
      "-DKWIN_BUILD_SCREENLOCKER" = false,
      "-DKWIN_BUILD_TABBOX" = false,
      "-DKWIN_BUILD_X11" = false,
      "-DKWIN_BUILD_X11_BACKEND" = false,
      "-DKWIN_BUILD_GLOBALSHORTCUTS" = false,
      "-DKWIN_BUILD_RUNNERS" = true,
      # -kwin

      # plasma-workspace
      "-DWITH_X11_SESSION" = false,
      # -plasma-workspace
    },
  },

  plasmaCommon | lib.QtPackage =
    _plasmaBase
    & {
      sourceInputs =
        _plasmaCommon.sources
        @ [
          {
            src = {
              uri = "https://raw.githubusercontent.com/KDE/prison/c08826f0fc37b9a1e916d6abd73a42354727f7df/cmake/FindQRencode.cmake",
              sha256sum = "18997ffe9cf418c3f2d2225c59b54ef3560dcc5c42ae9dcd34c26acb1eafbb38"
            },
            dest = "plasma-workspace/cmake",
          },
          {
            src = {
              uri = "http://raw.githubusercontent.com/KDE/prison/refs/tags/v6.25.0/cmake/FindDmtx.cmake",
              sha256sum = "64751470671244e294427f839c8e0377de51b100c1b9068909d018007704ba16",
            },
            dest = "plasma-workspace/cmake",
          }
        ],
      options = {
        dirs | default = [
          "kdecoration",
          "breeze",
          "kglobalacceld",
          "knighttime",
          "libkscreen",
          "plasma-activities",
          "libplasma",
          "layer-shell-qt",
          "kscreen",
          "kscreenlocker",
          "kwayland",
          # "kwin",
          "libksysguard",
          "plasma-activities-stats",
          "plasma5support",
          "kwin",
          # "plasma-workspace",
        ],
        prepPs | default = false,
      },

      separateBuildDir = false,
      buildEnv.EXTRA_LDFLAGS | priority 1 =
        _plasmaBase.buildEnv.EXTRA_LDFLAGS
        @ [
          # "$(pkg-config --libs --static gpgme)",
          #   "$(pkg-config --static --libs libavdevice)",
          #   "$(pkg-config --static --libs libpulse)",
          # "$(pkg-config --static --libs libcap)",
          # "$(pkg-config --static --libs pam)",
        ],

      eofPatches =
        [
          {
            patch = import "0001-libkscreen-6.6.4.patch" as 'Text,
            subdir = "/libkscreen"
          },
          {
            patch = import "0001-libplasma-6.6.4.patch" as 'Text,
            subdir = "/libplasma",
          },
          {
            patch = import "0001-libplasma-6.6.4-blur.patch" as 'Text,
            subdir = "/libplasma",
          },
          {
            patch = import "kscreen-nox11.patch" as 'Text,
            subdir = "/kscreen"
          },
          {
            patch = import "0001-kscreenlocker2.patch" as 'Text,
            subdir = "/kscreenlocker"
          },
          {
            patch = import "0001-kwin-6.6.4.patch" as 'Text,
            subdir = "/kwin",
          },
        ]
        @ (
          if options.prepPs then
            [
              {
                patch = import "0001-plasma-workspace-6.6.4-full.patch" as 'Text,
                subdir = "/plasma-workspace"
              }
            ]
          else
            [
              {
                patch = import "0001-plasma-workspace-6.6.4.patch" as 'Text,
                subdir = "/plasma-workspace"
              },
            ]
        ),
      preConfigurePhase =
        [
          # kdecoration
          "sed -i 's@ SHARED@@g' ${SRC}/kdecoration/src/private/CMakeLists.txt",
          "sed -i 's@ SHARED@@g' ${SRC}/kdecoration/src/CMakeLists.txt",
          # -kdecoration

          # breeze
          m%"sed -i 's|MODULE|STATIC|g' ${SRC}/breeze/kdecoration/CMakeLists.txt"%,
          m%"sed -i 's|MODULE|STATIC|g' ${SRC}/breeze/kstyle/CMakeLists.txt"%,
          # -breeze
          # kglobalacceld
          m%"sed -i 's|find_package(KF6JobWidgets ${KF6_MIN_VERSION} REQUIRED)|find_package(KF6Notifications ${KF6_MIN_VERSION} REQUIRED)\nfind_package(KF6JobWidgets ${KF6_MIN_VERSION} REQUIRED)|g' ${SRC}/kglobalacceld/CMakeLists.txt"%,
          # -kglobalacceld

          # libkscreen
          m%"for f in $(find ${SRC}/libkscreen -type f -name CMakeLists.txt);do sed -i 's| SHARED| STATIC|g' ${f};done"%,
          m%"for f in $(find ${SRC}/libkscreen -type f -name CMakeLists.txt);do sed -i 's| MODULE| STATIC|g' ${f};done"%,
          # -libkscreen

          # plasma-activities
          m%"sed -i 's|qt_add_dbus_interface|qt6_add_dbus_interface|g' ${SRC}/plasma-activities/src/lib/CMakeLists.txt"%,
          # -plasma-activities

          # libplasma
          m%"sed -i 's|SHARED|STATIC|g' ${SRC}/libplasma/src/plasmaquick/CMakeLists.txt"%,
          m%"sed -i 's|SHARED|STATIC|g' ${SRC}/libplasma/templates/plasma6-wallpaper-with-qml-extension/plugin/CMakeLists.txt"%,
          m%"sed -i 's|SHARED|STATIC|g' ${SRC}/libplasma/PlasmaMacros.cmake"%,
          m%"sed -i 's|MODULE|STATIC|g' ${SRC}/libplasma/src/declarativeimports/kirigamiplasmastyle/CMakeLists.txt"%,
          # -libplasma

          # layer-shell-qt
          m%"for f in $(find ${SRC}/layer-shell-qt -type f -name CMakeLists.txt);do sed -i 's| SHARED| STATIC|g' ${f};done"%,
          m%"for f in $(find ${SRC}/layer-shell-qt -type f -name CMakeLists.txt);do sed -i 's| MODULE| STATIC|g' ${f};done"%,
          # -layer-shell-qt

          # kscreen
          (
            lib.functions.cmakePrependLines
              "find_package(LayerShellQt)"
              [
                # "find_package(Qt6WaylandClient COMPONENTS Private)",
                # "find_package(Qt6WaylandClient REQUIRED COMPONENTS Private)",
                # "find_package(Qt6WaylandClientPrivate)",
                "find_package(Qt6WaylandClientPrivate REQUIRED)",
                "find_package(PkgConfig)",
                "pkg_check_modules(XKBCOMMON xkbcommon REQUIRED IMPORTED_TARGET)",
                "find_package(PlasmaActivities REQUIRED)",
              ]
          )
          ++ " ${SRC}/kscreen/CMakeLists.txt",
          m%"sed -i "s|DBusAddons|DBusAddons\n\tNotifications\n\tKIO|g" ${SRC}/kscreen/CMakeLists.txt"%,
          # -kscreen

          # kscreenlocker
          m%"sed -i 's|CONFIG REQUIRED COMPONENTS DBus Widgets Quick Test|CONFIG REQUIRED COMPONENTS DBus Widgets Quick Test WaylandClientPrivate|g' ${SRC}/kscreenlocker/CMakeLists.txt"%,
          # -kscreenlocker

          # kwin
          # "sed -i 's|find_dependency(epoxy)|# find_dependency(epoxy)|g' ${SRC}/kwin/KWinConfig.cmake.in",
          # "sed -i 's|epoxy::epoxy||g' ${SRC}/kwin/src/CMakeLists.txt",
          # -kwin

          # libksysguard
          m%"sed -i 's|install(EXPORT libksysguardLibraryTargets|install(TARGETS dbusinterface Formatter_resources_1 processcore_resources_1 SensorFaces_resources_1 SensorFaces_resources_2 Sensors_resources_1 EXPORT libksysguardLibraryTargets ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})\ninstall(EXPORT libksysguardLibraryTargets|g' ${SRC}/libksysguard/CMakeLists.txt"%,
          m%"for f in $(find ${SRC}/libksysguard -type f -name CMakeLists.txt);do sed -i 's| MODULE| STATIC|g' ${f};done"%,
          # -libksysguard 

          # plasma5support
          m%"sed -i 's| SHARED| STATIC|g' ${SRC}/plasma5support/src/dataengines/weather/ions/CMakeLists.txt"%,
          m%"for f in $(find ${SRC}/plasma5support -type f -name CMakeLists.txt);do sed -i 's| MODULE| STATIC|g' ${f};done"%,
          m%"sed -i "s|IdleTime|Auth\nIdleTime|g" ${SRC}/plasma5support/CMakeLists.txt"%,

          # -plasma5support

          # plasma-workspace
          # m%"cat >${SRC}/plasma-workspace/CMakeLists.txt << 'EOF'
          # "%
        ]
        @ (
          if (!options.prepPs) then
            [
              "sed -i 's@ecm_optional_add_subdirectory(xembed-sni-proxy)@# ecm_optional_add_subdirectory(xembed-sni-proxy)@g' ${SRC}/plasma-workspace/CMakeLists.txt",
              m%"sed -i "s@find_package(QRencode)@find_package(QRencode)\nfind_package(X11)\nfind_package(Dmtx)\nfind_package(ZXing CONFIG)@g" ${SRC}/plasma-workspace/CMakeLists.txt"%,
            ]
          else
            [
              # "sed -i 's|  SOURCES | STATIC SOURCES |g' ${SRC}/plasma-workspace/shell/packageplugins/CMakeLists.txt" # not needed w build_shared_libs=off

              # "sed -i 's|add_subdirectory(packageplugins)|# add_subdirectory(packageplugins)|g' ${SRC}/plasma-workspace/shell/CMakeLists.txt",
              # m%"sed -i "s@install(TARGETS plasmashell@%{ 
              #   std.string.join ""
              #   [
              #      m%"add_subdirectory(packageplugins)\n"%,
              #      # m%"kcoreaddons_target_static_plugins(plasma_layouttemplate NAMESPACE \"kf6/packagestructure\")\n"%,
              #      # m%"kcoreaddons_target_static_plugins(plasma_lookandfeel NAMESPACE \"kf6/packagestructure\")\n"%,
              #      # m%"kcoreaddons_target_static_plugins(wallpaper_images NAMESPACE \"kf6/packagestructure\")\n"%,
              #     #  m%"kcoreaddons_target_static_plugins(plasmashell LINK_OPTION PRIVATE NAMESPACE kf6/packagestructure)\n"%,
              #     #  m%"kcoreaddons_target_static_plugins(plasmashell\n\tLINK_OPTION PRIVATE\n\tTARGETS plasma_lookandfeel\n)\n"%,
              #      m%"kcoreaddons_target_static_plugins(plasmashell\n\tLINK_OPTION PRIVATE\n\tNAMESPACE "kf6/packagestructure"\n)\n"%,
              #      m%"install(TARGETS plasmashell"%
              #    ]

              #   }@g" ${SRC}/plasma-workspace/shell/CMakeLists.txt"%
              # -plasma-workspace
            ]
        ),
      cmakeExtraArgsRecord = {},
      cmakeArgs,
      configurePhase =
        let pLDFLAGS =
          (std.record.from_array (std.array.map (fun p => { field = "%{p}", value = "" }) _plasmaCommon.orderedNames))
          & {
            "kscreenlocker" | priority 1 = m%"LDFLAGS="${LDFLAGS} $(pkg-config --static --libs pam)" "%,
            "kwin" | priority 1 = m%"LDFLAGS="${LDFLAGS} $(pkg-config --static --libs mtdev libevdev)" "%,
            "plasma-workspace" | priority 1 = m%"LDFLAGS="${LDFLAGS} $(pkg-config --static --libs libavdevice libpulse)" "%
          }
        in
        (
          [
            # m%"export CMAKE_PREFIX_PATH="/;/dest/usr""%,
            "export CMAKE_PREFIX_PATH=\"/:/tmp/workdir/out/destdir:/usr:/tmp/workdir/out/destdir/usr\"",
          ]
          @ (
            std.array.flatten (
              std.array.map
                (fun p =>
                  let prefix =
                    #if p=="kscreenlocker" then  m%"LDFLAGS="${LDFLAGS} $(pkg-config --static --libs pam)" "% else "" 
                    pLDFLAGS."%{p}"
                  in
                  [
                    # "for d in %{std.string.join " " _plasmaCommon.orderedNames}; do ",
                    "echo \"building %{p}\"",
                    "cd %{p}",
                    "%{prefix} cmake -B build -S . %{std.string.join " " cmakeArgs }",
                    "%{prefix} cmake --build build",
                    "DESTDIR=${DEST} cmake --install build",
                    "cd ..",
                    # "done",
                  ]
                )
                options.dirs
            )
          )
        ),
      buildPhase = [],
      installPhase = [],
    },

  libepoxyCompat | lib.Package = {
    installPhase = [
      "install -dm0755 ${DEST}/usr/include/epoxy",
      "cd ${DEST}/usr/include/epoxy",
      "cat >gl.h << 'EOF'\n%{import "epoxy_gl.h" as 'Text}\nEOF",
      "cat >egl.h << 'EOF'\n%{import "epoxy_egl.h" as 'Text}\nEOF",
    ]
  },

  plasmaCommon2 =
    plasmaCommon
    & {
      options.dirs = [
        "plasma-workspace"
      ],

      options.prepPs = true,
      biDrvs | priority 1 = plasmaCommon.biDrvs @ [drvs.plasmaCommon]
    }
}
