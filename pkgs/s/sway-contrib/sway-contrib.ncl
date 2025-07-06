{
  lib,

  grimshot | lib.Package = {
    singleSource = {
      uri = "https://github.com/OctopusET/sway-contrib/archive/refs/tags/1.10-contrib.0.tar.gz",
      sha256sum = "d81a6eee472d9b8dedd0ac9badc6fb88504c19b9dcf873f18d24378eab3f0995"
    },
    separateBuildDir = false,
    installPhase = [
      "install -d -m0755 ${DEST}/usr/bin",
      "install -d -m0755 ${DEST}/usr/share/man",
      "install -m0755 grimshot/grimshot ${DEST}/usr/bin",
      "chmod +x ${DEST}/usr/bin/grimshot",
      "install -m0755 grimshot/grimshot.1 ${DEST}/usr/share/man",
    ]
  }
}
