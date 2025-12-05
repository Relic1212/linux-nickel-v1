{
  lib,
  drvs,
  vala | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://download.gnome.org/sources/vala/0.56/vala-0.56.17.tar.xz",
      sha256sum = "26100c4e4ef0049c619275f140d97cf565883d00c7543c82bcce5a426934ed6a"
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
  valaDoc =
    vala
    & {
      extraConfigureFlags = [
        "--enable-valadoc",
      ],
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
