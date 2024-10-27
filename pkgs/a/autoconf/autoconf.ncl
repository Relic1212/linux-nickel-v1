{

  pkgs,
  lib,

  autoconf | lib.AutotoolsPackage
    = {
      singleSource = {
        uri = "https://ftp.gnu.org/gnu/autoconf/autoconf-2.72.tar.gz",
        sha256sum = "afb181a76e1ee72832f6581c0eddf8df032b83e2e0239ef79ebedc4467d92d6e",
      },
      biPkgs = [pkgs.perl, pkgs.m4]
    }
}
