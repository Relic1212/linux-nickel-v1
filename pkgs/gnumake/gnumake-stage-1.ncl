{
  lib,
  pkgs,

  gnumakeStage1 | lib.AutotoolsPackage
    = {
      name = "gnumake-stage-1",

      singleSource = (import "gnumake-src.ncl"),
      configureFlags | priority 10
        =
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
      # buildInputs = [
      #   (import "../busybox/busybox-stage-0.ncl"),
      #   (import "../llvm/llvm-stage-0.ncl"),
      #   (import "../musl/musl-stage-0.ncl"),
      # ],

      buildEnv = (
        lib.AutotoolsPackage.buildEnv
        & {

          LD = "lld",
          #   LDFLAGS | priority 2
          #     = (lib.functions.replaceArrayElem "-fuse-ld=lld" "-fuse-ld=/usr/bin/ld.lld" lib.AutotoolsPackage.buildEnv.LDFLAGS),
        }
      ),
      buildInputs =
        lib.biMap [
          pkgs.busyboxStage0,
          pkgs.llvmStage0,
          pkgs.muslStage0,
        ]
    },
}
