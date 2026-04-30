let
  tiers = import "_kf_tiers.ncl",
  srcData = import "_kf_misc.ncl"
in

let d = {
  _kCommon = {
    tier1names = std.record.filter (fun k v => v == 1) tiers |> std.record.fields,
    tier2names = std.record.filter (fun k v => v == 2) tiers |> std.record.fields,
    tier3names = std.record.filter (fun k v => v == 3) tiers |> std.record.fields,
    tier3bnames = std.record.filter (fun k v => v == "3b") tiers |> std.record.fields,

    names2sources = (fun names => (std.array.map (fun p => srcData."%{p}" & { dest = p }) names)),

    tier1sources = (std.array.map (fun p => srcData."%{p}" & { dest = p }) tier1names),
    tier2sources = (std.array.map (fun p => srcData."%{p}" & { dest = p }) tier2names),
    tier3sources = (std.array.map (fun p => srcData."%{p}" & { dest = p }) tier3names),
    tier3bsources = (std.array.map (fun p => srcData."%{p}" & { dest = p }) tier3bnames),
    # tier3bsources = names2sources tier3bnames,
    tier3bOrderedNames = [
      "kiconthemes",
      "kio",
      "knotifyconfig",
      "kxmlgui",
      "kparts",
      "ktexteditor",
      "kcmutils",
    ]
  },
  lib,
  drvs,
  _kfBase | lib.QtPackage = {

    generator = "Ninja",

    llvmProvider = drvs.llvmFull,
    # 

    options = {
      version = "6.25",

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

      "-DKWINDOWSYSTEM_X11" = false,
      "-DKWINDOWSYSTEM_WAYLAND" = true,
      "-DKSYNTAXHIGHLIGHTING_USE_GUI" = false,
      "-DWITH_MULTIMEDIA" = false,
    },
  },

  kftier1 | lib.QtPackage =
    _kfBase
    & {
      sourceInputs = _kCommon.tier1sources,
      separateBuildDir = false,
      preConfigurePhase =
        let cmake = std.string.join "\n" (std.array.map (fun s => "add_subdirectory(%{s})") _kCommon.tier1names) in
        let genCmake = m%"
cat >${SRC}/CMakeLists.txt <<EOF
cmake_minimum_required(VERSION 4.1)
%{cmake}
EOF
"%
        in
        [
          # genCmake,
          # kidlteime
          "sed -i 's@add_subdirectory(examples)@#add_subdirectory(examples)@g' ${SRC}/kidletime/CMakeLists.txt",
          m%"
        for f in $(find ${SRC}/kidletime -name CMakeLists.txt); do
          sed -i 's@ MODULE@@g' ${f}
        done
        "%,
          # -kidletime
          # kwindowsystem
          # fixes
          # ld.lld: error: duplicate symbol: wl_display_interface
          # >>> defined at wayland-protocol.c
          # >>>            meson-generated_.._wayland-protocol.c.o:(wl_display_interface) in archive /usr/lib/libwayland-client.a
          # >>> defined at wayland-wayland-protocol.c
          # >>>            src/platforms/wayland/CMakeFiles/KF6WindowSystemKWaylandPlugin.dir/wayland-wayland-protocol.c.o:(.data.rel.ro.wl_display_interface+0x0)
          "sed -i 's@MODULE@STATIC@g' ${SRC}/kwindowsystem/src/platforms/wayland/CMakeLists.txt",
          # -kwindowsystem
        ],
      cmakeArgs,
      configurePhase = [
        "for d in $(ls); do ",
        "echo \"building $d\"",
        "cd $d",
        "cmake -B build -S . %{std.string.join " " cmakeArgs }",
        "cmake --build build",
        "DESTDIR=${DEST} cmake --install build",
        "cd ..",
        "done",
      ],
      buildPhase = [],
      installPhase = [
        # "cat F",
      ],
    },

  kftier2 | lib.QtPackage =
    _kfBase
    & {
      sourceInputs = _kCommon.tier2sources,
      separateBuildDir = false,
      preConfigurePhase = [

        # kauth
        "sed -i 's@ MODULE @ @g' ${SRC}/kauth/src/CMakeLists.txt",
        # -kauth

        # kpackage
        m%"sed -i 's@NOT BUILD_SHARED_LIBS@FALSE@g' ${SRC}/kpackage/src/kpackage/CMakeLists.txt"%, # it really is kpackage/src/kpackage
        # -kpackage
      ],
      cmakeExtraArgsRecord,
      cmakeArgs,
      configurePhase = [
        "for d in $(ls); do ",
        "echo \"building $d\"",
        "cd $d",
        "cmake -B build -S . %{std.string.join " " cmakeArgs }",
        "cmake --build build",
        "DESTDIR=${DEST} cmake --install build",
        "cd ..",
        "done",
      ],
      buildPhase = [],
      installPhase = [],
      biDrvs | priority 1 =
        _kfBase.biDrvs
        @ [
          drvs.kftier1,
          drvs.libcanberra,
          drvs.libogg,
          drvs.libtool,
          drvs.libvorbis,
        ]
    },

  kftier3 | lib.QtPackage =
    _kfBase
    & {
      sourceInputs = _kCommon.tier3sources,
      separateBuildDir = false,
      buildEnv.EXTRA_LDFLAGS | priority 1 =
        _kfBase.buildEnv.EXTRA_LDFLAGS
        @ [
          "$(pkg-config --libs --static gpgme)",
        ],
      preConfigurePhase = [
        # knewstuff
        m%"sed -i 's|install(TARGETS KF6NewStuffCore |install(TARGETS KF6NewStuffCore knscore_jobs_static |g' ${SRC}/knewstuff/src/core/CMakeLists.txt"%,
        # -knewstuff
        # krunner
        m%"sed -i 's| SHARED| STATIC|g' ${SRC}/krunner/src/CMakeLists.txt"%,
        # -krunner

        # kwallet
        "sed -i 's@KF6WalletBackend SHARED@KF6WalletBackend STATIC@g' ${SRC}/kwallet/src/runtime/kwalletbackend/CMakeLists.txt"
        # -kwallet
      ],
      cmakeExtraArgsRecord = {
        "-DBUILD_KSECRETD" = true,
        "-DBUILD_KWALLETD" = true,
        "-DBUILD_KWALLET_QUERY" = true,
      },
      cmakeArgs,
      configurePhase = [
        "for d in $(ls); do ",
        "echo \"building $d\"",
        "cd $d",
        "cmake -B build -S . %{std.string.join " " cmakeArgs }",
        "cmake --build build",
        "DESTDIR=${DEST} cmake --install build",
        "cd ..",
        "done",
      ],
      buildPhase = [],
      installPhase = [],
      options.pythonProvider = drvs.pythonDynamic,
      options.extraInputs = [
        drvs.kftier1,
        drvs.kftier2,
        drvs.libcanberra,
        drvs.libogg,
        drvs.libtool,
        drvs.libvorbis,
        drvs.pythonLxml,
        drvs.muslShared & { priority = -1 },
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
        drvs.qca,
        drvs.libsecret,
        drvs.libassuan,
      ]
    },

  kftier3b | lib.QtPackage =
    _kfBase
    & {
      sourceInputs = _kCommon.tier3bsources,
      separateBuildDir = false,
      buildEnv.EXTRA_LDFLAGS | priority 1 =
        _kfBase.buildEnv.EXTRA_LDFLAGS
        @ [
          # "$(pkg-config --libs --static gpgme)",
          "$(pkg-config --static --libs libavdevice)",
          "$(pkg-config --static --libs libpulse)",
        ],
      preConfigurePhase = [
        # kiconthemes
        "sed -i 's@ MODULE @ @g' ${SRC}/kiconthemes/src/CMakeLists.txt",

        # -kiconthemes

        # kio
        m%"sed -i 's|(NOT KIOGUI_ONLY)|(NOT KIOGUI_ONLY)\nfind_package(KF6Notifications ${KF_DEP_VERSION} REQUIRED)|g' ${SRC}/kio/CMakeLists.txt"%,
        m%"sed -i 's|add_subdirectory( kdedmodule )||g' ${SRC}/kio/src/kioworkers/remote/CMakeLists.txt"%,
        # -kio

        # knotifyconfig
        m%"sed -i 's|find_package(KF6Completion ${KF_DEP_VERSION} REQUIRED)|find_package(KF6Notifications ${KF_DEP_VERSION} REQUIRED)\nfind_package(KF6Completion ${KF_DEP_VERSION} REQUIRED)|g' ${SRC}/knotifyconfig/CMakeLists.txt"%,
        # -knotifyconfig

        # kparts
        m%"sed -i 's|find_package(KF6JobWidgets ${KF_DEP_VERSION} REQUIRED)|find_package(KF6Notifications ${KF_DEP_VERSION} REQUIRED)\nfind_package(KF6JobWidgets ${KF_DEP_VERSION} REQUIRED)|g' ${SRC}/kparts/CMakeLists.txt"%,

        # -kparts

        # ktexteditor
        m%"sed -i 's|find_package(KF6Archive ${KF_DEP_VERSION} REQUIRED)|find_package(KF6Notifications ${KF_DEP_VERSION} REQUIRED)\nfind_package(KF6Archive ${KF_DEP_VERSION} REQUIRED)\ninclude(FindFFmpeg)\ninclude(QtFindPackageHelpers)\nqt_find_package(FFmpeg PROVIDED_TARGETS FFmpeg::avformat QMAKE_LIB ffmpeg REQUIRED)|g' ${SRC}/ktexteditor/CMakeLists.txt"%,
        m%"sed -i 's|accessibleInterfaceFactory|__kde_ktexteditor__accessibleInterfaceFactory|g' ${SRC}/ktexteditor/src/view/kateviewinternal.cpp"%,
        m%"sed -i 's|accessibleInterfaceFactory|__kde_ktexteditor__accessibleInterfaceFactory|g' ${SRC}/ktexteditor/src/view/kateviewaccessible.h"%,
        m%"sed -i 's| MODULE| STATIC|g' ${SRC}/ktexteditor/src/part/CMakeLists.txt"%,
        # -ktexteditor
      ],
      cmakeExtraArgsRecord = {
        # "-DCMAKE_PREFIX_PATH" = "\"/;/tmp/workdir/out/destdir;/usr;/tmp/workdir/out/destdir/usr\"",
        "-DENABLE_KAUTH" = false,
      },
      cmakeArgs,
      eofPatches = [
        # {
        #   patch = import "0001-kio.patch" as 'Text,
        #   subdir = "/kio",
        # },
        {
          patch = import "0001-kcmutils.patch" as 'Text,
          subdir = "/kcmutils",
        },
      ],
      configurePhase = [
        # m%"export CMAKE_PREFIX_PATH="/;/dest/usr""%,
        "export CMAKE_PREFIX_PATH=\"/:/tmp/workdir/out/destdir:/usr:/tmp/workdir/out/destdir/usr\"",
        "for d in %{std.string.join " " _kCommon.tier3bOrderedNames}; do ",
        "echo \"building $d\"",
        "cd $d",
        "cmake -B build -S . %{std.string.join " " cmakeArgs }",
        "cmake --build build",
        "DESTDIR=${DEST} cmake --install build",
        "cd ..",
        "done",
      ],
      buildPhase = [],
      installPhase = [],
      # options.pythonProvider = drvs.pythonDynamic,
      options.extraInputs = [
        drvs.kftier1,
        drvs.kftier2,
        drvs.kftier3,
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
        drvs.qca,
        drvs.libsecret,
        drvs.libassuan,
      ]
    }
}
in
d
