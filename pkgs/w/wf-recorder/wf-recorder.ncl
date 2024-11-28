{
  lib,
  drvs,
  wfRecorder | lib.MesonPackage
    = {
      singleSource = {
        uri = "https://github.com/ammen99/wf-recorder/releases/download/v0.5.0/wf-recorder-0.5.0.tar.xz",
        sha256sum = "50b30569f9ecf4f6ba5ba76c422b7af652b4fbc7cae86c25e19ecbe669fca327"
      },
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
    }
}
