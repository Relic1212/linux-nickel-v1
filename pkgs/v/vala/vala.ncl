{
  lib,
  pcre2,
  libffi,
  zlibNg,
  glib,
  pkgconf,
  bison,
  flex,
  m4,
  libtool,
  pythonDynamic,
  muslShared,
  gobjectDynamic,
  graphviz,

  vala | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://download.gnome.org/sources/vala/0.56/vala-0.56.17.tar.xz",
      sha256sum = "26100c4e4ef0049c619275f140d97cf565883d00c7543c82bcce5a426934ed6a"
    },

    biDrvs =
      lib.biMap [
        pcre2,
        libffi,
        zlibNg,
        glib,
        pkgconf,
        bison,
        flex,
        m4,
        libtool,
        pythonDynamic,
        muslShared,
        gobjectDynamic,
        graphviz,
      ]
  }
}
& {
  lib,
  bison,
  flex,
  pythonFull,

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
    biDrvs =
      lib.biMap [
        bison,
        flex,
        pythonFull,
      ]
  }
}
