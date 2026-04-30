{
  lib,
  drvs,

  _CargoFetcher,
  draftwmSources | lib.DeterministicFetcher =
    _CargoFetcher
    & {
      singleSource = {
        uri = "https://github.com/malbiruk/driftwm/archive/refs/tags/v0.1.1.tar.gz",
        sha256sum = "752d7f91dfbd291e90b8a1f7a8fe3b621a9c17ea5cc969a87e0627ffe731ccd9",
      },

      outputSha256sum = "d097f646b0693acc678de135bbd2c217eb863751109b6f1339988e846b318f7d",
    },

  driftwm | lib.CargoPackage = {
    # enableSccache = false,

    extraEnv = {
      EXTRA_RUSTFLAGS = [
        "-C link-arg=-lc++",
        m%"$(for l in $(pkg-config --libs --static libevdev mtdev libcap);do printf " -C link-arg=$l ";done)"%,
      ],
    },

    unpackPhase = [
      "cd /tmp/workdir/src",
      "tar xf /sources.tar",
    ],
    preConfigurePhase = [],
    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.draftwmSources,
      drvs.expat,
      drvs.jsonC,
      drvs.pcre2,
      drvs.mesa2,
      drvs.spirvTools,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.libelf,
      drvs.libpciaccess,
      drvs.libdrm,
      drvs.libxkbcommon,
      drvs.pixman,
      drvs.eudev,
      drvs.libdisplayinfo,
      drvs.libinput,
      drvs.libffi,
      drvs.libevdev,
      drvs.mtdev,
      drvs.pango,
      drvs.cairo,
      drvs.libpng,
      drvs.freetype,
      drvs.fontconfig,
      drvs.zlibNg,
      drvs.harfbuzz,
      drvs.glib,
      drvs.hwdata,
      drvs.linuxHeaders,
      drvs.gdkPixbufFull,
      drvs.libjpegTurbo,
      drvs.basu,
      drvs.lcms,
      drvs.scdoc,
      ##

      ##
      drvs.musl & { priority = 1 },
    ],

    propagatedBuildInputs = [
      drvs.seatd,
    ]
  }
}
