let lib = import "../../nickellib/lib.ncl"
in

let x = import "busybox-base.ncl" in
let bbase = x.busyboxBase
in

let _busyboxStage0 | lib.MakePackage
  =
    bbase
    & {
      name | priority 1 = "busybox-stage-0",
      stage = 0,
      buildDir = bbase.buildDir,
      extraFiles = [
        {
          file = "busybox-minimal.config",
          sha256sum = "cbb326d9da00d4d4b5584f7996bb3b291d11793d4d0d708b43d727f34d7ae427" #let s=import 'Raw "./files_minimal/busybox-minimal.config" in lib.functions.computeSha256 s
        }
      ],
      # buildInputs = [
      #   import "../musl/musl-stage-0.ncl",
      #   import "../llvm/llvm-stage-0.ncl",
      # ],
      configurePhase = [
        "cd %{buildDir}",
        "unset CPPFLAGS",
        "cp /tmp/workdir/files/busybox-minimal.config .config",
        "sed -i 's@-falign-jumps=1@@g' Makefile.flags",
        "sed -i 's@-falign-labels=1@@g' Makefile.flags",
        "sed -i 's@-finline-limit=0@@g' Makefile.flags",

        # "make " ++ (std.string.join " " bbase.makeArgs) ++ " defconfig"
      ],

      buildEnv | priority 1
        =
          let cf = [
            "--sysroot=/tmp/workdir/sysroot/",
            "-I/tmp/workdir/sysroot/include/x86_64-unknown-linux-musl/c++/v1",
            # "-fuse-ld=/tmp/workdir/sysroot/usr/bin/ld.lld",
            # "-stdlib=libc++",
            # "-rtlib=compiler-rt",
            # "-unwindlib=libunwind",
            "-I/tmp/workdir/sysroot/usr/lib/clang/19/include/x86_64-unknown-linux-musl",
            "-Qunused-arguments",
            #"--no-default-config",
            # "-nodefaultlibs",
            # "-nostdlib",
            # "--for-linker=-nostdlib",
            "--for-linker=--sysroot=/tmp/workdir/sysroot/",
            "--for-linker=-L/tmp/workdir/sysroot/usr/lib",
          ]
          in
          let sr = " --sysroot=/tmp/workdir/sysroot"
          in
          (
            bbase.buildEnv
            & {

              CPPFLAGS | priority 2
                = [
                  "--sysroot=/tmp/workdir/sysroot/",
                  "-I/tmp/workdir/sysroot/include/x86_64-unknown-linux-musl/c++/v1",
                  # "-fuse-ld=/tmp/workdir/sysroot/usr/bin/ld.lld",
                  # "-stdlib=libc++",
                  # "-rtlib=compiler-rt",
                  # "-unwindlib=libunwind",
                  "-I/tmp/workdir/sysroot/usr/lib/clang/19/include/x86_64-unknown-linux-musl",
                  "-I/tmp/workdir/sysroot/usr/include",
                  "-Qunused-arguments",
                ],
              CXXFLAGS | priority 2
                =
                  bbase.buildEnv.CXXFLAGS
                  @ [
                    "--sysroot=/tmp/workdir/sysroot/",
                  ],

              CFLAGS | priority 2
                = (
                  bbase.buildEnv.CFLAGS
                  @ [
                    "--sysroot=/tmp/workdir/sysroot/",
                  ]
                ),

              LDFLAGS | priority 2
                =
                  #(lib.functions.replaceArrayElem "-rtlib=compiler-rt" "" (lib.functions.replaceArrayElem "-stdlib=libc++" "" (lib.functions.replaceArrayElem "-fuse-ld=lld" "" bbase.buildEnv.LDFLAGS)))
                  # bbase.buildEnv.LDFLAGS
                  (lib.functions.replaceArrayElem "-fuse-ld=lld" "-fuse-ld=/tmp/workdir/sysroot/usr/bin/ld.lld" bbase.buildEnv.LDFLAGS)
                  @ [
                    "--sysroot=/tmp/workdir/sysroot/",
                    "-L/tmp/workdir/sysroot/usr/lib/clang/19/lib/x86_64-unknown-linux-musl",
                    "-L/tmp/workdir/sysroot/usr/lib",
                    "-Qunused-arguments",
                  ],

              AR | priority 1 = "/tmp/workdir/sysroot/usr/bin/llvm-ar",
              AS | priority 1 = "/tmp/workdir/sysroot/usr/bin/llvm-as",

              NM | priority 1 = "/tmp/workdir/sysroot/usr/bin/llvm-nm",
              OBJCOPY | priority 1 = "/tmp/workdir/sysroot/usr/bin/llvm-objcopy",
              OBJDUMP | priority 1 = "/tmp/workdir/sysroot/usr/bin/llvm-objdump",
              RANLIB | priority 1 = "/tmp/workdir/sysroot/usr/bin/llvm-ranlib",
              READELF | priority 1 = "/tmp/workdir/sysroot/usr/bin/llvm-readelf",
              LD | priority 1 = "/tmp/workdir/sysroot/usr/bin/ld.lld",
              # CC | priority 1 = "\"/tmp/workdir/sysroot/usr/bin/clang%{sr}\"",
              # CXX | priority 1 = "\"/tmp/workdir/sysroot/usr/bin/clang++%{sr}\"",
              # CPP | priority 1 = "\"/tmp/workdir/sysroot/usr/bin/clang-cpp%{sr}\"",

              CC | priority 1 = "/tmp/workdir/sysroot/usr/bin/clang",
              CXX | priority 1 = "/tmp/workdir/sysroot/usr/bin/clang++",
              CPP | priority 1 = "/tmp/workdir/sysroot/usr/bin/clang-cpp",
            }
          )
    }
  in
{
  llvmStage0,
  muslStage0,
  busyboxStage0 =
    _busyboxStage0
    & {
      buildInputs =
        lib.biMap [
          llvmStage0,
          muslStage0,
        ]
    }
}
