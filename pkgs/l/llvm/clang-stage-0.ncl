(import "llvm-base.ncl")
& {
  lib,
  drvs,
  _llvmBase,
  libcxxBaseStage0 | lib.CmakePackage
    =
      let srFlag = "--sysroot=/tmp/workdir/sysroot" in
      {
        stage = 0,
        isLlvm = false,
        sourceInputs = _llvmBase.sourceInputs,
        extraCmakeArgs = [
          ""
        ],
        buildEnv = {
          _isLlvm = false,
          STAGE_CPPFLAGS = [
            srFlag,
            "-nostdinc",
            "-nostdinc++",
            "-isystem/tmp/workdir/sysroot/usr/include/",
          ],
          STAGE_CFLAGS = [
            srFlag,
            "-nostdinc",
            "-nostdlib",
            "-isystem/tmp/workdir/sysroot/usr/include/",
            "--verbose"
          ],
          STAGE_LDFLAGS = [
            srFlag,
            "-nostdlib++",
            "-nostdlib",
            "-L/tmp/workdir/sysroot/usr/lib/",
            "--verbose",
            "-lc",
          ],
          STAGE_CXXFLAGS = [
            srFlag,
            "-nostdinc++",
            "-nostdlib++",
            "-nostdlib",
            "-isystem/tmp/workdir/sysroot/usr/include/",
            "--verbose"
          ],
          # CC=[
          #     srFlag,
          # ]
        },
        cmakeArgs =
          lib.CmakePackage.cmakeArgs
          @ [
            "-DLLVM_ENABLE_RUNTIMES='libcxx;libcxxabi;libunwind;compiler-rt'",
            "-DLLVM_ENABLE_TARGETS='X86'",
            "-DCMAKE_TOOLCHAIN_FILE=/tmp/workdir/build/toolchain.cmake",
            "-DLIBCXX_ENABLE_SHARED:BOOl=OFF",
            "-DLIBUNWIND_ENABLE_SHARED:BOOL=OFF",
            "-DLIBCXXABI_ENABLE_SHARED:BOOL=OFF",
            "-DLIBCXXABI_ENABLE_STATIC_UNWINDER:BOOL=ON",
            "-DLIBCXX_HAS_MUSL_LIBC:BOOL=ON",
            # "-DLIBCXX_ENABLE_THREADS:BOOL=OFF",
            # "-DLIBCXXABI_ENABLE_THREADS:BOOL=OFF",
            # "-DLIBUNWIND_ENABLE_THREADS:BOOL=OFF",
            "-DCOMPILER_RT_BUILD_BUILTINS=ON",
            "-DLLVM_HOST_TRIPLE:STRING=x86_64-unknown-linux-musl",
            "-DCOMPILER_RT_INSTALL_BINARY_DIR:PATH=lib/bin",
            "-DCOMPILER_RT_INSTALL_DATA_DIR:PATH=share",
            "-DCOMPILER_RT_INSTALL_INCLUDE_DIR:PATH=include",
            "-DCOMPILER_RT_INSTALL_LIBRARY_DIR:PATH=lib",
                    # "-DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON",

          ],

        preConfigurePhase = [
          m%"
            if [ $(command -v clang) ]; then
                export CC="clang %{srFlag}"
                export CPP="clang %{srFlag} -E"

            elif [ $(command -v gcc) ]; then
                export CC="gcc %{srFlag}"
                export CPP="gcc %{srFlag} -E"

            fi

            if [ $(command -v clang++) ]; then
                export CXX="clang++ %{srFlag}"
            elif [ command -v g++ ]; then
                export CXX="g++ %{srFlag}"
            fi

            if [ $(command -v ld.lld) ]; then
                export LD="ld.lld %{srFlag}"
            elif [ $(command -v ld) ]; then
                export CC="ld %{srFlag}"
            fi

            echo CPP="${CPP}"
            echo CC="${CC}"
            echo CXX="${CXX}"
            echo LD="${LD}"


            "%,
          m%"echo "set( CMAKE_SYSROOT \"/tmp/workdir/sysroot\" )"> toolchain.cmake"%
        ],
        configurePhase | priority -9
          = [
            "export DESTDIR=/tmp/workdir/out/destdir",
            "cmake -S ${SRC}/runtimes %{std.string.join " \\\n\t" cmakeArgs}",
          ],
        biDrvs = [
          drvs.muslStage0,
          drvs.linuxHeadersStage0,
        ],
        buildPhase = [
          "make -j$(nproc) cxx cxxabi unwind compiler-rt"
        ],
        installPhase = [
          "make DESTDIR=${DEST} install-cxx install-cxxabi install-unwind install-compiler-rt install-compiler-rt-headers"
        ],
      },

################################################################################################
  clangBaseStage0 | lib.CmakePackage
    =
      let srFlag = "--sysroot=/tmp/workdir/sysroot" in
      {
        stage = 0,
        isLlvm = false,
        sourceInputs = _llvmBase.sourceInputs,
        extraCmakeArgs = [
          ""
        ],
        buildEnv = {
          _isLlvm = false,
          STAGE_CPPFLAGS = [
            srFlag,
            "-nostdinc",
            "-nostdinc++",
            "-isystem/tmp/workdir/sysroot/usr/include/",
            "-I/tmp/workdir/sysroot/usr/include/c++/v1/",
          ],
          STAGE_CFLAGS = [
            srFlag,
            "-nostdinc",
            "-nostdlib",
            "-isystem/tmp/workdir/sysroot/usr/include/",
            "--verbose",
            "-fno-stack-protector",
            "-print-file-name=crt1.o",
            # "-print-file-name=crti.o",
            #  "-print-file-name=crtbeginT.o",
            #  "-print-file-name=crtend.o",
            "-print-file-name=crtn.o",
          ],
          STAGE_LDFLAGS = [
            srFlag,
            # "-nostdlib++",
            # "-nostdlib",
            "-L/tmp/workdir/sysroot/usr/lib/",
            "--verbose",
            # "-lc",
            "--no-default-config",
            "-stdlib=libc++",
            # "--rtlib=compiler-rt", "-unwindlib=libunwind",
            "-fuse-ld=lld"
          ],
          STAGE_CXXFLAGS = [
            srFlag,
            "-nostdinc++",
            # "-nostdlib++",
            "-nostdlib",
            "-isystem/tmp/workdir/sysroot/usr/include/",
            "-I/tmp/workdir/sysroot/usr/include/c++/v1/",
            "--verbose",
            # "-lc++",
            "-lc++abi",

            # /tmp/workdir/sysroot/usr/lib/crt1.o /tmp/workdir/sysroot/usr/lib/crti.o crtbeginT.o -L/tmp/workdir/sysroot/usr/lib/ -L/tmp/workdir/sysroot/usr/lib --as-needed CMakeFiles/cmTC_ab969.dir/testCXXCompiler.cxx.o -lc++ -lm -lssp_nonshared --start-group /usr/lib/llvm19/lib/clang/19/lib/x86_64-alpine-linux-musl/libclang_rt.builtins.a -l:libunwind.a -lc --end-group crtend.o /tmp/workdir/sysroot/usr/lib/crtn.o
            "-fno-stack-protector",
            # "-print-file-name=crt1.o",
            # "-print-file-name=crti.o",
            #  "-print-file-name=crtbeginT.o",
            #  "-print-file-name=crtend.o",
            # "-print-file-name=crtn.o",
            "-lc++",
            "-lm",
            #    "--start-group /tmp/workdir/sysroot/usr/lib/llvm19/lib/clang/19/lib/x86_64-alpine-linux-musl/libclang_rt.builtins.a ",
            "-l:libunwind.a",
            "-lc",
          ],
          # CC=[
          #     srFlag,
          # ]
        },
        cmakeArgs =
          lib.CmakePackage.cmakeArgs
          @ [
            "-DLLVM_ENABLE_RUNTIMES='libcxx;libcxxabi;libunwind'",
            "-DLLVM_ENABLE_PROJECTS='clang;lld'",
            "-DLLVM_ENABLE_TARGETS='X86'",
            "-DCMAKE_TOOLCHAIN_FILE=/tmp/workdir/build/toolchain.cmake",
            "-DLIBCXX_ENABLE_SHARED:BOOl=OFF",
            "-DLIBUNWIND_ENABLE_SHARED:BOOL=OFF",
            "-DLIBCXXABI_ENABLE_SHARED:BOOL=OFF",
            "-DLIBCXXABI_ENABLE_STATIC_UNWINDER:BOOL=ON",
            "-DLIBCXX_HAS_MUSL_LIBC:BOOL=ON",
            "-DLIBCXX_ENABLE_THREADS:BOOL=OFF",
            "-DLIBCXXABI_ENABLE_THREADS:BOOL=OFF",
            "-DLIBUNWIND_ENABLE_THREADS:BOOL=OFF",
            "-DLLVM_ENABLE_THREADS:BOOL=OFF",
            "-DLIBUNWIND_USE_COMPILER_RT=ON",
            "-DLLVM_ENABLE_LIBCXX:BOOL=ON",
            "-DLLVM_ENABLE_PIC:BOOL=OFF",
            "-DLLVM_ENABLE_LLD=ON",
            "-DCLANG_DEFAULT_RTLIB=compiler-rt",
            "-DCLANG_DEFAULT_UNWINDLIB=libunwind",
            "-DCLANG_DEFAULT_CXX_STDLIB=libc++",
            "-DLIBCXXABI_USE_COMPILER_RT=ON",
            "-DCOMPILER_RT_USE_BUILTINS_LIBRARY=ON",
                    "-DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON",

            "-DLIBCXX_CXX_ABI=libcxxabi",
            "-DLIBCXX_USE_COMPILER_RT=ON",
            "-DLIBCXXABI_USE_LLVM_UNWINDER=ON",
            "-DLLVM_HOST_TRIPLE:STRING=x86_64-unknown-linux-musl",

          ],

        preConfigurePhase = [
          m%"
            if [ $(command -v clang) ]; then
                export CC="clang %{srFlag}"
                export CPP="clang %{srFlag} -E"

            elif [ $(command -v gcc) ]; then
                export CC="gcc %{srFlag}"
                export CPP="gcc %{srFlag} -E"

            fi

            if [ $(command -v clang++) ]; then
                export CXX="clang++ %{srFlag}"
            elif [ command -v g++ ]; then
                export CXX="g++ %{srFlag}"
            fi

            if [ $(command -v ld.lld) ]; then
                export LD="ld.lld %{srFlag}"
            elif [ $(command -v ld) ]; then
                export CC="ld %{srFlag}"
            fi

            echo CPP="${CPP}"
            echo CC="${CC}"
            echo CXX="${CXX}"
            echo LD="${LD}"


            "%,
          m%"echo "set( CMAKE_SYSROOT \"/tmp/workdir/sysroot\" )"> toolchain.cmake"%
        ],
        configurePhase | priority -9
          = [
            "export DESTDIR=/tmp/workdir/out/destdir",
            "cmake -S ${SRC}/llvm %{std.string.join " \\\n\t" cmakeArgs}",
          ],
        biDrvs = [
          drvs.muslStage0,
          drvs.libcxxBaseStage0,
        ],
        buildPhase = [
          "make -j$(nproc) clang lld"
        ],
        installPhase = [
          "make DESTDIR=${DEST} install-clang install-lld"
        ],
      }
}
