let
#lib=import "../../nickellib/lib.ncl"
lib = import "../../nickellib/lib.ncl"
in
let llvmBase = import "./llvm-base.ncl"
in
let pkgs = {
  muslStage0 = import "../musl/musl-stage-0.ncl",
}
in
let libcxxStage0 | lib.CmakePackage
  =
    llvmBase
    & {
      buildInChroot = false,
      name = "llvm-stage-0",
      buildInputs = [
        pkgs.muslStage0,
      ],
      buildEnv =
        let b = (
          llvmBase.buildEnv
          & {
            CPPFLAGS = [
              "--sysroot=${SYSROOT}/",
              "-L${SYSROOT}/usr/lib",
              "-I${SYSROOT}/usr/include",
              "-isystem${SYSROOT}/"
            ]
          }
        )
        in
        b & { LDFLAGS | priority 1 = (b.LDFLAGS @ ["-L${SYSROOT}/usr/lib"]) },
      cmakeArgs | priority -9
        =
          (llvmBase.cmakeArgs)
          @ [
            "-DLLVM_TARGETS_TO_BUILD='X86'",
            "-DLLVM_RUNTIMES='libcxx;libcxxabi'",
            # "-DLLVM_ENABLE_PROJECTS='libcxx;libcxxabi;compiler-rt'",
            "-DLLVM_ENABLE_PROJECTS='lld;clang'",
            "-DCLANG_TOOL_AMDGPU_ARCH_BUILD=OFF",
            "-DCMAKE_ASM_FLAGS_RELEASE:STRING='-O0 -DNDEBUG'",
            "-DCMAKE_C_FLAGS_RELEASE:STRING='-O0 -DNDEBUG'",
            "-DCMAKE_CXX_FLAGS_RELEASE:STRING='-O0 -DNDEBUG'",
          ]
    }
  in
libcxxStage0
