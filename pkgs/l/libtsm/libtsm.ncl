{
  lib,
  drvs,
  libtsm | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/kmscon/libtsm/archive/refs/tags/v4.8.0.tar.gz",
      sha256sum = "50811e9e94fc798eb5dcbaff20f81067c942ec47f329f91bbe4caeb35a61ff05",
    },
    extraMesonArgs = [
      "-Dtests=false",
    ],
    preConfigurePhase = [
      m%"sed -i 's@shared_library@library@g' ${SRC}/src/tsm/meson.build"%,
    ],
  }
}
