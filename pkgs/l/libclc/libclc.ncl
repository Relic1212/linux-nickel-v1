{
  lib,
  drvs,
  llvm,
  libclc | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = llvm.singleSource,
    unpackPhase = llvm.unpackPhase,
    cmakeDir = "${SRC}/libclc",
    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.llvmConfigStatic,
    ],
  }
}
