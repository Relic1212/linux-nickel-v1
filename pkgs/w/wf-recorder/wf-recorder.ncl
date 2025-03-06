{
  lib,
  drvs,
  wfRecorder | lib.MesonPackage = {
    singleSource = {
      # uri = "https://github.com/ammen99/wf-recorder/releases/download/v0.5.0/wf-recorder-0.5.0.tar.xz",
      # sha256sum = "50b30569f9ecf4f6ba5ba76c422b7af652b4fbc7cae86c25e19ecbe669fca327"
      uri = "https://github.com/ammen99/wf-recorder/archive/560bb92d3ddaeb31d7af77d22d01b0050b45bebe.zip",
      sha256sum = "6dd718601616fedb3752e67627758d78c8721cf223eb239b57c8149aa156dbfa",
    },
    patches = [
      {
        file = "0001-no-audio.diff",
        sha256sum = "ffa3b049c41bdbda0868266ef5e1dc0ceafeb0abbd9c8bceffff89da93ce0869",
      }
    ],
    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.fontconfig,
      drvs.freetype,
      drvs.zlibNg,
      drvs.gperf,
      drvs.pixman,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.libffi,
      drvs.libxkbcommon,
      drvs.expat,
      drvs.linuxHeaders,
      drvs.libdrm,
      drvs.libpciaccess,
      drvs.libelf,
      drvs.mesa2,
      drvs.ffmpeg,
    ],
    extraMesonArgs = [
      # "-Ddefault_audio_backend=''",
      "-Dpulse=disabled",
      "-Dpipewire=disabled",
    ]
  },
}
