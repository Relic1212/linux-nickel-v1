let lib = import "../../nickellib/lib.ncl"
in
let llvmBase | lib.CmakePackage
  = {
    sourceInputs = [
      {
        src = {
          uri = "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.2/llvm-19.1.2.src.tar.xz",
          sha256sum = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
        },
      }
    ],
    isStatic|default = lib.CmakePackage.isStatic,
    cmakeArgs | priority -10
      =
        ((lib.CmakePackage).cmakeArgs)
        @ [
          #"-DLLVM_ENABLE_PROJECTS='clang;llvm;lld'",
          "-DLLVM_VERSION_SUFFIX=''",
          #"-DLLVM_TARGETS_TO_BUILD='AMDGPU;X86'",
          "-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=''",
          "-DCLANG_ENABLE_CLANGD=OFF",
          "-DLLVM_ENABLE_EH=OFF",
          "-DLLVM_ENABLE_LIBEDIT=OFF",
          "-DLLDB_ENABLE_LIBEDIT=OFF",
          "-DLLDB_ENABLE_LUA=OFF",
          "-DLLDB_EDITLINE_USE_WCHAR=1",
          "-DLLVM_ENABLE_LIBPFM=OFF",
          "-DLLVM_ENABLE_RTTI=OFF",
          "-DLLVM_USE_SPLIT_DWARF=OFF",
          "-DLLVM_ENABLE_TERMINFO=OFF",
          "-DCOMPILER_RT_TERMINFO_LIB=OFF",
          "-DLLVM_LIBDIR_SUFFIX=",
          "-DLLDB_ENABLE_PYTHON=OFF",
          "-DLLVM_INCLUDE_BENCHMARKS=OFF",
          "-DLLDB_ENABLE_CURSES=OFF",
          "-DLLVM_BUILD_TESTS=OFF",
          "-DLLVM_INCLUDE_EXAMPLES=OFF",
          "-DLLVM_INCLUDE_DOCS=OFF",
          "-DLLVM_INCLUDE_TESTS=OFF",
          "-DLLVM_ENABLE_TERMINFO=OFF",
          "-DLLVM_ENABLE_LIBXML2=OFF",
          "-DLLVM_ENABLE_SPHINX=OFF",
          "-DLLVM_ENABLE_ZLIB=OFF",
          "-DLLVM_ENABLE_ZSTD=OFF",
          "-DLLVM_ENABLE_LIBEDIT=OFF",
          "-DLLDB_ENABLE_LIBEDIT=OFF",
          "-DLLDB_BUILD_INTEL_MPX=OFF",
          "-DCLANG_ENABLE_ARCMT=OFF",
          #"-DLLVM_RUNTIMES='libcxx;libcxxabi'",
          "-DCLANG_BUILD_TOOLS=OFF",
          "-DCLANG_ENABLE_STATIC_ANALYZER=OFF",
          "-DCLANG_INCLUDE_TESTS=OFF",
          "-DCLANG_ENABLE_HLSL=OFF",
          "-DCLANG_TOOL_C_INDEX_TEST_BUILD=OFF",
          "-Wno-dev",
          "-DLLVM_ENABLE_UNWIND_TABLES=OFF",
          "-DLLVM_USE_LINKER=lld",
          "-DLLVM_ENABLE_LLD=ON",
          "-LLVM_ENABLE_LIBCXX=ON"
        ]
        @ (
          if isStatic then
            [
              "-DLLVM_BUILD_STATIC=ON",
              "-DLLVM_ENABLE_SHARED_LIBS=OFF",
              "-DLLVM_USE_STATIC_ZSTD=ON",
              "-DCLANG_LINK_CLANG_DYLIB=OFF",
              "-DCMAKE_EXE_LINKER_FLAGS=-static",
              "-DLIBCLANG_BUILD_STATIC=ON",
              "-DLLVM_ENABLE_PIC=OFF",
              "-DLLVM_BUILD_LLVM_DYLIB=OFF",
              "-DLLVM_LINK_LLVM_DYLIB=OFF",
            ]
          else
            []
        )
  }
  in
llvmBase
