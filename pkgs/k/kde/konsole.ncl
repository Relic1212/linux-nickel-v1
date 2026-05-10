{
  _plasma,
  lib,
  drvs,
  konsole =
    _plasma
    & {
      singleSource = {
        uri = "https://invent.kde.org/utilities/konsole/-/archive/v25.08.3/konsole-v25.08.3.tar.bz2",
        sha256sum = "7c0351b1c270c5150f476ae30fd4e10aa5ba32fe95a0b2f1fb6393166fb83f96",
      },

      cmakeExtraArgsRecord = {
        "-DWITH_X11" = false,
        # "-DQT_DEBUG_FIND_PACKAGE" = true,
      },

      buildEnv.EXTRA_LDFLAGS | priority 1 =
        # _plasma.buildEnv.EXTRA_LDFLAGS
        # @
        [
          "$(pkg-config --static --libs libavdevice)",
          "$(pkg-config --static --libs libpulse)",
          # "$(pkg-config --static --libs xcb)",
          # "$(pkg-config --static --libs xcb-shm)",
          # "$(pkg-config --static --libs x11-xcb)",
          # "$(pkg-config --static --libs xau)",
        ],

      patches = [
        {
          sha256sum = "5ec4bff7ad93b23504603440f86cc517d7609a3ab4ec4f7e62f297038d301a0e",
          file = "konsole.patch",
        }
      ],
      debug = true,
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
              drvs.kstatusnotifieritem,
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
            ]
          )
        else
          [],
    },
}
