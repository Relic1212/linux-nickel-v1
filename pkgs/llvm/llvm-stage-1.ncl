let 
#lib=import "../../nickellib/lib.ncl"
 lib = import "../../nickellib/lib.ncl"
in
let llvmBase=import "./llvm-base.ncl"
in 
let 
pkgs={
    muslStage0=import "../musl/musl-stage-0.ncl",
    libcxx=import "libcxx.ncl"
}
in
let
llvmStage0|lib.CmakePackage=llvmBase&{
    name="llvm-stage-0",
    buildInputs=[
        pkgs.muslStage0,
        pkgs.libcxx
    ],
    cmakeArgs|priority -9 =(llvmBase.cmakeArgs) @[
          "-DLLVM_TARGETS_TO_BUILD='X86'",
          "-DLLVM_RUNTIMES='libunwind;libcxx;libcxxabi;compiler-rt'",
          "-DLLVM_ENABLE_PROJECTS='clang;llvm;lld'",

    ]

}
in 
llvmStage0