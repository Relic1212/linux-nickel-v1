{
  lib,

  fontAwesome | lib.Package = {
    singleSource = {
      uri = "https://github.com/FortAwesome/Font-Awesome/archive/6.7.1.tar.gz",
      sha256sum = "44cd670c44616a943dd43d783f208aacd77c3e43e715e7f4977bc0e5909b8084"
    },
    separateBuildDir = false,
    installPhase = [
      "install -d -m0755 ${DEST}/usr/share/fonts/TTF",
      "install -d -m0755 ${DEST}/usr/share/fonts/OTF",
      # "install -m0644 webfonts/*.ttf ${DEST}/usr/share/fonts/TTF",
      "install -m0644 otfs/*.otf ${DEST}/usr/share/fonts/OTF",
    ]
  }
}
