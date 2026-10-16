{
  lib,
  drvs,
  perlDocmake | lib.Package = {
    singleSource = {
      uri = "https://github.com/shlomif/docmake/archive/refs/tags/cpan-releases/0.1101.tar.gz",
      sha256sum = "9715c5903c7264fd63133e65a0de1883e00bf8e6412d2e8bc0841a52167ec6cf",
    },
    installPhase = [
      "install -dm0755 ${DEST}/usr/lib/perl5/5.40.0",
      "install -dm0755 ${DEST}/usr/bin",
      "cp -r ${SRC}/modules/App-XML-DocBook-Docmake/lib/* ${DEST}/usr/lib/perl5/5.40.0/",
      "cp -r ${SRC}/modules/App-XML-DocBook-Docmake/bin/* ${DEST}/usr/bin/",

      #   lib.functions.appendFile "${DEST}/usr/lib/perl5/5.40.0/File/ShouldUpdate.pm" "our $VERSION = '0.2.0';\n",
    ]
  }
}
