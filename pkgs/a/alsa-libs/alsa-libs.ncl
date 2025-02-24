{
  lib,
  pkgs,
  alsaLibs | lib.AutotoolsPackage
    = {
      singleSource = {
        #https://www.alsa-project.org/wiki/Download

        # uri = "http://www.alsa-project.org/files/pub/lib/alsa-lib-1.2.12.tar.bz2",
        # sha256sum = "4868cd908627279da5a634f468701625be8cc251d84262c7e5b6a218391ad0d2",

        uri = "http://www.alsa-project.org/files/pub/lib/alsa-lib-1.2.13.tar.bz2",
        sha256sum = "8c4ff37553cbe89618e187e4c779f71a9bb2a8b27b91f87ed40987cc9233d8f6",
      },
      biDrvs = lib.biMap [pkgs.linuxHeaders],
      extraConfigureFlags = [
        "--without-libdl",
        "ac_cv_func_dlopen=no",
        "ac_cv_lib_dl_dlopen=no",
        "ac_cv_header_dlfcn_h=no",
        #  "--with-pic",
      ],
      buildEnv = {
        EXTRA_CFLAGS = ["-fPIC"],
        EXTRA_CXXFLAGS = ["-fPIC"],
        EXTRA_LDFLAGS = ["-fPIC"],
      },
      preConfigurePhase = [

        #Stolen from Stal-ix: https://github.com/stal-ix/ix/commit/f8e33398954fa0d7696618c02a2645bb47c64cfd
        m%"
      for file in $(find "${SRC}" -type -f ); do
          sed -i 's@ifndef PIC@if 1@g' "${file}"
      done
      "%,

      m%"
      fix_page_size() {
        sed -i 's@page_size@page_size_alsalibs_private@g' "${1}"
      }
      fix_page_size "${SRC}/src/rawmidi/rawmidi.c"
      fix_page_size "${SRC}/src/rawmidi/rawmidi_hw.c"
      fix_page_size "${SRC}/src/conf.c"
      fix_page_size "${SRC}/include/local.h"
      "%
      ]
    }
}
& {
  lib,
  drvs,
  alsaUtils | lib.AutotoolsPackage
    = {
      singleSource = {
        #https://www.alsa-project.org/wiki/Download

        # uri = "http://www.alsa-project.org/files/pub/lib/alsa-lib-1.2.12.tar.bz2",
        # sha256sum = "4868cd908627279da5a634f468701625be8cc251d84262c7e5b6a218391ad0d2",

        uri = "http://www.alsa-project.org/files/pub/utils/alsa-utils-1.2.13.tar.bz2",
        sha256sum = "1702a6b1cdf9ba3e996ecbc1ddcf9171e6808f5961d503d0f27e80ee162f1daa",
      },
      biDrvs = [
        drvs.linuxHeaders,
        drvs.alsaLibs,
        drvs.ncurses,
        drvs.readline,
        drvs.eudev,
        drvs.pkgconf,
      ],
      buildEnv = {
        EXTRA_CFLAGS = ["-fPIC"],
        EXTRA_CXXFLAGS = ["-fPIC"],
        EXTRA_LDFLAGS = ["-fPIC"],
      },
      extraConfigureFlags = [
        "--disable-nls",
        "--with-curses=ncursesw",
        # "--with-pic",
        "--without-libdl",
        "ac_cv_func_dlopen=no",
        "ac_cv_lib_dl_dlopen=no",
        "ac_cv_header_dlfcn_h=no",

        # from OE
        "--disable-bat",
        "--disable-xmlto",
        "--with-udev-rules-dir=`pkg-config --variable=udevdir udev`/rules.d",
      ],
    }
}
& {
  lib,
  drvs,
  alsaFirmware | lib.AutomakePackage
    = {
      singleSource = {
        uri = "http://www.alsa-project.org/files/pub/firmware/alsa-firmware-1.2.4.tar.bz2",
        sha256sum = "b67b6d7d08bcfc247ef6ff0ab88a99c188305a3cf57ae2dfd0bcd9a5b36cd5bb"
      },
      buildEnv,
      extraEnv = {
        CC_FOR_BUILD = buildEnv.CC,
        CFLAGS_FOR_BUILD = buildEnv.CFLAGS,
        LDFLAGS_FOR_BUILD = buildEnv.LDFLAGS,
      },
      separateBuildDir = false,
      extraConfigureFlags = [
        "--disable-nls",
        "--with-curses=ncursesw",
      ],
      preConfigurePhase = [
        m%"
        find ${SRC} -type f | xargs sed -i 's@u_int32_t@uint32_t@g'
        "%
      ],
      biDrvs = [
        # drvs.autoconf,
        # drvs.automake,
      ]
    }
}
