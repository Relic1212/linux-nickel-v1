{
  lib,
  dbus,
  pcre2,
  libffi,
  zlibNg,
  glib,
  linuxHeaders,
  pkgconf,
  eudev,
  gperf,
  kmod,
  xz,
  utilLinux,
  readline,
  ncurses,
  jsonC,
  alsaLibs,

  bluez | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://www.kernel.org/pub/linux/bluetooth/bluez-5.79.tar.xz",
      sha256sum = "4164a5303a9f71c70f48c03ff60be34231b568d93a9ad5e79928d34e6aa0ea8a"
    },
    biDrvs =
      lib.biMap [
        dbus,
        pcre2,
        libffi,
        zlibNg,
        glib,
        linuxHeaders,
        pkgconf,
        eudev,
        gperf,
        kmod,
        xz,
        utilLinux,
        readline,
        ncurses,
        jsonC,
        alsaLibs,
      ],
    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lreadline",
        "-lncursesw"
      ]
    },
    extraEnv = {
      LIBS = buildEnv.EXTRA_LDFLAGS,
    },
    extraConfigureFlags = [
      "--disable-obex",
      "--disable-systemd",
      "--disable-cups",
      "--disable-manpages",
      "--enable-library",
    ],
    preConfigurePhase = [
      # m%"sed -i 's@MAX_INPUT@_POSIX_MAX_INPUT@g' ${SRC}/src/shared/util.c"%,
      m%"sed -i 's@MAX_INPUT@_POSIX_MAX_INPUT@g' ${SRC}/gdbus/object.c"%,
    ],
    preBuildPhase = [
      "sed -i 's@ -lreadline@ -lreadline -lncursesw@g' Makefile"
    ]
  }
}
& {
  lib,
  perl,

  libical | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/libical/libical/archive/refs/tags/v3.0.18.tar.gz",
      sha256sum = "72b7dc1a5937533aee5a2baefc990983b66b141dd80d43b51f80aced4aae219c"
    },
    biDrvs =
      lib.biMap [
        perl,
      ],
    cmakeArgsRecord = {
      "-DICAL_GLIB" = "false",
      "-DSTATIC_ONLY" = "true",
      "-DGOBJECT_INTROSPECTION" = "false",
      "-DICAL_GLIB_VAPI" = "false",
    }
  }
}
& {
  lib,
  bluez,
  alsaLibs,
  dbus,
  glib,
  pcre2,
  libffi,
  zlibNg,
  sbc,
  libsndfile,
  linuxHeaders,
  pythonFull,
  readline,
  ncurses,

  blueAlsa | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/arkq/bluez-alsa/archive/refs/tags/v4.3.1.tar.gz",
      sha256sum = "933fe898dfac21fdfeb5f4ffa685c2aa2db9c064d639170ac2652f156e956a2a",
      #uri ="https://github.com/arkq/bluez-alsa/archive/e77b82b9495abdc23ca4f983c284a494fb454719.zip",
      #sha256sum = "1",
    },
    biDrvs =
      lib.biMap [
        bluez,
        alsaLibs,
        dbus,
        glib,
        pcre2,
        libffi,
        zlibNg,
        sbc,
        libsndfile,
        linuxHeaders,
        pythonFull,
        readline,
        ncurses,
      ],
    extraConfigureFlags = [
      "--enable-cli"
    ]
  }
}
& {
  lib,
  libsndfile,
  pkgconf,
  linuxHeaders,

  sbc | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://www.kernel.org/pub/linux/bluetooth/sbc-2.0.tar.xz",
      sha256sum = "8f12368e1dbbf55e14536520473cfb338c84b392939cc9b64298360fd4a07992"
    },
    biDrvs =
      lib.biMap [
        libsndfile,
        pkgconf,
        linuxHeaders,
      ]
  }
}
& {
  lib,
  pythonFull,
  linuxHeaders,

  libsndfile | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://github.com/libsndfile/libsndfile/releases/download/1.2.2/libsndfile-1.2.2.tar.xz",
      sha256sum = "3799ca9924d3125038880367bf1468e53a1b7e3686a934f098b7e1d286cdb80e"
    },
    biDrvs =
      lib.biMap [
        pythonFull,
        linuxHeaders,
      ]
  }
}
