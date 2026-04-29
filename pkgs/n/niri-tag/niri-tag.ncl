{
  lib,
  drvs,
  niri,
  niriTag | lib.CargoPackage = {
    singleSource = {
      uri = "https://git.atagen.co/atagen/niri-tag/archive/785619920b8ae1dd147da795cc7e703c3367c34a.tar.gz",
      sha256sum = "3899321243de61cc70e32fffad9e9dfe9b7792166eb8eb350fe6ebe2313b55bb"
    },
    nonCrateSourceInputs = [
      {
        src = singleSource,
      },
      {
        src = (std.array.at 0 niri.sourceInputs).src,
        dest = "niri",
      },
    ],
    # extraFiles = [
    #   {
    #     file = "Cargo.lock",
    #     sha256sum = "cd928685fb415980cdf1f070988d7cc1b5a4ff70d75bcc72288827d61f605f7f",
    #   }
    # ],
    enableSccache = false,
    crates = lib.functions.filterCrates (import "niri-tag-crates.json"),
    configurePhase = [
      # "cp ../files/Cargo.lock .",
      # m%"cat >Cargo.lock <<EOF
      # %{import "Cargo.lock" as 'Text}
      # EOF"%
    ],
  }
}
