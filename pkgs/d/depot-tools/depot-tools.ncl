{
  lib,
  drvs,
  depotTools | lib.Package = {
    singleSource = {
      uri = "https://chromium.googlesource.com/chromium/tools/depot_tools",
      fetchMethod = "git",
      sha256sum = "2b5f71d194c1df175925fa5126ab020bd029d63d"
    },
    installPhase = [
      "install -dm0755 ${DEST}/usr/lib/",
      "cp -r ${SRC}/ ${DEST}/usr/lib/depot_tools"
    ]
  }
}
