{
  lib,
  drvs,
  selinux | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/SELinuxProject/selinux/archive/refs/tags/3.11.tar.gz",
      sha256sum = "6ac2a91c05243895e69d5ecd182b78e3f90f09f0fed33933f0e026f4ed44cde6",
    },
    # enableCcache = false,
    buildEnv = {
      CC = "cc",
      EXTRA_CPPFLAGS = [
        "-Dwrite_full=semanage__write_full", #  Duplicate in shadow
      ],
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
      # "OPT_SUBDIRS=\"dbus gui mcstrans restorecond sandbox semodule-utils\"",
      "out_subdirs=\"dbus gui mcstrans python restorecond sandbox semodule-utils\"",
    ],
    makeTargets = [
      "install",
      "install-pywrap",
    ],
    preConfigurePhase =
      [
        m%"sed -i 's@Requires.private: libsepol @Requires.private: libsepol musl-fts libpcre2-8 @g' libselinux/src/libselinux.pc.in"%,
        m%"sed -i 's@"/sbin/ausearch"@"/usr/bin/ausearch"@g' python/sepolgen/src/sepolgen/audit.py"%,
        m%"sed -i 's@"/usr/sbin/seunshare"@"/usr/bin/seunshare"@g' sandbox/sandbox"%,
        m%"sed -i 's@"/usr/sbin@"/usr/bin@g' gui/booleansPage.py"%,
        m%"sed -i 's@"/usr/sbin@"/usr/bin@g' policycoreutils/run_init/run_init.c"%,
        m%"sed -i 's@"/sbin@"/usr/bin@g' libsemanage/src/genhomedircon.c"%,
        m%"sed -i 's@"/sbin@"/usr/bin@g' mcstrans/src/mcstransd.c"%,
        m%"sed -i 's@"/bin/dmesg"@"/usr/bin/dmesg"@g' python/sepolgen/src/sepolgen/audit.py"%,
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
      drvs.bash,
      drvs.bison,
      drvs.coreutils & { priority = 1 },
      drvs.docbookXml,
      drvs.docbookXslNons,
      drvs.flex,
      drvs.gettext,
      drvs.libxslt,
      drvs.linuxHeaders,
      drvs.m4,
      drvs.pkgconfMeson,
      drvs.pythonBuild,
      drvs.pythonFlitCore312,
      # drvs.pythonFull,
      # drvs.pythonInteractive,
      drvs.pythonDl,
      drvs.pythonGpep517,
      drvs.pythonHatchling,
      drvs.pythonHooks,
      drvs.pythonImportlibMetadate,
      drvs.pythonInstaller,
      drvs.pythonMako,
      drvs.pythonMarkupsafe,
      drvs.pythonPackaging,
      drvs.pythonPathspec,
      drvs.pythonPluggy,
      # drvs.pythonSetuptools80,
      drvs.pythonSetuptools80Static,
      drvs.pythonPip,
      drvs.pythonTroveClassifiers,
      drvs.xmlto,
      #   drvs.pythonFull,
      drvs.swig,
      drvs.selinuxCc,
    ],
    pDrvs = [
      #   drvs.pcre2,
      drvs.muslFts,
      drvs.bzip2,
      drvs.auditUserspace,
      drvs.glib,
      drvs.libcapNg,
    ],
  },
  pythonSetuptools80,
  pythonSetuptools80Static | lib.SetuptoolPackage =
    pythonSetuptools80
    & {

      postInstallPhase = [
        m%"sed -i 's@"cc", "-shared"@"ar", "-cr"@g' ${DEST}/usr/lib/python3.12/site-packages/setuptools/_distutils/unixccompiler.py"%,
        m%"sed -i 's@"cc", "-shared"@"ar", "-cr"@g' ${DEST}/usr/lib/python3.12/site-packages/setuptools/_distutils/compilers/C/unix.py"%,
      ],
    },
  selinuxCc | lib.Package = {
    installPhase = [
      "install -dm0755 ${DEST}/usr/bin",
      lib.functions.writeFile "${DEST}/usr/bin/cc" (import "cc.py" as 'Text),
      "chmod +x ${DEST}/usr/bin/cc",
    ]
  },

  pythonDl,

  # pythonSelinux | lib.AutotoolsPackage =
  #   pythonDl
  #   & {
  #     options.dlopen_src = (import "python_selinux_dlopen.c" as 'Text),
  #     buildEnv.EXTRA_LDFLAGS = [
  #       "$(pkg-config --libs --static libselinux)",
  #       "/usr/lib/python3.12/site-packages/selinux/_selinux.cpython-312-x86_64-linux-gnu.so",
  #     ],
  #     biDrvs | priority 2 =
  #       pythonDl.biDrvs
  #       @ [
  #         drvs.pythonFull,
  #       ],
  #     pDrvs = [
  #       drvs.selinux,
  #     ],
  #     allowDubplicateBuldInputs = true,
  #   }

  pythonInteractive,
  pythonSelinux | lib.AutotoolsPackage =
    pythonInteractive
    & {
      options = {
        dlopen_src | default = (import "python_selinux_dlopen.c" as 'Text),
      },
      buildEnv.EXTRA_LDFLAGS = [
        "$(pkg-config --libs --static libselinux libsemanage)",
        "/usr/lib/python3.12/site-packages/selinux/_selinux.cpython-312-x86_64-linux-gnu.so",
        "/usr/lib/python3.12/site-packages/_semanage.cpython-312-x86_64-linux-gnu.so",
        "/usr/lib/python3.12/site-packages/selinux/audit2why.cpython-312-x86_64-linux-gnu.so",
        "/usr/lib/python3.12/site-packages/setools/policyrep.cpython-312-x86_64-linux-gnu.so",
      ],
      preConfigurePhase | priority 1 = [
        lib.functions.writeFile "${SRC}/dlopen.c" options.dlopen_src,
        "${CC} ${CFLAGS} $(pkg-config --cflags python3) -Werror -c ${SRC}/dlopen.c -o ${BUILDDIR}/dlopen.o",
        "ar rcs ${BUILDDIR}/libdlopen.a ${BUILDDIR}/dlopen.o",
        "ranlib ${BUILDDIR}/libdlopen.a",
        # "export LDFLAGS=\"${LDFLAGS} ${BUILDDIR}/dlopen.o\"",
        "export LDFLAGS=\"${LDFLAGS} ${BUILDDIR}/libdlopen.a\"",
        # "export LDFLAGS=\"${LDFLAGS} -Wl,--allow-multiple-definition=dlopen\"",
      ],
      postInstallPhase = [
        m%"sed -i 's@/tmp/workdir/build/libdlopen.a@@g' ${DEST}/usr/lib/python3.12/_sysconfigdata__linux_x86_64-linux-gnu.py"%,
        m%"sed -i 's@/tmp/workdir/build/libdlopen.a@@g' ${DEST}/usr/lib/python3.12/config-3.12-x86_64-linux-gnu/Makefile"%,
      ],

      neverInclude = [
        drvs.musl
      ],
      biDrvs | priority 1 =
        pythonInteractive.biDrvs
        @ [
          drvs.muslBothRenamedDlRelease,
          drvs.pythonFull,
        ],

      pDrvs = [
        drvs.selinux,
        drvs.selinuxSetools,
      ],
      allowDubplicateBuldInputs = true,
    },
}
