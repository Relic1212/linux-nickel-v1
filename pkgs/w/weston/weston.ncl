{
  lib,
  drvs,
  weston | lib.MesonPackage = {
    sourceInputs = [
      {
        src = {
          uri = "https://gitlab.freedesktop.org/wayland/weston/-/archive/14.0.1/weston-14.0.1.tar.gz",
          sha256sum = "0cd789cf0a2a4db43733078bc69d99c296cf79c7cbed439af8593359e3a97678",
        }
      },
    ],
    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.expat,
      drvs.jsonC,
      drvs.pcre2,
      drvs.mesa2,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.libelf,
      drvs.libpciaccess,
      drvs.libdrm,
      drvs.libxkbcommon,
      drvs.pixman,
      drvs.eudev,
      #drvs.libudevZero,
      drvs.seatd,
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
      drvs.libxml2,
    ],

    preConfigurePhase = [
      m%"
            for f in $(find ${SRC} -type f -name '*.c'; find ${SRC} -type f -name '*.h' ); do
                sed -i \
                    's@os_create_anonymous_file@os_create_anonymous_file_weston_private@g' \
                    ${f}
            done
            "%
    ],

    extraMesonArgs = [
      "-Dimage-jpeg=false",
      "-Dimage-webp=false",
      "-Dtests=false",
      "-Dtest-junit-xml=false",
      "-Dpipewire=false",
      "-Dremoting=false",
      "-Dsystemd=false",
      "-Dxwayland=false",
      "-Dbackend-x11=false",
      "-Dbackend-pipewire=false",
      "-Dbackend-rdp=false",
      "-Dbackend-vnc=false",
      "-Dcolor-management-lcms=false",
      "-Dbackend-drm-screencast-vaapi=false",
    ],

    buildEnv = {
      EXTRA_LDFLAGS = ["-lc++"],
      EXTRA_CPPFLAGS = ["-I/usr/include/libxml2"],
      EXTRA_CXXFLAGS = ["-I/usr/include/libxml2", ],
    }
  }
}
