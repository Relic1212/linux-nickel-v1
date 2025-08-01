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
    # symlinkBuldInputs = true,
    biDrvs = [
      drvs.fontconfig,
      drvs.freetype,
      drvs.zlibNg,
      drvs.gperf,
      drvs.pixman,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.libffi,
      drvs.libxkbcommon,
      drvs.expat,
      drvs.linuxHeaders,
      drvs.ncurses,
      drvs.readline,
      drvs.pcre2,
      drvs.pango,
      drvs.cairo,
      drvs.libpng,
      drvs.harfbuzz,
      drvs.glibDynamic,
      drvs.muslShared,
      drvs.hwdata,
      drvs.gobjectDynamic,
      drvs.cairoGobject,
      drvs.fribidi,
      drvs.gdkPixbufFull,
      drvs.libjpegTurbo,
      drvs.libepoxy,
      drvs.atSpi2Core,
      drvs.mesa2,
      drvs.libelf,
      drvs.libdrm,
      drvs.libpciaccess,
      drvs.llvmConfigStatic,
      drvs.spirvTools,
      drvs.spirvLlvmTranslator,
      drvs.gtk3,
      drvs.eudev,
      drvs.kmod,
      drvs.xz,
      drvs.openssl,
      drvs.zstd,
      drvs.utilLinux,
      drvs.gsettingsDesktopSchemas,
      drvs.xkeyboardConfig,
      drvs.isoCodes,
      drvs.libseccomp,
      drvs.intltool,

      ## py
      drvs.pythonDynamicPic,
      drvs.pythonSetuptools,
      drvs.pythonInstaller,
      drvs.pythonGpep517,
      drvs.pythonFlitCore,
      drvs.pythonHatchling,
      drvs.pythonPathspec,
      drvs.pythonPluggy,
      drvs.pythonImportlibMetadate,
      drvs.pythonMako,
      drvs.pythonPackaging,
      drvs.pythonMarkupsafe,
      drvs.pythonTroveClassifiers,
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
      drvs.gudev,
      drvs.vala,
      drvs.libpsl,
      drvs.libxml2,
      drvs.jsonGlib,
      drvs.libyaml,
      drvs.libxmlb,
      drvs.libvorbis,
      drvs.libogg,
      drvs.libcanberra,
      drvs.gsound,

      ## X
      drvs.libxcursor,
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.xtrans,
      drvs.libxcb,
      drvs.xcbProto,
      drvs.libxau,
      drvs.libx11,
      drvs.libxrender,
      drvs.libxfixes,
      drvs.xcbRenderutil,
      drvs.libxfont2,
      drvs.libfontenc,
      drvs.libxcvt,
      drvs.libxshmfence,
      drvs.xwayland,
      drvs.libxkbfile,
      drvs.xcbUtilWm,
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
& {
  lib,
  drvs,
  gtkDoc | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.gnome.org/GNOME/gtk-doc/-/archive/1.34.0/gtk-doc-1.34.0.tar.gz",
      sha256sum = "e1d544fa70ae60014a241b674c9d989f4ad6a96554652ebf73bbe94b4da1aa35",
    },
    # symlinkBuldInputs = true,
    llvmProvider = drvs.llvmFull,
    pythonProvider | priority 2 = drvs.pythonDynamicPic,
    biDrvs = [
      drvs.fontconfig,
      drvs.freetype,
      drvs.zlibNg,
      drvs.gperf,
      drvs.pixman,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.libffi,
      drvs.libxkbcommon,
      drvs.expat,
      drvs.linuxHeaders,
      drvs.ncurses,
      drvs.readline,
      drvs.pcre2,
      drvs.pango,
      drvs.cairo,
      drvs.libpng,
      drvs.harfbuzz,
      drvs.glibDynamic,
      drvs.muslShared,
      drvs.hwdata,
      drvs.gobjectDynamic,
      drvs.cairoGobject,
      drvs.fribidi,
      drvs.gdkPixbufFull,
      drvs.libjpegTurbo,
      drvs.libepoxy,
      drvs.atSpi2Core,
      drvs.mesa2,
      drvs.libelf,
      drvs.libdrm,
      drvs.libpciaccess,
      drvs.llvmConfigStatic,
      drvs.spirvTools,
      drvs.spirvLlvmTranslator,
      drvs.gtk3,
      drvs.eudev,
      drvs.kmod,
      drvs.xz,
      drvs.openssl,
      drvs.zstd,
      drvs.utilLinux,
      drvs.gsettingsDesktopSchemas,
      drvs.xkeyboardConfig,
      drvs.isoCodes,
      drvs.libseccomp,
      drvs.intltool,
      # drvs.pythonFull,
      drvs.libxslt,
      drvs.libxml2DynamicCmake,
      drvs.libxmlb,
      drvs.gettext,
      drvs.docbookXml,
      # drvs.docbookXsl,
      drvs.pythonPygments,
      drvs.pythonSetuptools,
      drvs.pythonInstaller,
      drvs.pythonGpep517,
      drvs.pythonFlitCore,
      drvs.pythonHatchling,
      drvs.pythonPathspec,
      drvs.pythonPluggy,
      drvs.pythonImportlibMetadate,
      drvs.pythonMako,
      drvs.pythonPackaging,
      drvs.pythonMarkupsafe,
      drvs.pythonTroveClassifiers,
      drvs.itstool,
    ],
  }
}
& {
  lib,
  drvs,
  pythonPygments | lib.Package = {
    singleSource = {
      uri = "https://github.com/pygments/pygments/archive/refs/tags/2.19.2.tar.gz",
      sha256sum = "542e317dffd5287585b7bc4327969fe2f8d4b7ccec0b46045a83ef45dc840ed9"
    },
    buildPhase = [
      "cd ${SRC}",
      "gpep517 build-wheel --wheel-dir .dist --output-fd 3 3>&1 >&2",
      "python -m installer -d ${DEST} .dist/*.whl",
    ],
    biDrvs = [
      drvs.pythonFull,
      drvs.pythonSetuptools,
      drvs.pythonInstaller,
      drvs.pythonGpep517,
      drvs.pythonFlitCore,
      drvs.pythonHatchling,
      drvs.pythonPathspec,
      drvs.pythonPluggy,
      drvs.pythonImportlibMetadate,
      drvs.pythonMako,
      drvs.pythonPackaging,
      drvs.pythonMarkupsafe,
      drvs.pythonTroveClassifiers,
    ]
  }
}
& {
  lib,
  drvs,
  pythonHatchling | lib.Package = {
    # https://github.com/alpinelinux/aports/blob/master/main/py3-hatchling/APKBUILD
    singleSource = {
      uri = "https://files.pythonhosted.org/packages/py3/h/hatchling/hatchling-1.27.0-py3-none-any.whl",
      sha256sum = "d3a2f3567c4f926ea39849cdf924c7e99e6686c9c8e288ae1037c8fa2a5d937b"
    },
    installPhase = [
      m%"python -m installer -d ${DEST} ${SRC}/hatchling-1.27.0-py3-none-any.whl"%
    ],
    biDrvs = [
      drvs.pythonFull,
      drvs.pythonInstaller,
      drvs.pythonSetuptools,
    ],
  }
}
& {
  lib,
  drvs,
  pythonPathspec | lib.Package = {
    # https://github.com/alpinelinux/aports/blob/master/main/py3-pathspec/APKBUILD
    singleSource = {
      uri = "https://files.pythonhosted.org/packages/source/p/pathspec/pathspec-0.12.1.tar.gz",
      sha256sum = "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
    },
    separateBuildDir = false,
    buildPhase = [
      "gpep517 build-wheel --wheel-dir .dist --output-fd 3 3>&1 >&2",
    ],
    installPhase = [
      m%"python -m installer -d ${DEST} .dist/*.whl"%
    ],
    biDrvs = [
      drvs.pythonFull,
      drvs.pythonSetuptools,
      drvs.pythonInstaller,
      drvs.pythonGpep517,
      drvs.pythonFlitCore,
    ],
  }
}
& {
  lib,
  drvs,
  pythonPluggy | lib.Package = {
    # https://github.com/alpinelinux/aports
    singleSource = {
      uri = "https://files.pythonhosted.org/packages/75/21/cdabca0144cfa282c2893dc8e07957245ac8657896ef3ea26f18b6fda710/pluggy-0.12.0.tar.gz",
      sha256sum = "0825a152ac059776623854c1543d65a4ad408eb3d33ee114dff91e57ec6ae6fc"
    },
    separateBuildDir = false,
    buildPhase = [
      "gpep517 build-wheel --wheel-dir .dist --output-fd 3 3>&1 >&2",
    ],
    installPhase = [
      m%"python -m installer -d ${DEST} .dist/*.whl"%
    ],
    biDrvs = [
      drvs.pythonFull,
      drvs.pythonSetuptools,
      drvs.pythonInstaller,
      drvs.pythonGpep517,
      drvs.pythonFlitCore,
    ],
  }
}
& {
  lib,
  drvs,
  pythonImportlibMetadate | lib.Package = {
    # https://github.com/alpinelinux/aports
    singleSource = {
      uri = "https://files.pythonhosted.org/packages/76/66/650a33bd90f786193e4de4b3ad86ea60b53c89b669a5c7be931fac31cdb0/importlib_metadata-8.7.0.tar.gz",
      sha256sum = "d13b81ad223b890aa16c5471f2ac3056cf76c5f10f82d6f9292f0b415f389000"
    },
    separateBuildDir = false,
    buildPhase = [
      "gpep517 build-wheel --wheel-dir .dist --output-fd 3 3>&1 >&2",
    ],
    installPhase = [
      m%"python -m installer -d ${DEST} .dist/*.whl"%
    ],
    biDrvs = [
      drvs.pythonFull,
      drvs.pythonSetuptools,
      drvs.pythonInstaller,
      drvs.pythonGpep517,
      drvs.pythonFlitCore,
    ],
  }
}
& {
  lib,
  drvs,
  pythonTroveClassifiers | lib.Package = {
    # https://github.com/alpinelinux/aports
    singleSource = {
      uri = "https://github.com/pypa/trove-classifiers/archive/2025.5.9.12/py3-trove-classifiers-2025.5.9.12.tar.gz",
      sha256sum = "e2073313aeed13ca9c305ad6cacc2bed0c42a1170ef843f67e1e27c3d98c39c1"
    },
    separateBuildDir = false,
    buildPhase = [
      "gpep517 build-wheel --wheel-dir .dist --output-fd 3 3>&1 >&2",
    ],
    installPhase = [
      m%"python -m installer -d ${DEST} .dist/*.whl"%
    ],
    biDrvs = [
      drvs.pythonFull,
      drvs.pythonSetuptools,
      drvs.pythonInstaller,
      drvs.pythonGpep517,
      drvs.pythonFlitCore,
    ],
  }
}
& {
  lib,
  drvs,
  pythonLxml | lib.Package = {
    # https://github.com/alpinelinux/aports
    singleSource = {
      uri = "https://files.pythonhosted.org/packages/c5/ed/60eb6fa2923602fba988d9ca7c5cdbd7cf25faa795162ed538b527a35411/lxml-6.0.0.tar.gz",
      sha256sum = "032e65120339d44cdc3efc326c9f660f5f7205f3a535c1fdbf898b29ea01fb72"
    },
    llvmProvider = drvs.llvmFull,
    enableCcache = false,
    isStatic = false,
    buildEnv = {
      _isStatic = false,
    },
    separateBuildDir = false,
    buildPhase = [
      m%"gpep517 build-wheel --wheel-dir .dist --config-json '{"--build-option": ["--with-cython"]}' --output-fd 3 3>&1 >&2"%,
    ],
    installPhase = [
      m%"python -m installer -d ${DEST} .dist/*.whl"%
    ],
    biDrvs = [
      drvs.pythonDynamic,
      drvs.pythonSetuptools,
      drvs.pythonInstaller,
      drvs.pythonGpep517,
      drvs.pythonFlitCore,
      drvs.libxml2Dynamic,
      drvs.muslShared,
      drvs.libxslt,
      drvs.pkgconf,
      drvs.cmake,
      drvs.llvmFull,
    ],
  }
}
