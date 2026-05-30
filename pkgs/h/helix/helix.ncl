{
  lib,
  drvs,
  helix | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/helix-editor/helix/archive/refs/tags/25.07.1.tar.gz",
      sha256sum = "27c8bc3eba46bc7bab1e3629c6b28ff94882eeff17366b3ea69cd8ceffba7541",
    },
    extraEnv = {
      HELIX_DISABLE_AUTO_GRAMMAR_BUILD = "1",
      HELIX_DEFAULT_RUNTIME = "/usr/share/helix/runtime",
    },

    postInstallPhase = [
      "install -dm0755 ${DEST}/usr/share/helix",
      "cp -r runtime ${DEST}/usr/share/helix/runtime",
    ],

    crates = lib.functions.filterCrates (import "helix-crates.json"),
  }
}
