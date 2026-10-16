{
  lib,
  drvs,
  perlFileShouldUpdate | lib.Package = {
    singleSource = {
      uri = "https://github.com/shlomif/perl-File-ShouldUpdate/archive/refs/tags/0.2.1.tar.gz",
      sha256sum = "8c4dbebe950a15f1a117c09f1c6cf648111d8d274b117d5b4b0ccfe9f5bb252e",
    },
    installPhase = [
      "install -dm0755 ${DEST}/usr/lib/perl5/5.40.0",
      "cp -r ${SRC}/File-ShouldUpdate/lib/* ${DEST}/usr/lib/perl5/5.40.0/",
      # lib.functions.appendFile "${DEST}/usr/lib/perl5/5.40.0/File/ShouldUpdate.pm" "our $VERSION = '0.2.0';\n",
      # m%"printf "our \$VERSION = '0.2.0';\n" >> ${DEST}/usr/lib/perl5/5.40.0/File/ShouldUpdate.pm"%,
      m%"sed -i "s@use parent 'Exporter';@our \$VERSION = '0.2.0';\nuse parent 'Exporter';@g" ${DEST}/usr/lib/perl5/5.40.0/File/ShouldUpdate.pm"%,
    ]
  }
}
