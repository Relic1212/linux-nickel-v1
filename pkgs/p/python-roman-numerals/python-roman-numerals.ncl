{
  lib,
  drvs,
  pythonRomanNumerals | lib.gpepPackage = {
    singleSource = {
      uri = "https://github.com/AA-Turner/roman-numerals/archive/refs/tags/v4.1.0.tar.gz",
      sha256sum = "c12d098de0c0befa3de91be3f456f272978f481411fb22441a6b9fe386c24f80",
    },
    preConfigurePhase = [
      "export SRC=/tmp/workdir/src/python",
      "cd /tmp/workdir/src/python",
      "echo running \"(files: $(ls))\"",
    ],
    biDrvs = [
      drvs.pythonFlitCore312,
    ],
  }
}
