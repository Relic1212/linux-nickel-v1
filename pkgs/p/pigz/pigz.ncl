{
  lib,
  drvs,
  pigz | lib.MakePackage
    = {
      singleSource = {
        uri = "https://zlib.net/pigz/pigz-2.8.tar.gz",
        sha256sum = "eb872b4f0e1f0ebe59c9f7bd8c506c4204893ba6a8492de31df416f0d5170fd0",
      },
      biDrvs = [
        drvs.zlibNg,
      ],
      extraMakeArgs = [
        "CC=\"${CC}\"",
        "LDFLAGS=\"${LDFLAGS}\""
      ],
      installPhase = [
        "install -d -m0755 ${DEST}/usr/bin",
        "install -m0755 pigz ${DEST}/usr/bin",
        "install -m0755 pigz ${DEST}/usr/bin",
        "install -m0755 unpigz ${DEST}/usr/bin",
        "cd ${DEST}/usr/bin",
        "ln -s pigz gzip",
        "ln -s unpigz gunzip",
      ]
    }
}
