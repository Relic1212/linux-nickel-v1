{
  lib,
  pkgs,
  e2fsprogs | lib.AutotoolsPackage
    = {
      singleSource = {
        uri = "https://mirrors.edge.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.47.1/e2fsprogs-1.47.1.tar.gz",
        sha256sum = "0d2e0bf80935c3392b73a60dbff82d8a6ef7ea88b806c2eea964b6837d3fd6c2",
      },
      extraConfigureFlags = [
        "ac_cv_func_llseek='yes'"
      ],
      biPkgs = [
        pkgs.linuxHeaders,
      ]
    }
}
