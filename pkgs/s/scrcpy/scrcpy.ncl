{
  lib,
  drvs,
  scrcpy | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/Genymobile/scrcpy/archive/refs/tags/v4.0.tar.gz",
      sha256sum = "a62bc2639e1d56b3e7ebaa20d8deb4947dd02954b3362bdebe2ef9f7eae41b00",
    },
    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lc++",
      ],
    },
    extraMesonArgs = [
      "-Dstatic=true",
      "-Dcompile_server=false",
      "-Dprebuilt_server=/tmp/scrcpy-server",
    ],
    llvmProvider =
      drvs.llvmFull,

    biDrvs = [
      drvs.bash,
    ],
    pDrvs = [
      drvs.ffmpeg,
      drvs.libusb,
      drvs.sdl,
    ]
  }
}
