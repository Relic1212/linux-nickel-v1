{
  lib,

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
  busyboxBootstrapStage0,
  bootstrapStage0,
  bootstrapSymlinks,
  ccacheBin,
  gnumakeStage1,
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
          busyboxBootstrapStage0,
          bootstrapStage0,
          bootstrapSymlinks,
          ccacheBin,
          gnumakeStage1,
        ]
    },

  #2
  busyboxStage1,
  muslStage2,
  llvmStage1,
  ccacheBin,
  gnumakeStage2,

  samuraiStage2 =
    _samurai
    & {
      stage = 2,
      buildInputs =
        lib.biMap [
          busyboxStage1,
          muslStage2,
          llvmStage1,
          ccacheBin,
          gnumakeStage2,
        ]
    },

  busyboxStage2,
  muslStage3,
  llvmStage2,
  ccacheBin,
  gnumakeStage4,

  samuraiStage3 =
    _samurai
    & {
      stage = -1,
      utilsProviders = lib.biMap [],
      baseBuildinputPackages = lib.biMap [],

      buildInputs =
        lib.biMap [
          busyboxStage2,
          muslStage3,
          llvmStage2,
          ccacheBin,
          gnumakeStage4
        ]
    },

  #final
  busyboxStage3,
  musl,
  llvmStage3,
  ccacheBin,
  gnumake,

  samurai =
    _samurai
    & {
      stage = -1,
      utilsProviders = lib.biMap [],
      baseBuildinputPackages = lib.biMap [],

      buildInputs =
        lib.biMap [
          busyboxStage3,
          musl,
          llvmStage3,
          ccacheBin,
          gnumake,
        ]
    },
}
