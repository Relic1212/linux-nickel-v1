{
  lib,
  pkgs,
  # base
  _samurai | lib.MakePackage
    =
      let _makeInstallArgs = lib.MakePackage.makeInstallArgs @ ["PREFIX=/usr"] in
      {
        baseName = "samurai",
        singleSource = {
          uri = "https://github.com/michaelforney/samurai/archive/189023533035ecc30848ba8dffc25c9139928f89.zip",
          sha256sum = "acb644c29b78a3c50aba8cc636b7ccde0e9c7a40c89d70d59a3604fed2187c62",
        },
        buildDir = "${SRC}",
        makeInstallArgs = _makeInstallArgs,
        installPhase =
          (lib.MakePackage & { makeInstallArgs = _makeInstallArgs }).installPhase
          @ [
            "cd ${DEST}/usr/bin",
            "ln -s samu ninja",
          ],
      },
  ##

  samuraiStage1 =
    _samurai
    & {
      stage = 1,
      buildInputs =
        lib.biMap [
          pkgs.busyboxStage0,
          pkgs.muslStage1,
          pkgs.llvmStage0,
          pkgs.ccacheBin,
          pkgs.gnumakeStage1
        ]
    },

  #2

  samuraiStage2 =
    _samurai
    & {
      stage = 2,
      buildInputs =
        lib.biMap [
          pkgs.busyboxStage1,
          pkgs.muslStage2,
          pkgs.llvmStage1,
          pkgs.ccacheBin,
          pkgs.gnumakeStage2
        ]
    },

  #final

  samurai =
    _samurai
    & {
      stage = -1,
      buildInputs =
        lib.biMap [
          pkgs.busyboxStage2,
          pkgs.musl,
          pkgs.llvmStage2,
          pkgs.ccacheBin,
          pkgs.gnumake
        ]
    },
}
