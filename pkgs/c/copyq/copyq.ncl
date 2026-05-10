{
  lib,
  drvs,

  copyq | lib.QtPackage = {
    singleSource = {
      uri = "https://github.com/hluk/CopyQ/archive/refs/tags/v15.0.0.tar.gz",
      sha256sum = "19665e503997e9d2ffd6f062df43255ee2be38d888d8cc22215474196016bb39",
    },

    buildEnv = {
      EXTRA_LDFLAGS = [
        "$(pkg-config --libs --static gmodule-2.0 expat libpcre2-8)"
      ],
    },
    cmakeExtraArgsRecord = {
      "-DWITH_KEYCHAIN" = false,
      "-DWITH_QCA_ENCRYPTION" = false,
      "-DMINIAUDIO_INCLUDE_DIR" = "/usr/include/miniaudio",
      "-DWITH_PLUGINS" = false,
      "-DWITH_GNOME_CLIPBOARD_EXTENSION" = false,
      "-DWITH_NATIVE_NOTIFICATIONS" = false,
    },
    # buildEnv = {
    #   EXTRA_LDFLAGS | priority 1 =
    #     _plasma.buildEnv.EXTRA_LDFLAGS
    #     @ [
    #       # "$(pkg-config --libs --static gbm glesv2 egl dri wayland-client glib-2.0 gmodule-2.0 expat gpgme libcanberra vorbisfile)",
    #       "$(pkg-config --libs --static libcanberra vorbisfile alsa)",
    #     ]
    # },
    preConfigurePhase = [
      "sed -i 's| MODULE| STATIC|g' ${SRC}/plugins/CMakeLists.txt",
    ],
    llvmProvider = drvs.llvmFull,
    pDrvs = [
      drvs.qtwayland,
      drvs.miniaudio,
      drvs.ecm,
      drvs.qtTools,
    ]
  }
}
