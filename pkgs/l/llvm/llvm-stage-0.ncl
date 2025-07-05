((import "llvm-base.ncl"))
& {
  lib,
  _llvmBase,

  drvs,
  llvmStage0 =
    _llvmBase
    & {
      stage = 0,
      cmakeArgs | priority 1 =
        lib.functions.replaceArrayElem
          "-DLLVM_TARGETS_TO_BUILD='AArch64;X86'"
          "-DLLVM_TARGETS_TO_BUILD='X86'"
          (
            _llvmBase.cmakeArgs
            @ [
              "-DLLVM_ENABLE_RUNTIMES='libcxx;libcxxabi;compiler-rt;libunwind'",
              "-DLLVM_ENABLE_PROJECTS='lld;clang'",
              "-DCMAKE_SYSROOT=/tmp/workdir/sysroot"
            ]
          ),

      buildEnv | priority 1 =
        let llvmStage0BuildEnv = ((_llvmBase & { stage = 0 }).buildEnv) in
        (
          _llvmBase.buildEnv
          & {

            CPPFLAGS | priority 2 =
              llvmStage0BuildEnv.CPPFLAGS
              @ [
                "-I/tmp/workdir/sysroot/include/c++/v1",
                "-fuse-ld=/tmp/workdir/sysroot/usr/bin/ld.lld",
                "-stdlib=libc++"
              ],

            STAGE_CXXFLAGS | priority 2 =
              llvmStage0BuildEnv.STAGE_CXXFLAGS
              @ [
                "-I/tmp/workdir/sysroot/include/c++/v1",
                "-fuse-ld=/tmp/workdir/sysroot/usr/bin/ld.lld",
                "-stdlib=libc++",
                "-rtlib=compiler-rt",
                "-unwindlib=libunwind"
              ],

            STAGE_CFLAGS | priority 2 = (
              llvmStage0BuildEnv.STAGE_CFLAGS
              @ [
                "-I/tmp/workdir/sysroot/include/c++/v1",
                "-fuse-ld=/tmp/workdir/sysroot/usr/bin/ld.lld",
                "-stdlib=libc++",
                "-rtlib=compiler-rt",
                "-unwindlib=libunwind"
              ]
            ),

            LDFLAGS | priority 2 = (
              lib.functions.replaceArrayElem "-fuse-ld=lld" "-fuse-ld=/tmp/workdir/sysroot/usr/bin/lld" llvmStage0BuildEnv.LDFLAGS
            ),

            AR | priority 1 = "/tmp/workdir/sysroot/usr/bin/llvm-ar",
            NM | priority 1 = "/tmp/workdir/sysroot/usr/bin/llvm-nm",
            OBJCOPY | priority 1 = "/tmp/workdir/sysroot/usr/bin/llvm-objcopy",
            OBJDUMP | priority 1 = "/tmp/workdir/sysroot/usr/bin/llvm-objdump",
            RANLIB | priority 1 = "/tmp/workdir/sysroot/usr/bin/llvm-ranlib",
            READELF | priority 1 = "/tmp/workdir/sysroot/usr/bin/llvm-readelf",
            LD | priority 1 = "/tmp/workdir/sysroot/usr/bin/ld.lld",
          }
        ),

      postInstallPhase = [
        "cd ${DEST}/usr/bin",
        "ln -s clang cc",
        "ln -s clang++ c++",
        "ln -s clang-cpp cpp",
      ],
      buildInputs =
        [
          drvs.muslStage0,
          drvs.linuxHeadersStage0,
          drvs.llvmBaselibsStage0,
          drvs.libsspNonsharedStage0
        ],
    },
}
