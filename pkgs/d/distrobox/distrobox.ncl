{
  lib,
  drvs,
  distrobox | lib.Package = {
    singleSource = {
      uri = "https://github.com/89luca89/distrobox/archive/refs/tags/1.8.1.2.tar.gz",
      sha256sum = "3ecbce9b8c5b5df941f986798ffa6ea7fdf742223d42204207974c4323d5b9fc"
    },
    separateBuildDir = false,
    installPhase = [
      "./install --prefix ${DEST}/usr"
    ]
  }
}
