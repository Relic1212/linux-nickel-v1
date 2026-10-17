{
  lib,
  drvs,
  dbusmenuGtk | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://launchpad.net/libdbusmenu/16.04/16.04.0/+download/libdbusmenu-16.04.0.tar.gz",
      sha256sum = "b9cc4a2acd74509435892823607d966d424bd9ad5d0b00938f27240a1bfa878a"
    },
    llvmProvider = drvs.llvmFull,
    # perlProvider = drvs.perlDynamic,
    # 
    biDrvs = [
      drvs.muslShared,
      drvs.intltool,

      ## py
      drvs.pythonFull,
      ## -py

      ### autotools ###
      # drvs.perl,
      drvs.perlDynamic,
      drvs.perlXmlParserDynamic,
      drvs.gettext,
      drvs.bison,
      drvs.flex,
      drvs.m4,
      drvs.pkgconf,
      drvs.libtool,

      ### END autotools ##
      drvs.gtkDoc,
    ],
    pDrvs = [
      drvs.gtk3,
      drvs.gudev,
      # drvs.vala,
      drvs.libpsl,
      drvs.libxml2,
      drvs.jsonGlib,
      drvs.libyaml,
      drvs.libxmlb,
      drvs.libvorbis,
      drvs.libogg,
      ## -X
    ],
    extraConfigureFlags = [
      "--with-gtk=3",
      "--disable-dumper",
      "--enable-introspection=no",
      "--disable-vala",
    ]
  }
}
