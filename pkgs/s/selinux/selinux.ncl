{
  lib,
  drvs,
  selinux | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/SELinuxProject/selinux/archive/refs/tags/3.11.tar.gz",
      sha256sum = "6ac2a91c05243895e69d5ecd182b78e3f90f09f0fed33933f0e026f4ed44cde6",
    },
    buildEnv = {
      EXTRA_LDFLAGS = [
        "-Wl,--undefined-version",
        "$(pkg-config --libs --static musl-fts)",
      ],
    },
    extraEnv = {
      PKG_CONFIG_PATH = "/usr/lib/pkgconfig:/tmp/workdir/out/destdir/usr/lib/pkgconfig",
    },
    enableParallel = false,
    extraMakeArgs = [
      "DESTDIR=${DEST}",
      "DISABLE_SHARED=y",
      "SBINDIR=/usr/bin",
      "OPT_SUBDIRS=\"dbus gui mcstrans restorecond sandbox semodule-utils\"",
      #   "out_subdirs=\"dbus gui mcstrans python restorecond sandbox semodule-utils\"",
    ],
    makeTargets = [
      "install",
    ],
    preConfigurePhase =
      [
        m%"sed -i 's@Requires.private: libsepol @Requires.private: libsepol musl-fts libpcre2-8 @g' libselinux/src/libselinux.pc.in"%,
      ]
      @ (
        std.array.map
          (fun s => m%"sed -i 's@globbuf.%{s}@// globbuf.%{s}@g' restorecond/watch.c"%
          )
          [
            "gl_opendir",
            "gl_readdir",
            "gl_closedir",
            "gl_lstat",
            "gl_stat",
          ]
      )
      @ [
        m%"sed -i 's@| GLOB_ALTDIRFUNC@@g' restorecond/watch.c"%,
      ],
    installPhase = [],
    biDrvs = [
      drvs.flex,
      drvs.m4,
      drvs.bison,
      drvs.linuxHeaders,
      drvs.pkgconfMeson,
      drvs.pythonFull,
      drvs.pythonInstaller,
      drvs.pythonSetuptools80,
      drvs.coreutils & { priority = 1 },
      drvs.xmlto,
      drvs.bash,
      drvs.libxslt,
      drvs.docbookXslNons,
      drvs.docbookXml,
      drvs.gettext,
      #   drvs.pythonFull,
    ],
    pDrvs = [
      #   drvs.pcre2,
      drvs.muslFts,
      drvs.bzip2,
      drvs.auditUserspace,
      drvs.glib,
      drvs.libcapNg,
    ],
  }
}
