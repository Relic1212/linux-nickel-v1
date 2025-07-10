{
  lib,
  pythonFull,

  pythonInstaller | lib.Package = {
    #name = "python-installer",
    singleSource = {
      uri = "https://github.com/pypa/installer/archive/refs/tags/0.7.0.tar.gz",
      sha256sum = "e1589201863a6b6f570ce2f9994febe54a8d9196e0cc54fd331cd7ffd728fb86",
    },
    biDrvs =
      lib.biMap [
        pythonFull
      ],
    # buildDir = "${SRC}",
    # unpackPhase = [
    #   "tar xf /tmp/workdir/packed/*/* -C /tmp/workdir/src --no-same-owner"
    # ],
    # Based on alpine linux's build
    installPhase = [
      m%"sitedir="$(python -c 'import site;print(site.getsitepackages()[0])')""%,
      "install -d -m0755 ${DEST}/${sitedir}",
      "cp -pR ${SRC}/src/installer ${DEST}/${sitedir}",
      "python -m compileall ${DEST}/${sitedir}",
    ]
  }
}
