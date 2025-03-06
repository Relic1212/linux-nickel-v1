{
  lib,
  ttfCroscore | lib.Package = {
    name = "ttf-croscore",
    singleSource = {
      uri = "https://gsdview.appspot.com/chromeos-localmirror/distfiles/croscorefonts-1.31.0.tar.bz2",
      sha256sum = "672c3487883ec1ef83d9254240d4327b014212abc823d06d15816095867315e1",
    },
    buildDir = "${SRC}",
    # Copied from https://github.com/kiss-community/repo/blob/master/extra/ttf-croscore/build

    installPhase = [
      "install -d -m0755 ${DEST}/usr/share/fonts/TTF/croscore",
      "cp -f ./*.ttf  ${DEST}/usr/share/fonts/TTF/croscore",
      "chmod 644 \"${DEST}/usr/share/fonts/TTF/croscore\"/*.ttf",
    ]
  }
}
