{
  lib,
  drvs,
  notoFonts | lib.Package = {
    singleSource = {
      uri = "https://github.com/notofonts/notofonts.github.io/archive/refs/tags/noto-monthly-release-2026.04.01.tar.gz",
      sha256sum = "3a19af6df3c395352715470fd2fa4ed50e75a99551db9dc3b743e1f87e871b7b",
    },
    installPhase = [
      "install -dm0755 ${DEST}/ush/share/fonts/noto",
      "install -m0755 ${SRC}/fonts/*/hinted/ttf/*.ttf ${DEST}/ush/share/fonts/noto",
      "install -m0755 ${SRC}/fonts/*/hinted/otf/*.otf ${DEST}/ush/share/fonts/noto",
    ]
  }
}
