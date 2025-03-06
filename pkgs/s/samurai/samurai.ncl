{
  lib,
  pkgs,
  # base
  _samurai | lib.MakePackage =
    let _makeInstallArgs = lib.MakePackage.makeInstallArgs @ ["PREFIX=/usr"] in
    {
      baseName = "samurai",
      singleSource = {
        uri = "https://github.com/michaelforney/samurai/archive/189023533035ecc30848ba8dffc25c9139928f89.zip",
        sha256sum = "acb644c29b78a3c50aba8cc636b7ccde0e9c7a40c89d70d59a3604fed2187c62",
      },
      # buildDir = "${SRC}",
      separateBuildDir = false,
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

      buildEnv =
        let common = [
          "--sysroot=/"
        ]
        in
        {
          _isLlvm = false,
          CC = ["gcc"],
          # STAGE_CFLAGS=common @ [
          #   "-I/include"
          # ],
          # STAGE_CPPFLAGS=STAGE_CFLAGS @ [
          #   "-I/include"
          # ],
          STAGE_LDFLAGS = common,
        },
      stage = 1,
      buildInputs =
        lib.biMap [
          pkgs.busyboxBootstrapStage0,
          pkgs.bootstrapStage0,
          pkgs.bootstrapSymlinks,
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

  samuraiStage3 =
    _samurai
    & {
      stage = -1,
      utilsProviders = [],
      baseBuildinputPackages = [],

      buildInputs =
        lib.biMap [
          pkgs.busyboxStage2,
          pkgs.muslStage3,
          pkgs.llvmStage2,
          pkgs.ccacheBin,
          pkgs.gnumakeStage4
        ]
    },

  #final

  samurai =
    _samurai
    & {
      stage = -1,
      utilsProviders = [],
      baseBuildinputPackages = [],

      buildInputs =
        lib.biMap [
          pkgs.busyboxStage3,
          pkgs.musl,
          pkgs.llvmStage3,
          pkgs.ccacheBin,
          pkgs.gnumake
        ]
    },
}
