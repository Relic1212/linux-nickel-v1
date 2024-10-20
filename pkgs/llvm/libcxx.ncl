let 
#lib=import "../../nickellib/lib.ncl"
 lib = import "../../nickellib/lib.ncl"
in
let llvmBase=import "./llvm-base.ncl"
in 
let 
pkgs={
    muslStage0=import "../musl/musl-stage-0.ncl",
}
in
let
llvmStage0|lib.CmakePackage=llvmBase&{
    name="libcxx-stage-0",
    buildInputs=[
        pkgs.muslStage0,
    ],
    cmakeArgs|priority -9 =(llvmBase.cmakeArgs) @[
          "-DLLVM_TARGETS_TO_BUILD='X86'",
          "-DLLVM_RUNTIMES=''",
          "-DLLVM_ENABLE_PROJECTS='libunwind;libcxx;libcxxabi;compiler-rt'",

    ]

}
in 
llvmStage0