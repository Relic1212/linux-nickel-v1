{
  lib,
  pkgs,
  dropbear | lib.AutotoolsPackage
    = {
      singleSource = {
        uri = "https://matt.ucc.asn.au/dropbear/dropbear-2024.85.tar.bz2",
        sha256sum = "86b036c433a69d89ce51ebae335d65c47738ccf90d13e5eb0fea832e556da502",
      },
      extraConfigureFlags = [
        "--disable-lastlog",
        "--disable-utmp",
        "--disable-utmpx",
        "--disable-wtmp",
        "--disable-wtmpx",
      ],
      biPkgs = [
        pkgs.zlibNg,
      ]
    }
}
