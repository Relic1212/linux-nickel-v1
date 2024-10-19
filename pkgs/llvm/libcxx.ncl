let 
lib=import "../../nickellib/lib.ncl"
in 
let 
muslStageZero=import "../musl/musl-stage-0.ncl"
in
let 
libcxx|lib.CmakePackage={
    name="libcxx",
    sourceInputs=[
        {
            src={uri="https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.2/libcxx-19.1.2.src.tar.xz",
            sha256sum="e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"}
        }
    ],

    buildInputs=[
        muslStageZero
    ],
    buildInChroot=false
}
in 
libcxx