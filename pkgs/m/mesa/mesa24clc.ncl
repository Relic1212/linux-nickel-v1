{
  lib,
  drvs,
  _mesa2426,
  mesaFull,
  mesa2426Clc | lib.MesonPackage = {
    singleSource = _mesa2426.singleSource,
    biDrvs = _mesa2426.biDrvs @ [drvs.libclc],
    patches = _mesa2426.patches,
    llvmProvider = _mesa2426.llvmProvider,

    extraMesonArgs = [
      "-Dintel-clc=enabled",
      # "-Dintel-rt=disabled",
      # "-Dstatic-libclc=enabled",
      # "-Dmesa-clc-bundle-headers=enabled",
      "-Dshared-llvm=disabled",
      "-Dgallium-drivers=''",
      "-Dplatforms=''",
      "-Dvulkan-drivers=''",
      "-Dcpp_rtti=false",
      "-Dinstall-intel-clc=true",
      "-Dvideo-codecs='all'",
      "-Dshader-cache=disabled",
      "-Dstatic-libclc='all'"
    ]
  }
}
& {
  lib,
  drvs,
  _mesa2426,
  mesaFull,
  mesa2434Clc | lib.MesonPackage = {
    singleSource = {
      uri = "https://archive.mesa3d.org/mesa-24.3.4.tar.xz",
      sha256sum = "e641ae27191d387599219694560d221b7feaa91c900bcec46bf444218ed66025"
    },
    biDrvs = _mesa2426.biDrvs @ [drvs.libclc],
    patches = _mesa2426.patches,
    llvmProvider = _mesa2426.llvmProvider,

    extraMesonArgs = [
      "-Dintel-clc=enabled",
      # "-Dintel-rt=disabled",
      # "-Dstatic-libclc=enabled",
      # "-Dmesa-clc-bundle-headers=enabled",
      "-Dshared-llvm=disabled",
      "-Dgallium-drivers=''",
      "-Dplatforms=''",
      "-Dvulkan-drivers=''",
      "-Dcpp_rtti=false",
      "-Dinstall-intel-clc=true",
      "-Dvideo-codecs='all'",
      "-Dshader-cache=disabled",
      "-Dstatic-libclc='all'"
    ]
  }
}
& {
  lib,
  drvs,
  libclc | lib.CmakePackage = {
    llvmProvider = drvs.llvmFull,
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.8/libclc-20.1.8.src.tar.xz",
      sha256sum = "ecd83a52859742f71f4c332538f8bee54a6743374a233b5a85017de22d75c227"
    },
    biDrvs = [
      drvs.llvmConfigStatic,
      drvs.spirvTools,
      drvs.spirvLlvmTranslator,
      drvs.libelf,
      drvs.libdrm,
      drvs.zlibNg,
      drvs.pythonMako,
      drvs.libpciaccess,
      drvs.libffi,
      drvs.pythonFull,
    ]
  }
}
