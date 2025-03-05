 {
  drvs,
  mesa,
  lib,
  "mesa-25.0" | lib.MesonPackage
    = {

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
        drvs.spirvTools2,
        drvs.spirvLlvmTranslator,
         drvs.wayland,
        drvs."waylandProtocols-1.39",
      ],
      llvmProvider = drvs.llvmFull,
      # symlinkBuldInputs = true,
      extraMesonArgs = [
        "-Dgles1=disabled",
        "-Dxmlconfig=disabled",
         "-Dshared-llvm=disabled",
        "-Dgles2=enabled",
        "-Dgallium-nine=false",
        # "-Ddri3=disabled",
        "-Dopengl=true",
        "-Dgallium-drivers=radeonsi,virgl,iris,i915,crocus",
        "-Dplatforms='wayland'",
        "-Dcpp_rtti=false",
        "-Dshared-glapi=enabled",
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
        "-Dgallium-xa=disabled",
        "-Dgallium-vdpau=disabled",
        "-Dgallium-va=disabled",
        "-Dgallium-opencl=disabled",
        "-Dimagination-srv=false",
        "-Dglx=disabled",
        "-Dosmesa=false",
        "-Dvulkan-beta=false",
        "-Degl-native-platform=wayland",
        # "-Dintel-clc=disabled",
        "-Dllvm=enabled",
        # "-Dllvm=disabled",
      ],

      singleSource | priority 1
        = {
          uri = "https://gitlab.freedesktop.org/mesa/mesa/-/archive/mesa-25.0.0/mesa-mesa-25.0.0.tar.gz",
          sha256sum = "76d317065b127ea550d490082bf5be1255464a82cd78152dbaea4c077de6be71",
        },

      extraEnv = {
        PATH = "/usr/libexec:${PATH}"
      },
      patches | priority 1
        = [
          {
            file = "0.patch",
            sha256sum = "f5b6671dae52941927aeb8d86155b2f5d4f3966651673942b29218864c4fd08f"
          },
        ],
      preConfigurePhase | priority 1
        = [
          m%"
          sed -i 's@main()@print()@g' ${SRC}/bin/install_megadrivers.py
          sed -i 's@def print()@def main()@g' ${SRC}/bin/install_megadrivers.py

          for f in $(find ${SRC} -type f -name meson.build );
              do sed -i 's@shared_library@library@g' $f;
          done

          "%,
          m%"
          sed -i \
            "s@name_suffix : 'so',@name_suffix : 'a',@g" \
            ${SRC}/src/gallium/targets/dri/meson.build
          "%
        ],
    },
}