let b=(import "llvm-base-stage-0.ncl")

in 
let 
lib = import "../../nickellib/lib.ncl"
in
b& {
    cmakeArgs|priority 1=b.cmakeArgs @[
           "-DLLVM_ENABLE_RUNTIMES='libcxx;libcxxabi;compiler-rt;libunwind'",
            "-DLLVM_ENABLE_PROJECTS='lld;clang;llvm'",
            "-DCMAKE_SYSROOT=/tmp/workdir/sysroot"

    ],
    buildInputs|priority 1=b.buildInputs@[
        import "./llvm-baselibs-stage-0.ncl",
        (import "../libssp-nonshared/libssp-nonshared.ncl").libsspNonsharedStage0

    ],
    buildEnv|priority 1=(b.buildEnv&{

        CPPFLAGS|priority 2=b.buildEnv.CPPFLAGS@["-I/tmp/workdir/sysroot/include/c++/v1",
        "-fuse-ld=/tmp/workdir/sysroot/usr/bin/ld.lld","-stdlib=libc++"],

        CXXFLAGS|priority 2=b.buildEnv.CXXFLAGS@["-I/tmp/workdir/sysroot/include/c++/v1",
        "-fuse-ld=/tmp/workdir/sysroot/usr/bin/ld.lld",
        "-stdlib=libc++",
        "-rtlib=compiler-rt", 
        "-unwindlib=libunwind"],

        CFLAGS|priority 2=(b.buildEnv.CFLAGS@[
            "-I/tmp/workdir/sysroot/include/c++/v1",
            "-fuse-ld=/tmp/workdir/sysroot/usr/bin/ld.lld",
            "-stdlib=libc++",
            "-rtlib=compiler-rt", 
            "-unwindlib=libunwind"]),

    LDFLAGS|priority 2=(lib.functions.replaceArrayElem "-fuse-ld=lld" "-fuse-ld=/tmp/workdir/sysroot/usr/bin/lld" b.buildEnv.LDFLAGS),
    
    AR|priority 1="/tmp/workdir/sysroot/usr/bin/llvm-ar",
    NM|priority 1="/tmp/workdir/sysroot/usr/bin/llvm-nm",
    OBJCOPY|priority 1="/tmp/workdir/sysroot/usr/bin/llvm-objcopy",
    OBJDUMP|priority 1="/tmp/workdir/sysroot/usr/bin/llvm-objdump",
    RANLIB|priority 1="/tmp/workdir/sysroot/usr/bin/llvm-ranlib",
    READELF|priority 1="/tmp/workdir/sysroot/usr/bin/llvm-readelf",
    LD|priority 1="/tmp/workdir/sysroot/usr/bin/ld.lld",


    }),
    installPhase|priority 1=b.installPhase @[
        "cd ${DEST}/usr/bin",
          "ln -s /usr/bin/clang cc",
          "ln -s /usr/bin/clang++ c++",
          "ln -s /usr/bin/clang-cpp cpp",
    ]
    
}