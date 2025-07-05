{
  lib,
  drvs,

  pythonGpep517 | lib.Package = {
    name = "python-gpep517",
    singleSource = {
      uri = "https://github.com/mgorny/gpep517/archive/v16/gpep517-v16.tar.gz",
      sha256sum = "965ff7cb2217fa03091face01fcb9a2b0205f58be80c8be9ccf832eab7a55414",
    },
    biDrvs =
      [
        drvs.pythonFull
      ],
    buildDir = "${SRC}",
    installPhase = [
      m%"sitedir="$(python -c 'import site;print(site.getsitepackages()[0])')""%,
      "install -d -m0755 ${DEST}/${sitedir}",
      "cp -pR gpep517 ${DEST}/${sitedir}",
      "python -m compileall ${DEST}/${sitedir}",
      "install -d -m0755 ${DEST}/usr/bin",
      m%"
        printf '#!/usr/bin/python
        # -*- coding: utf-8 -*-
        import sys
        from gpep517.__main__ import main
        if __name__ == "__main__":
            sys.exit(main())
        ' >> ${DEST}/usr/bin/gpep517"%,
      "chmod +x ${DEST}/usr/bin/gpep517"
    ]
  }
}
