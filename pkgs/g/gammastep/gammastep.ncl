{
  lib,
  drvs,
  gammastep | lib.AutomakePackage = {
    singleSource = {
      uri = "https://gitlab.com/chinstrap/gammastep/-/archive/v2.0.11/gammastep-v2.0.11.tar.gz",
      sha256sum = "e16026b8f21d5e02cfe7cd2f738c80f150c1f06a098e5e47e0fc088244a763bd"
    },
    separateBuildDir = false,
    configureScript,
    configureFlags,

    extraConfigureFlags = [
      "--enable-wayland",
    ],

    configurePhase = [
      #"(cd ${SRC}; autoreconf -fiv)",
      "cd ${SRC}",
      "./bootstrap",
      configureScript ++ " " ++ (std.string.join lib.constants.buildFlagSep configureFlags),
    ],
    biDrvs = [
      drvs.gettext,
      drvs.intltool,
      #drvs.perl,
      drvs.perlXmlParserDynamic,
      drvs.muslShared,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.linuxHeaders,
      drvs.expat,
      drvs.libffi,
    ],
    perlProvider = drvs.perlDynamic,
  }
}
& {
  lib,
  drvs,
  intltool | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://launchpad.net/intltool/trunk/0.51.0/+download/intltool-0.51.0.tar.gz",
      sha256sum = "67c74d94196b153b774ab9f89b2fa6c6ba79352407037c8c14d5aeb334e959cd"
    },
    biDrvs = [
      drvs.perlDynamic,
      drvs.perlXmlParserDynamic,
      drvs.muslShared,
    ]
  }
}
& {
  lib,
  drvs,
  perlXmlParser | lib.MakePackage = {
    singleSource = {
      uri = "http://search.cpan.org/CPAN/authors/id/T/TO/TODDR/XML-Parser-2.47.tar.gz",
      sha256sum = "ad4aae643ec784f489b956abe952432871a622d4e2b5c619e8855accbfc4d1d8"

      #uri =  "https://cpan.metacpan.org/authors/id/M/MS/MSERGEANT/XML-Parser-2.36.tar.gz",
      #sha256sum = "9fd529867402456bd826fe0e5588d35b3a2e27e586a2fd838d1352b71c2ed73f"
    },
    biDrvs = [
      drvs.perl,
      drvs.expat,
    ],
    preConfigurePhase = [
      "perl Makefile.PL LINKTYPE=static"
    ]
  }
}
& {
  lib,
  drvs,
  perlXmlParser,
  perlXmlParserDynamic | lib.MakePackage = {
    singleSource = perlXmlParser.singleSource,
    biDrvs = [
      drvs.perlDynamic,
      drvs.muslShared,
      drvs.expat,
    ],
    preConfigurePhase = [
      "perl Makefile.PL"
    ],
    isStatic = false,
  }
}
& {
  lib,
  drvs,
  perl,
  perlXmlParser,
  perlWithXmlParser =
    perl
    & {
      sourceInputs | priority 1 =
        perl.sourceInputs
        @ [
          {
            src = perlXmlParser.singleSource,
            dest = "tmp-ext/XML-Parser"
          }
        ],
      # https://github.com/stal-ix/ix/blob/7fca6663c1c6ed22b4c52ba9faf3bb46377beae3/pkgs/bld/perl/full/ix.sh#L6

      configurePhase | priority 1 = [
        "cd ${SRC}",
        m%"
    f() {
        ./Configure \
    -Dprefix=/usr \
    -Dcc='clang -static' \
    -Dlddlflags='-static -O2 -fstack-protector-strong' \
    -Dvendorprefix=/usr  -Dusevendorprefix \
    -Uusedl \
    -Dd_access=true \
    -Dd_eaccess='undef' \
    -Dlocincpth=' ' \
    -des
    }
    "%,
        "f",
        "make depend -j1",
        "mv tmp-ext/XML-Parser ext/XML-Parser",
        "(cd ext; ln -s XML-Parser/Expat XML-Parser-Expat)",
        "f",
        m%"echo 'export static_ext="$static_ext XML/Parser/Expat"' >> config.sh"%,
        "make depend -j1",
      ],
      biDrvs | priority 1 =
        perl.biDrvs
        @ [
          drvs.expat
        ]
    }
}
