let cmpFun = (fun x => (if x == null then [] else x))
in

(import "busybox-base.ncl")
& {
  lib,
  drvs,
  _busyboxBase,

  busyboxStage0 | lib.MakePackage =
    _busyboxBase
    & {
      stage = 0,
      buildDir = _busyboxBase.buildDir,
      extraFiles = [
        {
          file = "busybox-minimal.config",
          sha256sum = "a3248eac1cb490d1324df3c79151f66ca75fe2fa2c66c2fbfd249a17d739e389" #let s=import 'Raw "./files_minimal/busybox-minimal.config" in lib.functions.computeSha256 s
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
      ],

      buildEnv | priority 1 =
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
          _busyboxBase.buildEnv
          & {

            CPPFLAGS | priority 2 = [
              "--sysroot=/tmp/workdir/sysroot/",
              "-I/tmp/workdir/sysroot/include/x86_64-unknown-linux-musl/c++/v1",
              "-I/tmp/workdir/sysroot/usr/lib/clang/19/include/x86_64-unknown-linux-musl",
              "-I/tmp/workdir/sysroot/usr/include",
              "-Qunused-arguments",
            ],
            CXXFLAGS | priority 2 =
              _busyboxBase.buildEnv.CXXFLAGS
              @ [
                "--sysroot=/tmp/workdir/sysroot/",
              ],

            CFLAGS | priority 2 = (
              _busyboxBase.buildEnv.CFLAGS
              @ [
                "--sysroot=/tmp/workdir/sysroot/",
              ]
            ),

            LDFLAGS | priority 2 =
              (lib.functions.replaceArrayElem "-fuse-ld=lld" "-fuse-ld=/tmp/workdir/sysroot/usr/bin/ld.lld" _busyboxBase.buildEnv.LDFLAGS)
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
        ),
      stage = 0,
      biDrvs = [
        drvs.llvmStage0,
        drvs.muslStage0,
      ]
    },

  busyboxBootstrapStage0 | lib.MakePackage =
    let p = "x86_64-linux-musl" in
    _busyboxBase
    & {
      stage = 0,
      buildDir = _busyboxBase.buildDir,
      extraFiles = [
        {
          file = "busybox-minimal.config",
          sha256sum = "a3248eac1cb490d1324df3c79151f66ca75fe2fa2c66c2fbfd249a17d739e389" #let s=import 'Raw "./files_minimal/busybox-minimal.config" in lib.functions.computeSha256 s
        }
      ],
      # buildInputs = [
      #   import "../musl/musl-stage-0.ncl",
      #   import "../llvm/llvm-stage-0.ncl",
      # ],
      configurePhase = [
        "cd %{buildDir}",
        "unset CPPFLAGS",
        "export PATH=/tmp/workdir/sysroot/usr/bin:${PATH}",
        "cp /tmp/workdir/files/busybox-minimal.config .config",
        m%"sed -i 's@tmp/workdir/sysroot@tmp/workdir/sysroot/usr@g' .config"%,
        # "sed -i 's@-falign-jumps=1@@g' Makefile.flags",
        # "sed -i 's@-falign-labels=1@@g' Makefile.flags",
        # "sed -i 's@-finline-limit=0@@g' Makefile.flags",
      ],

      makeArgs | priority 2 =
        let fenv = lib.functions.getFinalBuildEnv buildEnv in
        (
          std.record.values (
            std.record.filter
              (fun k v => k != "CPPFLAGS")
              (std.record.map (fun k v => ("%{k}=%{lib.functions.varToExportvar v}")) fenv)
          )
        )
        @ [
          "HOSTLD=%{lib.functions.varToExportvar buildEnv.CC}",
          "HOSTCC=%{lib.functions.varToExportvar buildEnv.CC}",
          "HOSTCXX=%{lib.functions.varToExportvar buildEnv.CXX}",
          "HOSTLDFLAGS=%{ lib.functions.varToExportvar buildEnv.LDFLAGS}",
          # "HOSTCPPFLAGS=%{ lib.functions.varToExportvar  buildEnv.CPPFLAGS}",
          "HOSTCXXFLAGS=%{ lib.functions.varToExportvar  buildEnv.CXXFLAGS}",
          "HOSTCFLAGS=%{ lib.functions.varToExportvar  buildEnv.CFLAGS}",
          #  "EXTRA_CPPFLAGS=%{ lib.functions.varToExportvar (cmpFun buildEnv.CPPFLAGS)}",

          #   "EXTRA_LDFLAGS=%{ lib.functions.varToExportvar  buildEnv.LDFLAGS}",
          #   "EXTRA_CXXFLAGS=%{ lib.functions.varToExportvar buildEnv.CXXFLAGS}",
          #   "EXTRA_CFLAGS=%{ lib.functions.varToExportvar  buildEnv.CFLAGS}",
          "SYSROOT=\"/tmp/workdir/sysroot/usr/\"",
          "CROSS_COMPILE=%{p}-"
        ],

      buildEnv | priority 1 =
        let cf = [
          "--sysroot=/tmp/workdir/sysroot/usr/",
          "-Bsysroot/tmp/workdir/sysroot/usr/bin",
          "-I/tmp/workdir/sysroot/usr/include/c++/9.4.0",
          "-I/tmp/workdir/sysroot/urs/include",
        ]
        in
        let sr = " --sysroot=/tmp/workdir/sysroot/usr"
        in
        ({
          _isLlvm = false,

          CPPFLAGS | priority 2 = cf,
          CXXFLAGS | priority 2 =
            cf
            @ [
              "-static",
              "--static",
              "-L/tmp/workdir/sysroot/usr/lib"
            ],

          CFLAGS | priority 2 = (
            cf
            @ [
              "-L/tmp/workdir/sysroot/usr/lib",
              "-static",
              "--static",
            ]
          ),

          LDFLAGS | priority 2 = [
            "--static",
            "-static",
            "--sysroot=/tmp/workdir/sysroot/usr/",
            "-L/tmp/workdir/sysroot/usr/lib",
          ],

          AR | priority 1 = "/tmp/workdir/sysroot/usr/bin/%{p}-ar",
          AS | priority 1 = "/tmp/workdir/sysroot/bin/%{p}-as",

          NM | priority 1 = "/tmp/workdir/sysroot/usr/bin/%{p}-nm",
          OBJCOPY | priority 1 = "/tmp/workdir/sysroot/usr/bin/%{p}-objcopy",
          OBJDUMP | priority 1 = "/tmp/workdir/sysroot/usr/bin/%{p}-objdump",
          RANLIB | priority 1 = "/tmp/workdir/sysroot/usr/bin/%{p}-ranlib",
          READELF | priority 1 = "/tmp/workdir/sysroot/usr/bin/%{p}-readelf",
          LD | priority 1 = ["/tmp/workdir/sysroot/usr/bin/%{p}-ld", sr],
          # CC | priority 1 = "\"/tmp/workdir/sysroot/usr/bin/clang%{sr}\"",
          # CXX | priority 1 = "\"/tmp/workdir/sysroot/usr/bin/clang++%{sr}\"",
          # CPP | priority 1 = "\"/tmp/workdir/sysroot/usr/bin/clang-cpp%{sr}\"",

          CC | priority 1 = ["/tmp/workdir/sysroot/usr/bin/%{p}-gcc", sr],
          CXX | priority 1 = ["/tmp/workdir/sysroot/usr/bin/%{p}-g++", sr],
          CPP | priority 1 = ["/tmp/workdir/sysroot/usr/bin/%{p}-cpp", sr],
        }
        ),
      stage = 0,
      biDrvs = [
        drvs.bootstrapStage0,
      ]
    }
}
