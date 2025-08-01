{
  lib,
  drvs,
  symbolsNerdFont | lib.Package = {
    singleSource = {
      uri = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/NerdFontsSymbolsOnly.tar.xz",
      sha256sum = "7f8c090da3b0eaa7108646bf34cbbb6ed13d5358a72460522108b06c7ecd716a"
    },

    installPhase = [
      "install -d -m0755 ${DEST}/usr/share/fonts/nerd-fonts",
      "install -m0755 ${SRC}/*.ttf ${DEST}/usr/share/fonts/nerd-fonts",
      "install -d -m0755 ${DEST}/usr/share/fontconfig/conf.avail/",
      "install -m0755 ${SRC}/10-nerd-font-symbols.conf ${DEST}/usr/share/fontconfig/conf.avail/",
    ]
  }
}
