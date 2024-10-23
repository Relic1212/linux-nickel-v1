let lib = import "../../nickellib/lib.ncl"
in

let gnumakeSourceInput | lib.SourceInput
  = {
    src = {
      uri = "https://ftp.gnu.org/gnu/make/make-4.4.1.tar.gz",
      sha256sum = "dd16fb1d67bfab79a72f5e8390735c49e3e8e70b4945a15ab1f81ddb78658fb3"
    }
  }
  in
let gnumakePkgs = {
  gnumakeStage1 | lib.AutotoolsPackage
    = {
      name = "gnumake-stage-1",

      sourceInputs = [
        gnumakeSourceInput
      ],
      configureFlags |priority 10=[
          "ac_cv_path_GREP=/usr/bin/grep",
          "--disable-dependency-tracking"
        ]@
        (lib.AutotoolsPackage.configureFlags)
        ,
      enableCcache = false,
      buildDir = "${SRC}",
      configureScript="./configure",

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
      buildInputs = [
        (import "../busybox/busybox-stage-0.ncl"),
        (import "../llvm/llvm-stage-0.ncl"),
        (import "../musl/musl-stage-0.ncl"),
      ],

      buildEnv = (
        lib.AutotoolsPackage.buildEnv
        & {

            LD="lld",
        #   LDFLAGS | priority 2
        #     = (lib.functions.replaceArrayElem "-fuse-ld=lld" "-fuse-ld=/usr/bin/ld.lld" lib.AutotoolsPackage.buildEnv.LDFLAGS),
        }
      ),
    }
}
in gnumakePkgs
