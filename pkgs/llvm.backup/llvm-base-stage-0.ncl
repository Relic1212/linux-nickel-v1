let lib = import "../../nickellib/lib.ncl"
in
let llvmBase = import "./llvm-base.ncl"
in

let llvmBaseStage0 | lib.CmakePackage
  =
    let b2 = (llvmBase & { isLlvm = true }) in
    b2
    & {
      buildInChroot = false,
      name = "llvm-stage-0",
      # buildInputs = [
      #   # pkgs.muslStage0,
      #   (import "../musl/musl-stage-0.ncl"),
      #   # pkgs.linuxHeadersStage0,
      #   (import "../linux-headers/linux-headers.ncl").linuxHeadersStage0,
      # ],
      buildEnv =
        let b = (
          (b2).buildEnv
          & {
            CPPFLAGS = [
              # "--sysroot=/tmp/workdir/sysroot/",
              # "-L/tmp/workdir/sysroot/usr/lib",
              "-I/tmp/workdir/sysroot/usr/include",
              "-idirafter=/tmp/workdir/sysroot/"
            ],
            CFLAGS | priority 1 = (llvmBase.buildEnv.CFLAGS @ CPPFLAGS),
            CXXFLAGS | priority 1 = (llvmBase.buildEnv.CXXFLAGS @ CPPFLAGS),
          }
        )
        in
        b & { LDFLAGS | priority 1 = (b.LDFLAGS @ ["-L/tmp/workdir/sysroot/usr/lib"]) },
      cmakeArgs | priority -9
        =
          (llvmBase.cmakeArgs)
          @ [
            "-DLLVM_TARGETS_TO_BUILD='X86'",
            #"-DLLVM_TARGETS_TO_BUILD=\"\"",

            # "-DLLVM_ENABLE_RUNTIMES='libcxx;libcxxabi'",
            # "-DLLVM_ENABLE_PROJECTS='lld;clang;compiler-rt'",
            # "-DLLVM_ENABLE_PROJECTS='lld;clang'",
            "-DCLANG_TOOL_AMDGPU_ARCH_BUILD=OFF",
            # "-DCMAKE_ASM_FLAGS_RELEASE:STRING='-O0 -DNDEBUG'",
            # "-DCMAKE_C_FLAGS_RELEASE:STRING='-O0 -DNDEBUG'",
            # "-DCMAKE_CXX_FLAGS_RELEASE:STRING='-O0 -DNDEBUG'",
          ]
    }
  in
llvmBaseStage0
