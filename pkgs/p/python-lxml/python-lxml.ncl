{
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
      EXTRA_CPPFLAGS = [
        "-I/usr/include/libxml2/",
      ],
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
      drvs.libxml2,
      drvs.muslShared,
      drvs.libxslt,
      drvs.pkgconf,
      drvs.cmake,
      drvs.llvmFull,
      drvs.zlibNg,
    ],
  }
}
