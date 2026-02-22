{
  lib,
  drvs,
  bluez | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://www.kernel.org/pub/linux/bluetooth/bluez-5.86.tar.xz",
      sha256sum = "99f144540c6070591e4c53bcb977eb42664c62b7b36cb35a29cf72ded339621d"
    },
    biDrvs = [
      drvs.dbus,
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.glib,
      drvs.linuxHeaders,
      drvs.pkgconf,
      drvs.eudev,
      drvs.gperf,
      drvs.kmod,
      drvs.xz,
      drvs.utilLinux,
      drvs.readline,
      drvs.ncurses,
      drvs.jsonC,
      drvs.alsaLibs,
      drvs.libical,
      drvs.pythonFull,
      drvs.docutils,
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
      "--enable-obex",
      "--disable-systemd",
      "--disable-cups",
      "--enable-manpages",
      "--enable-library",
      "--enable-deprecated",
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
  drvs,
  libical | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/libical/libical/archive/refs/tags/v3.0.18.tar.gz",
      sha256sum = "72b7dc1a5937533aee5a2baefc990983b66b141dd80d43b51f80aced4aae219c"
    },
    biDrvs = [
      drvs.perl,
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
  drvs,
  blueAlsa | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/arkq/bluez-alsa/archive/refs/tags/v4.3.1.tar.gz",
      sha256sum = "933fe898dfac21fdfeb5f4ffa685c2aa2db9c064d639170ac2652f156e956a2a",
      #uri ="https://github.com/arkq/bluez-alsa/archive/e77b82b9495abdc23ca4f983c284a494fb454719.zip",
      #sha256sum = "1",
    },
    biDrvs = [
      drvs.bluez,
      drvs.alsaLibs,
      drvs.dbus,
      drvs.glib,
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.sbc,
      drvs.libsndfile,
      drvs.linuxHeaders,
      drvs.pythonFull,
      drvs.readline,
      drvs.ncurses,
    ],
    extraConfigureFlags = [
      "--enable-cli"
    ]
  }
}
& {
  lib,
  drvs,
  sbc | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://www.kernel.org/pub/linux/bluetooth/sbc-2.0.tar.xz",
      sha256sum = "8f12368e1dbbf55e14536520473cfb338c84b392939cc9b64298360fd4a07992"
    },
    biDrvs = [
      drvs.libsndfile,
      drvs.pkgconf,
      drvs.linuxHeaders,
    ]
  }
}
& {
  lib,
  drvs,
  libsndfile | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://github.com/libsndfile/libsndfile/releases/download/1.2.2/libsndfile-1.2.2.tar.xz",
      sha256sum = "3799ca9924d3125038880367bf1468e53a1b7e3686a934f098b7e1d286cdb80e"
    },
    biDrvs = [
      drvs.pythonFull,
      drvs.linuxHeaders,
    ]
  }
}
