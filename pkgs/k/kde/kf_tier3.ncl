{
  lib,
  drvs,
  _kfBase,
  _kCommon,

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
      cmakeExtraArgsRecord = {
        # "-DCMAKE_PREFIX_PATH" = "\"/;/tmp/workdir/out/destdir;/usr;/tmp/workdir/out/destdir/usr\"",
        "-DENABLE_KAUTH" = false,
        "-DBUILD_INDEXER_SERVICE" = false, # baloo
      },
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

        # kfilemetadata
        m%"for f in $(find ${SRC}/kfilemetadata -type f -name CMakeLists.txt);do sed -i 's| MODULE| STATIC|g' ${f};done"%,
        # -kfilemetadata

        # baloo
        # m%"sed -i 's|install(TARGETS KF6Baloo EXPORT KF6BalooTargets|install(TARGETS KF6Baloo BalooDBusMainInterface EXPORT KF6BalooTargets|g' ${SRC}/baloo/src/lib/CMakeLists.txt"%,
        # m%"sed -i 's|install(TARGETS KF6BalooEngine EXPORT KF6BalooTargets|install(TARGETS KF6BalooEngine KF6BalooCodecs EXPORT KF6BalooTargets|g' ${SRC}/baloo/src/engine/CMakeLists.txt"%,
        m%"
        cat >>${SRC}/baloo/src/dbus/CMakeLists.txt << 'EOF'
        install(TARGETS BalooDBusMainInterface EXPORT KF6BalooTargets ${KF_INSTALL_TARGETS_DEFAULT_ARGS})
        EOF
        "%,
        m%"
        cat >>${SRC}/baloo/src/codecs/CMakeLists.txt << 'EOF'
        install(TARGETS KF6BalooCodecs EXPORT KF6BalooTargets ${KF_INSTALL_TARGETS_DEFAULT_ARGS})
        EOF
        "%,
        # m%"for f in $(find ${SRC}/baloo/src/kioworkers -type f -name CMakeLists.txt);do sed -i 's| MODULE| STATIC|g' ${f};done"%, # skip BUILD_KINOTIFY instead
        "sed -i 's@${Inotify_FOUND}@false@g' ${SRC}/baloo/CMakeLists.txt",
        # -baloo
      ],

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
        drvs.lmdb,
      ]
    }
}
