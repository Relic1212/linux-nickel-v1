{
  lib,
  drvs,

  gnumakeStage1 | lib.AutotoolsPackage = {
    name = "gnumake-stage-1",

    singleSource = (import "gnumake-src.ncl"),
    configureFlags | priority 10 =
      [
        "ac_cv_path_GREP=/usr/bin/grep",
        "--disable-dependency-tracking"
      ]
      @ (lib.AutotoolsPackage.configureFlags),
    enableCcache = false,
    buildDir = "${SRC}",
    configureScript = "./configure",

    configurePhase = [
      "cd %{buildDir}",
      configureScript ++ " " ++ (std.string.join lib.constants.buildFlagSep configureFlags)
    ],

    buildPhase = [
      "./build.sh",
    ],
    installPhase = [
      "./make DESTDIR=${DEST} install"
    ],

    isLlvm = false,

    buildEnv =
      let common = [
        "--sysroot=/"
      ]
      in
      {
        _isLlvm = false,
        # STAGE_CFLAGS=common @ [
        #   "-I/include"
        # ],
        # STAGE_CPPFLAGS=STAGE_CFLAGS @ [
        #   "-I/include"
        # ],
        # STAGE_LDFLAGS=common,
      },
    buildInputs =
      [
        drvs.busyboxBootstrapStage0,
        drvs.bootstrapStage0,
        drvs.bootstrapSymlinks,
      ]
  },
}
