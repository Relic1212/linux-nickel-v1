{
  lib,
  drvs,
  _plasma,
  copyq | lib.QtPackage =
    _plasma
    & {
      singleSource = {
        uri = "https://github.com/hluk/CopyQ/archive/refs/tags/v15.0.0.tar.gz",
        sha256sum = "19665e503997e9d2ffd6f062df43255ee2be38d888d8cc22215474196016bb39",
      },
      cmakeExtraArgsRecord = {
        "-DWITH_KEYCHAIN" = false,
        "-DMINIAUDIO_INCLUDE_DIR" = "/usr/include/miniaudio",
      },
      buildEnv = {
        EXTRA_LDFLAGS | priority 1 =
          _plasma.buildEnv.EXTRA_LDFLAGS
          @ [
            # "$(pkg-config --libs --static gbm glesv2 egl dri wayland-client glib-2.0 gmodule-2.0 expat gpgme libcanberra vorbisfile)",
            "$(pkg-config --libs --static libcanberra vorbisfile alsa)",
          ]
      },
      preConfigurePhase = [
        "sed -i 's| MODULE| STATIC|g' ${SRC}/plugins/CMakeLists.txt",
      ],
      biDrvs =
        _plasma.biDrvs
        @ [
          drvs.qca,
          drvs.miniaudio,
          drvs.libcanberra,
          drvs.kstatusnotifieritem,
          drvs.alsaLibs,
        ]
        ###
        @ (
          if (!true) then
            []
          else
            [
              drvs.acl,
              #   drvs.alsaLibs,
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
              #   drvs.libcanberra,
              drvs.libogg,
              drvs.libtool,
              drvs.libvorbis,
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
              drvs.kwayland,
              drvs.lcms,
              drvs.libcap,
              drvs.libdisplayinfo,
              drvs.pythonFull,
              drvs.vala,
              drvs.attica,
              drvs.knotifyconfig,
              drvs.kparts,
              drvs.krunner,
              #   drvs.kstatusnotifieritem,
              drvs.syntaxHighlighting,
              # drvs.ktexteditor,
              drvs.kitemmodels,
              drvs.ktextwidgets,
              drvs.sonnet,
              drvs.prison,
              drvs.hunspell,
              drvs.kunitconversion,
              drvs.libpamFinalUdev,
              drvs.libicu,
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
              drvs.kpty,
              ####
            ]
        )
    }
}
