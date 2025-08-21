{
  drvs,
  mesa,
  lib,
  _mesa2521 | lib.MesonPackage = {

    extraMesonArgs = [
      "-Dgles1=disabled",
      "-Dxmlconfig=disabled",
      "-Dshared-llvm=disabled",
      "-Dgles2=enabled",
      #   "-Dgallium-nine=false",
      #   "-Ddri3=disabled",
      "-Dopengl=true",
      "-Dgallium-drivers=radeonsi,virgl,i915,crocus",
      "-Dplatforms='wayland'",
      "-Dcpp_rtti=false",
      #   "-Dshared-glapi=enabled",
      "-Dgbm=enabled",
      "-Dzstd=disabled",
      "-Dzlib=enabled",
      "-Dglvnd=disabled",
      "-Dvulkan-drivers=",
      "-Dshader-cache=disabled",
      "-Dexpat=disabled",
      "-Dvideo-codecs='all'",
      "-Dtools=''",
      "-Degl=enabled",
      "-Dglx-read-only-text=true",
      #   "-Dgallium-xa=disabled",
      #   "-Dgallium-vdpau=disabled",
      #   "-Dgallium-va=disabled",
      #   "-Dgallium-opencl=disabled",
      "-Dimagination-srv=false",
      "-Dglx=disabled",
      #   "-Dopencl-spirv=false",
      #   "-Dosmesa=false",
      "-Dvulkan-beta=false",
      "-Degl-native-platform=wayland",
      #   "-Dintel-clc=enabled",
      "-Dllvm=enabled",
    ],

    singleSource = {
      uri = "https://gitlab.freedesktop.org/mesa/mesa/-/archive/mesa-25.2.1/mesa-mesa-25.2.1.tar.gz",
      sha256sum = "ae8534d4da0b8fc0e384db9e82605677143ff86bfcb7833bd8551ad36e99ca73",
    },

    extraEnv = {
      PATH = "/usr/libexec:${PATH}"
    },
    patches = [
      {
        sha256sum = "773d0d7f34ac40a3cdf6ef651cc6cdbcbeda185b6041f9a5814c89ac9d12aa1f",
        file = "mesa2521.patch"
      }
    ],
    preConfigurePhase = [
      "sed -i 's@main()@print()@g' ${SRC}/bin/install_megadrivers.py",
      "sed -i 's@def print()@def main()@g' ${SRC}/bin/install_megadrivers.py",

      # https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/32439/diffs?commit_id=8a453669e2bd44651cacdeac1c372d6e80cab0a7
    ],

    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.libelf,
      drvs.libdrm,
      drvs.zlibNg,
      drvs.pythonMako,
      drvs.pythonPackaging,
      drvs.pythonMarkupsafe,
      drvs.libpciaccess,
      drvs.libffi,
      drvs.bison,
      drvs.flex,
      drvs.linuxHeaders,
      drvs.m4,
      drvs.git,
      drvs.pyyaml,
      drvs.llvmConfigStatic,
      drvs.spirvTools,
      drvs.spirvLlvmTranslator,
      drvs.wayland,
      drvs.waylandProtocols,
    ],
  },
}
