{
  lib,
  drvs,
  gstreamer | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/gstreamer/gstreamer/-/archive/1.28.1/gstreamer-1.28.1.tar.bz2",
      sha256sum = "86ec0179104664a1ca6de57d7c886d3a8aa0491d1a243d02514b306885272b91",
    },
    extraMesonArgs = [
      "-Dgst-full-target-type=static_library",
      "-Dgst-plugins-bad:hip=disabled",
    ],
    preConfigurePhase = [
      m%"find ${SRC} -name meson.build | xargs sed -i 's|shared_library|library|g' "%
    ],
    postInstallPhase =
      std.array.map
        (fun p =>
          "llvm-objcopy --redefine-sym properties=gstreamer__properties ${DEST}%{p}"
        )
        [
          "/usr/lib/gstreamer-1.0/libgstcoreelements.a",
          "/usr/lib/gstreamer-1.0/libgstcoretracers.a",
          "/usr/lib/gstreamer-1.0/libgstges.a",
          "/usr/lib/gstreamer-1.0/libgstnle.a",
          "/usr/lib/gstreamer-1.0/libgstrtpmanager.a",
          "/usr/lib/gstreamer-1.0/libgstsctp.a",
          "/usr/lib/gstreamer-1.0/libgstunixfd.a",
          "/usr/lib/libges-1.0.a",
          "/usr/lib/libgstcontroller-1.0.a",
          "/usr/lib/libgstmse-1.0.a",
          "/usr/lib/libgstreamer-1.0.a",
          "/usr/lib/libgstreamer-full-1.0.a",
        ],
    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.flex,
      drvs.bison,
      drvs.m4,
      # drvs.linuxHeaders,
    ],
    pDrvs = [
      drvs.glib,
      drvs.mesa2,
    ]
  }
}
