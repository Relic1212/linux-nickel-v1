{
  lib,
  drvs,
  etcSkel | lib.Package = {
    installPhase = [
      "install -dm0755 ${DEST}/etc/skel",
      m%"echo '#!/bin/sh -e
flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
' > ${DEST}/etc/skel/add-ftapak-repo.sh"%,
      "chmod +x ${DEST}/etc/skel/add-ftapak-repo.sh",
    ]
  }
}
