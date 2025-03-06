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
  }
}
