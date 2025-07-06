{
  lib,
  gettext,
  intltool,
  perlXmlParserDynamic,
  muslShared,
  wayland,
  waylandProtocols,
  linuxHeaders,
  expat,
  libffi,
  perlDynamic,

  gammastep | lib.AutomakePackage = {
    singleSource = {
      uri = "https://gitlab.com/chinstrap/gammastep/-/archive/v2.0.9/gammastep-v2.0.9.tar.gz",
      sha256sum = "bbb9d90e1cf30920c1017db4ce5c4652e4c7843fd4c4e34164d99ecbc3bbb4c0"
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
    biDrvs =
      lib.biMap [
        gettext,
        intltool,
        #perl,
        perlXmlParserDynamic,
        muslShared,
        wayland,
        waylandProtocols,
        linuxHeaders,
        expat,
        libffi,
      ],
    perlProvider = lib.singleBiMap perlDynamic,
  }
}
& {
  lib,
  perlDynamic,
  perlXmlParserDynamic,
  muslShared,

  intltool | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://launchpad.net/intltool/trunk/0.51.0/+download/intltool-0.51.0.tar.gz",
      sha256sum = "67c74d94196b153b774ab9f89b2fa6c6ba79352407037c8c14d5aeb334e959cd"
    },
    biDrvs =
      lib.biMap [
        perlDynamic,
        perlXmlParserDynamic,
        muslShared,
      ]
  }
}
& {
  lib,
  perl,
  expat,

  perlXmlParser | lib.MakePackage = {
    singleSource = {
      uri = "http://search.cpan.org/CPAN/authors/id/T/TO/TODDR/XML-Parser-2.47.tar.gz",
      sha256sum = "ad4aae643ec784f489b956abe952432871a622d4e2b5c619e8855accbfc4d1d8"

      #uri =  "https://cpan.metacpan.org/authors/id/M/MS/MSERGEANT/XML-Parser-2.36.tar.gz",
      #sha256sum = "9fd529867402456bd826fe0e5588d35b3a2e27e586a2fd838d1352b71c2ed73f"
    },
    biDrvs =
      lib.biMap [
        perl,
        expat,
      ],
    preConfigurePhase = [
      "perl Makefile.PL LINKTYPE=static"
    ]
  }
}
& {
  lib,
  perlDynamic,
  muslShared,
  expat,

  perlXmlParser,
  perlXmlParserDynamic | lib.MakePackage = {
    singleSource = perlXmlParser.singleSource,
    biDrvs =
      lib.biMap [
        perlDynamic,
        muslShared,
        expat,
      ],
    preConfigurePhase = [
      "perl Makefile.PL"
    ],
    isStatic = false,
  }
}
& {
  lib,

  perl,
  perlXmlParser,
  expat,
  perlWithXmlParser | lib.AutotoolsPackage =
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
        @ lib.biMap [
          expat
        ]
    }
}
