{
  lib,
  pkgs,
  dinit | lib.MesonPackage
    = {
      name = "dinit",
      singleSource = {

        uri = "https://github.com/davmac314/dinit/archive/refs/tags/v0.19.1.tar.gz",
        sha256sum = "e4ef40844ce64ca7476b9acba2adabdca49a2b59c97641a99e7d47904701a5f5"
      },
      #   mesonArgs =
      #     lib.MesonPackage.mesonArgs
      #     @ [
      #       "-Ddinit-sbindir=/usr/bin"
      #     ],
      extraMesonArgs = [
        "-Ddinit-sbindir=/usr/bin"
      ],
      biPkgs = [
        pkgs.m4
      ]
    }
}
