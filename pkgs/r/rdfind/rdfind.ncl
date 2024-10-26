{
  lib,
  pkgs,
  rdfind | lib.AutomakePackage
    = {
      name = "rdfind",
      singleSource = {
        uri = "https://rdfind.pauldreik.se/rdfind-1.6.0.tar.gz",
        sha256sum = "7a406e8ef1886a5869655604618dd98f672f12c6a6be4926d053be65070f3279",
      },
      biPkgs = [
        pkgs.nettle,
      ]
    }
}
