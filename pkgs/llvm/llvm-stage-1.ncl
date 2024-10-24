let lib = import "../../nickellib/lib.ncl"
in
let llvmBase = import "./llvm-base.ncl"
in
let llvmBaseTarget | lib.CmakePackage
  =
    let b2 = (llvmBase & { isLlvm = true }) in
    b2
    & {

      cmakeArgs | priority -9
        =
          (llvmBase.cmakeArgs)
          @ [
            "-DLLVM_TARGETS_TO_BUILD='X86'",

            # "-DLLVM_ENABLE_RUNTIMES='libcxx;libcxxabi'",
            # "-DLLVM_ENABLE_PROJECTS='lld;clang;compiler-rt'",
            # "-DLLVM_ENABLE_PROJECTS='lld;clang'",
            "-DCLANG_TOOL_AMDGPU_ARCH_BUILD=OFF",
            # "-DCMAKE_ASM_FLAGS_RELEASE:STRING='-O0 -DNDEBUG'",
            # "-DCMAKE_C_FLAGS_RELEASE:STRING='-O0 -DNDEBUG'",
            # "-DCMAKE_CXX_FLAGS_RELEASE:STRING='-O0 -DNDEBUG'",
            "-DLLVM_ENABLE_RUNTIMES='libcxx;libcxxabi;compiler-rt;libunwind'",
            "-DLLVM_ENABLE_PROJECTS='lld;clang'",
            # "-DCMAKE_MAKE_PROGRAM=ninja",
            "-G Ninja",
           "-DLLVM_PARALLEL_LINK_JOBS=$(nproc)",
           "-DLLVM_PARALLEL_COMPILE_JOBS=$(nproc)",

          ],

          # buildEnv|priority 1=b2.buildEnv&{
          #   LDFLAGS|priority 1=
          #   let flag=[
          #     "-L/usr/lib/x86_64-unknown-linux-musl"

          #   ] in if (std.record.has_field "LDFLAGS" b2.buildEnv) then 
            
          #    (b2.buildEnv.LDFLAGS @ flag) else flag,
          # },
    }
  in
let _llvmStage1 | lib.CmakePackage
  =
    llvmBaseTarget
    & {
      name = "llvm-stage-1",
    #   buildInputs = [
    #     (import "../busybox/busybox-stage-0.ncl"),
    #     (import "../llvm/llvm-stage-0.ncl"),
    #     (import "../musl/musl-stage-1.ncl"),
    #     (import "../gnumake/gnumake-stage-1.ncl"),
    #     (import "../ccache/ccache-bin.ncl"),
    #     (import "../linux-headers/linux-headers-stage-1.ncl"), # .linuxHeadersStage1,
    #     (import "../cmake/cmake-stage-1.ncl"),
    #     (import "../python/python-stage-1.ncl"),
    #   ],
    }
  in
{
  busyboxStage0,llvmStage0,muslStage1,gnumakeStage1,samuraiStage1,ccacheBin,linuxHeadersStage1,cmakeStage1,pythonStage1,
llvmStage1=_llvmStage1&{
  buildInputs=lib.biMap [
  busyboxStage0,llvmStage0,muslStage1,samuraiStage1,ccacheBin,linuxHeadersStage1,cmakeStage1,pythonStage1,

  ]

}
}