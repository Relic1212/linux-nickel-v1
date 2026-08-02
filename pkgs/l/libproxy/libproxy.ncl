{
  lib,
  drvs,
  libproxy | lib.MesonPackage = {
    singleSource = {
      # uri = "https://github.com/libproxy/libproxy/archive/refs/tags/0.5.12.tar.gz",
      # sha256sum = "a1fa55991998b80a567450a9e84382421a7176a84446c95caaa8b72cf09fa86f",
      uri = "https://github.com/libproxy/libproxy/archive/ca277f4b7f8f066483d5b2f8706cfd2de5830162.tar.gz",
      sha256sum = "0df6521df1efaecbf566bf9a870ee3393cbf68f71b0d6d5e21b6c9da753e0314",
    },

    extraMesonArgs = [
      "-Ddocs=false",
      "-Dtests=false",
      "-Dconfig-windows=false",
      "-Dconfig-osx=false",
      "-Dconfig-kde=false",
      "-Dvapi=false",
      "-Dintrospection=false",
    ],
    preConfigurePhase = [
      m%"sed -i s'@bin/bash@usr/bin/bash@g' ${SRC}/data/*"%,
      # m%"sed -i "s@shared_library@library@g" ${SRC}/src/libproxy/meson.build"%,
      m%"sed -i "s@shared_library@library@g" ${SRC}/src/backend/meson.build"%,
    ],
    pDrvs = [
      # drvs.glib,
      drvs.curl,
      drvs.gsettingsDesktopSchemas,
      drvs.duktape,
      drvs.bash,
    ],
  }
}
