{
  lib,
  drvs,
  vala | lib.AutotoolsPackage = {
    singleSource = {
      # uri = "https://download.gnome.org/sources/vala/0.56/vala-0.56.17.tar.xz",
      # sha256sum = "26100c4e4ef0049c619275f140d97cf565883d00c7543c82bcce5a426934ed6a",
      # uri = "https://gitlab.gnome.org/GNOME/vala/-/archive/0.56.19/vala-0.56.19.tar.bz2",
      # sha256sum = "69240bbf64c38f366cc31d40f038e694f9254c60ed32b8aed086e8686ba78016"
      uri = "https://download.gnome.org/sources/vala/0.56/vala-0.56.19.tar.xz",
      sha256sum = "5ad7cbbfcc0de61b403d6797c9ef60455bfbebd8e162aec33b5b0b097adfb9d5",
    },

    biDrvs = [
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.glib,
      drvs.pkgconf,
      drvs.bison,
      drvs.flex,
      drvs.m4,
      drvs.libtool,
      drvs.pythonDynamic,
      drvs.muslShared,
      drvs.gobjectDynamic,
      drvs.graphviz,
    ]
  },
  valaDoc1 =
    vala
    & {
      buildEnv.EXTRA_LDFLAGS = [
        "/tmp/workdir/src/dlopen.o",
        "/tmp/workdir/src/weak.o",
      ],
      extraConfigureFlags = [
        "--enable-valadoc",
      ],
      preConfigurePhase = [
        lib.functions.writeFile "${SRC}/dlopen.c" (import "vala_dlopen.c" as 'Text),
        lib.functions.writeFile "${SRC}/weak.c" (import "vala_weak.c" as 'Text),
        "${CC} ${CFLAGS} -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
        "${CC} ${CFLAGS} -c ${SRC}/weak.c -o ${SRC}/weak.o",
      ],
      postInstallPhase = [
        "touch ${DEST}/usr/lib/valadoc-0.56/doclets/html/libdoclet.so",
      ],
      muslProvider = drvs.muslBothRenamedDl,
    },
  valaDoc =
    valaDoc1
    & {
      buildEnv.EXTRA_LDFLAGS | priority 1 = [
        "$(pkg-config --libs --static valadoc-0.56)",
        "/usr/lib/vala-0.56/libvalaccodegen.a",
        "-lltdl",
        "-lxdot",
        "-lpathplan",
        "/tmp/workdir/src/dlopen.o",
        # "/tmp/workdir/src/weak.o",
        "/usr/lib/valadoc-0.56/doclets/html/libdoclet.a",
      ],
      biDrvs | priority 1 =
        valaDoc1.biDrvs
        @ [
          drvs.valaDoc1,
        ]
    },
  valaShared | lib.AutomakePackage = {
    singleSource = vala.singleSource,
    # singleSource = {
    #   uri = "https://gitlab.gnome.org/GNOME/vala/-/archive/0.56.18/vala-0.56.18.tar.bz2",
    #   sha256sum = "702e82db5cd462870a5d30ac3da415dd7156b084920b2e41e7ec61d36e2b5b98",
    # },
    isLlvm,
    biDrvs =
      [
        drvs.pcre2,
        drvs.libffi,
        drvs.zlibNg,
        drvs.glibDynamic,
        # drvs.pkgconf,
        drvs.bison,
        drvs.flex,
        # drvs.m4,
        # drvs.libtool,
        drvs.pythonDynamic,
        drvs.muslShared,
        drvs.gobjectDynamic,
        drvs.graphvizPic,
        drvs.bash,
        drvs.bashSh & { priority = 1 },
        drvs.autoconfArchive,
        drvs.vala,
      ]
      @ (
        if isLlvm then
          []
        else
          [
            drvs.gcc,
            drvs.binutils,
          ]
      ),

    isStatic = false,
    buildEnv = {
      _isStatic = false,
      # _isLlvm = false,
      # EXTRA_LDFLAGS = [
      #   "-lpcre2-posix",
      #   "-lpcre2-8 -lffi"
      # ],
      EXTRA_CFLAGS = ["--verbose"],
    },
    # extraEnv = {
    #   LIBS = buildEnv.EXTRA_LDFLAGS
    # },
    # llvmProvider = drvs.llvmFullPic,
    separateBuildDir = false,
    # enableParallel = false,
    extraConfigureFlags = [
      "--enable-static",
      "--enable-shared",
      # "--disable-shared",
    ],
    # preConfigurePhase =[
    #   "touch ${SRC}/ChangeLog",
    # ],
    # extraMakeArgs = [
    #   "LDFLAGS=\"%{std.string.join " " buildEnv.LDFLAGS}\"",
    #   "LIBS=\"%{std.string.join " " buildEnv.LDFLAGS}\"",
    # ]
  }
}
& {
  lib,
  drvs,
  graphviz | lib.AutomakePackage = {
    singleSource = {
      uri = "https://gitlab.com/graphviz/graphviz/-/archive/12.2.0/graphviz-12.2.0.tar.bz2",
      sha256sum = "56090fb1e5986919d6099041871744d84231d632f8649ea07028052a5487d444"
    },
    separateBuildDir = false,
    configureScript,
    configureFlags,
    configurePhase = [
      "(cd ${SRC}; ./autogen.sh)",
      configureScript ++ " " ++ (std.string.join lib.constants.buildFlagSep configureFlags),
    ],
    biDrvs = [
      drvs.bison,
      drvs.flex,
      drvs.pythonFull,
    ]
  },
  graphvizPic =
    graphviz
    & {
      buildEnv.EXTRA_CFLAGS = ["-fPIC"],
      extraConfigureFlags = [
        "--enable-pic"
      ]
    }
}
