{
  lib,
  drvs,
  mesa2,
  mesaFull,
  mesaClc | lib.MesonPackage = {
    singleSource = mesa2.singleSource,
    biDrvs = mesaFull.biDrvs,
    patches = mesa2.patches,
    llvmProvider = mesa2.llvmProvider,

    extraMesonArgs = [
      "-Dmesa-clc=enabled",
      "-Dinstall-mesa-clc=true",
      # "-Dstatic-libclc=enabled",
      "-Dmesa-clc-bundle-headers=enabled",
      "-Dshared-llvm=disabled",
      "-Dgallium-drivers=''",
      "-Dplatforms=''",
      "-Dvulkan-drivers=''",
      "-Dcpp_rtti=false",
    ]
  }
}
