{
  lib,
  drvs,
  pythonSphinx | lib.Package = {
    singleSource = {
      uri = "https://github.com/sphinx-doc/sphinx/archive/refs/tags/v8.2.3.tar.gz",
      sha256sum = "94cd09fa065b819dcc40de329441d53710cf51f6857b39ce20840bb2b5d3ec78"
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
      drvs.pythonFlitCore312,
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
  pythonBabel | lib.SetuptoolPackage = {
    singleSource = {
      uri = "https://github.com/python-babel/babel/archive/refs/tags/v2.17.0.tar.gz",
      sha256sum = "a52696499d9da7860726444c170f3481dc7409398392f3500783d01c07221bbf",
    }
  }
}
& {
  lib,
  drvs,
  pythonSnowballstemmer | lib.SetuptoolPackage = {
    singleSource = {
      uri = "https://github.com/snowballstem/snowball/archive/refs/tags/v3.0.1.tar.gz",
      sha256sum = "80ac10ce40dc4fcfbfed8d085c457b5613da0e86a73611a3d5527d044a142d60"
    },
    pythonExecutable,
    buildPhase = [
      "cd ${SRC}",
      #   m%"sed -i 's| -m build | -m gpep517 build-wheel --wheel-dir dist --output-fd 3 3\>\&1 \>\&2|g' GNUmakefile"%,
      "make -f GNUmakefile dist_libstemmer_python",
    ],
    patches = [
      {
        file = "python-snowballstemmer.patch",
        sha256sum = "24f470af81d1a4a03c3a748121bd469e06c3e6cda0adf44737f8f22a5c6d824c"
      }
    ],
    installPhase = [
      "python -m installer -d ${DEST} dist/snowballstemmer-3.0.1/dist/snowballstemmer-3.0.1-py3-none-any.whl",
    ],
    pythonProvider = drvs.pythonDynamic,
    biDrvs = [
      drvs.gnumake,
      drvs.perl,
      drvs.llvm,
      drvs.musl,
      drvs.muslShared,
      drvs.pythonInstaller,
      drvs.pythonGpep517,
      drvs.pythonFlitCore312,
      drvs.pythonHatchling,
      drvs.pythonPathspec,
      drvs.pythonPluggy,
      drvs.pythonImportlibMetadate,
      drvs.pythonMako,
      drvs.pythonPackaging,
      drvs.pythonMarkupsafe,
      drvs.pythonTroveClassifiers,
      drvs.pythonBuild,
      drvs.pythonHooks,
    ]
  }
}
& {
  lib,
  drvs,
  pythonBuild | lib.Package = {
    singleSource = {
      uri = "https://github.com/pypa/build/archive/refs/tags/1.3.0.tar.gz",
      sha256sum = "fd7a275d4b34e2b5b4c73fb57ae3c8239b54e4d09752eb540d4167c77bfa043d"
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
      drvs.pythonFlitCore312,
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
  pythonHooks | lib.Package = {
    singleSource = {
      uri = "https://github.com/pypa/pyproject-hooks/archive/refs/tags/v1.2.0.tar.gz",
      sha256sum = "d993cda99f6c41c2679a0cd5528fc15608cc114df26553deb41db62185c11206"
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
      drvs.pythonFlitCore312,
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
