{
  lib,
  drvs,
  gstreamer | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/gstreamer/gstreamer/-/archive/1.28.1/gstreamer-1.28.1.tar.bz2",
      sha256sum = "86ec0179104664a1ca6de57d7c886d3a8aa0491d1a243d02514b306885272b91"
    },
    extraMesonArgs = [
      "-Dgst-full-target-type=static_library",
    ],
    preConfigurePhase = [
      m%"find ${SRC} -name meson.build | xargs sed -i 's|shared_library|library|g' "%
    ],
    biDrvs = [
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.glib,
      drvs.flex,
      drvs.bison,
      drvs.m4,
      drvs.linuxHeaders,
    ],
  }
}
