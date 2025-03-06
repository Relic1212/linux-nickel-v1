{
  lib,
  drvs,
  lisgd | lib.MakePackage = {
    singleSource = {
      uri = "https://git.sr.ht/~mil/lisgd/archive/2087fbe090509cfbe4d61ed1fccad886b14f0060.tar.gz",
      sha256sum = "0f6cd4fbdc72305173159102695f833573c29a13a91614e469346d0541ab8310"
    },
    biDrvs = [
      drvs.libinput,
      drvs.wayland,
      drvs.mtdev,
      drvs.libevdev,
      drvs.linuxHeaders,
      drvs.eudev,
      drvs.libffi,
    ],
    extraMakeArgs = [
      "WITHOUT_X11=1",
      "LDFLAGS='-static --static'",
      "LIBS='-lffi -levdev -linput -lwayland-client -ludev -lmtdev'",
    ],
    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lffi",
        "-levdev",
      ]
    }
  }
}
