{
  lib,
  drvs,
  iputils | lib.MesonPackage
    = {
      singleSource = {
        uri = "https://github.com/iputils/iputils/releases/download/20240905/iputils-20240905.tar.gz",
        sha256sum = "599cda8e3f5f7ce4c612456ab1101369da8f79aa0f83c8e877290a1c7bb56010",
      },
      biDrvs = [
        drvs.libcap,
        drvs.linuxHeaders,
      ],
      extraMesonArgs = [
        "-DUSE_IDN=false",
        "-DNO_SETCAP_OR_SUID=true",
        "-DBUILD_MANS=false",
        "-DBUILD_HTML_MANS=false",
        "-DUSE_GETTEXT=false",
        "-DSKIP_TESTS=true",
      ]
    }
}
