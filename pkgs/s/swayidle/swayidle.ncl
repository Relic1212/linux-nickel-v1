{
  lib,
  zlibNg,
  wayland,
  waylandProtocols,
  libffi,
  libxkbcommon,
  expat,
  scdoc,

  swayidle | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/swaywm/swayidle/archive/f13cefacc788f4977ffcd3be012c29e81a4cdda9.zip",
      sha256sum = "cfab57985f61502d0e40e8eb5587616b06e31cba9fa174157a678a9afa143760",
    },
    biDrvs =
      lib.biMap [
        zlibNg,
        wayland,
        waylandProtocols,
        libffi,
        libxkbcommon,
        expat,
        scdoc
      ],
  }
}
& {
  lib,
  zlibNg,
  wayland,
  waylandProtocols,
  libffi,
  libxkbcommon,
  expat,
  pixman,
  freetype,
  fontconfig,
  libpng,
  cairo,
  scdoc,

  swaylock | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/swaywm/swaylock/releases/download/v1.8.0/swaylock-1.8.0.tar.gz",
      sha256sum = "6a1175442380b87b2d2868c4a5366ee3592163158d02e3a7fbf3a0bfe07d8b00",
    },
    biDrvs =
      lib.biMap [
        zlibNg,
        wayland,
        waylandProtocols,
        libffi,
        libxkbcommon,
        expat,
        pixman,
        freetype,
        fontconfig,
        libpng,
        cairo,
        scdoc
      ],
  }
}
