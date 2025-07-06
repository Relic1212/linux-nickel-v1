{
  lib,
  expat,
  jsonC,
  pcre2,
  mesa2,
  wayland,
  waylandProtocols,
  libelf,
  libpciaccess,
  libdrm,
  libxkbcommon,
  pixman,
  eudev,
  seatd,
  libdisplayinfo,
  libinput,
  libffi,
  libevdev,
  mtdev,
  pango,
  cairo,
  libpng,
  freetype,
  fontconfig,
  zlibNg,
  harfbuzz,
  glib,
  hwdata,
  linuxHeaders,
  libxml2,
  llvmFull,

  weston | lib.MesonPackage = {
    sourceInputs = [
      {
        src = {
          uri = "https://gitlab.freedesktop.org/wayland/weston/-/archive/14.0.1/weston-14.0.1.tar.gz",
          sha256sum = "0cd789cf0a2a4db43733078bc69d99c296cf79c7cbed439af8593359e3a97678",
        }
      },
    ],
    llvmProvider = lib.singleBiMap llvmFull,
    biDrvs =
      lib.biMap [
        expat,
        jsonC,
        pcre2,
        mesa2,
        wayland,
        waylandProtocols,
        libelf,
        libpciaccess,
        libdrm,
        libxkbcommon,
        pixman,
        eudev,
        #libudevZero,
        seatd,
        libdisplayinfo,
        libinput,
        libffi,
        libevdev,
        mtdev,
        pango,
        cairo,
        libpng,
        freetype,
        fontconfig,
        zlibNg,
        harfbuzz,
        glib,
        hwdata,
        linuxHeaders,
        libxml2,
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
