let lib = import "../../nickellib/lib.ncl"
in
let libsspNonsharedBase = (import "libssp-nonshared-base.ncl")
in
let _libsspNonsharedStage0 =
  libsspNonsharedBase
  & {
    name = "libssp-nonshared-stage-0",
    buildEnv =
      libsspNonsharedBase.buildEnv
      & {
        CFLAGS | priority 10 = libsspNonsharedBase.buildEnv.CFLAGS @ ["--sysroot=/tmp/workdir/sysroot"],

        LDFLAGS | priority 10 = (lib.functions.replaceArrayElem "-fuse-ld=lld" "-fuse-ld=/tmp/workdir/sysroot/usr/bin/ld.lld" libsspNonsharedBase.buildEnv.LDFLAGS),
      },
    stage = 0,
    # buildInputs = [
    #   import "../musl/musl-stage-0.ncl",
    #   import "../llvm/llvm-baselibs-stage-0.ncl",
    # ],
  }
in
{
  llvmBaselibsStage0,
  muslStage0,
  libsspNonsharedStage0 =
    _libsspNonsharedStage0
    & {
      buildInputs =
        lib.biMap [
          llvmBaselibsStage0,
          muslStage0
        ]
    }
}
