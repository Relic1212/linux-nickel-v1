{
  lib,
  drvs,
  appstream | lib.MesonPackage = {
    singleSource = {
      uri = "https://www.freedesktop.org/software/appstream/releases/AppStream-1.0.3.tar.xz",
      sha256sum = "5ab6f6cf644e7875a9508593962e56bb430f4e59ae0bf03be6be7029deb6baa4"
    },

    biDrvs = [
      drvs.gperf,
      drvs.gettext,
    ],

    pDrvs = [
      drvs.glib,
      drvs.curl,
      drvs.libxml2,
      drvs.libyaml,
      drvs.libxmlb,
    ],

    # https://github.com/kiss-community/community/blob/153bd6c63fb8291b385e95d30da1dc6b9de87244/community/appstream/build

    preConfigurePhase = [
      ":>${SRC}/po/meson.build",
      ":>${SRC}/docs/meson.build",
      m%"sed -i 's@mo_targets\:\ i18n_result\[0\]\,@@g' ${SRC}/data/meson.build"%,
      m%"head -n26 ${SRC}/data/meson.build >> /tmp/meson.build"%,
      m%"tail -n16 ${SRC}/data/meson.build >> /tmp/meson.build"%,
      m%"mv ${SRC}/data/meson.build ${SRC}/data/meson.build.old"%,
      m%"mv /tmp/meson.build ${SRC}/data/meson.build"%,
      m%"sed -i "s@subdir('tests\/')@@g" ${SRC}/meson.build"%,
    ],

    extraMesonArgs = [
      "-Dstemming=false",
      "-Dsystemd=false",
      "-Dgir=false",
      "-Dsvg-support=false",
      "-Dzstd-support=false",
      "-Dapidocs=false",
      "-Dinstall-docs=false",
    ],

    buildEnv = {
      EXTRA_CPPFLAGS = ["-I/usr/include/libxml2"],
      EXTRA_CXXFLAGS = ["-I/usr/include/libxml2", ],
    },
  }
}
