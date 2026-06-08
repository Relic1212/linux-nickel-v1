{
  lib,
  drvs,
  llvm,
  llvmFull,
  llvmFullTools | lib.CmakePackage =
    llvmFull
    & {
      cmakeExtraArgsRecord = {
        "-DLLVM_INSTALL_TOOLCHAIN_ONLY" = false,
        "-DLLVM_INSTALL_UTILS" = true,
        "-DLLVM_BUILD_UTILS:BOOL" | priority 1 = "ON",

        "-DLLVM_INCLUDE_UTILS:BOOL" | priority 1 = "ON",
        "-DLLDB_ENABLE_PYTHON" | priority 1 = "ON",
      },
      #   biDrvs | priority 1 =
      #     llvmFull.biDrvs
      #     @ [
      #       drvs.pythonFull,
      #     ],
      # postInstallPhase|priority 1=llvmFull.postInstallPhase @ [
      #     "ninja -C ${BUILDDIR} install-llvm-tblgen",
      # ],
    },
  llvmLldb | lib.CmakePackage = {
    generator = "Ninja",
    sourceInputs = llvm.sourceInputs,
    llvmProvider = drvs.llvmFullTools,
    enableParallel = false,
    # buildEnv={
    #     EXTRA_CXXFLAGS=["-I/tmp/workdir/src",],
    # },
    cmakeExtraArgsRecord = {
      "-DLLDB_INCLUDE_TESTS" = false,
      "-DPython3_EXECUTABLE" = "/usr/bin/python",
      "-DLLVM_DIR" = "/tmp/workdir/src/cmake/llvm",
      "-DLLDB_ENABLE_CURSES" = true,
      "-DLLVM_ENABLE_ZLIB" = true,
      "-DLLVM_ENABLE_ZSTD" = true,
    },
    biDrvs = [
      drvs.llvmConfigStatic,
      drvs.linuxHeaders,
      drvs.pythonFull,
      drvs.gnumake,
      #   drvs.pkgconfMeson,
    ],
    pDrvs = [
      drvs.ncurses,
    ],
    preConfigurePhase = [
      # "export LLVM_DIR=${SRC}/llvm",
      "sed -i 's|SHARED|STATIC|g' ${SRC}/lldb/source/API/CMakeLists.txt",
      "sed -i 's|SHARED|STATIC|g' ${SRC}/lldb/tools/intel-features/CMakeLists.txt",
      "export SRC=${SRC}/lldb",
    ],
    # preBuildPhase=[
    #     # "ninja include/lldb/API/SBLanguages.h",
    #     "ninja lldb-sbapi-dwarf-enums",
    #     "echo 'SBL done'",
    # ],
    # buildPhase=[
    #              "ninja lldb",

    # ],
    # installPhase=[
    #     "ninja install-lldb",
    # ],
  }
}
