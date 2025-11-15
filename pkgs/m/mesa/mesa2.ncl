{
  lib,
  drvs,
  _mesa | lib.MesonPackage = {

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
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.linuxHeaders,
      drvs.m4
    ],
    extraMesonArgs = [
      "-Dgles1=disabled",
      "-Dxmlconfig=disabled",
      "-Dshared-llvm=disabled",
      "-Dgles2=enabled",
      "-Dgallium-nine=false",
      "-Ddri3=disabled",
      "-Dopengl=false",
      "-Dgallium-drivers=radeonsi,virgl,iris,i915,crocus",
      "-Dllvm=disabled",
      "-Dplatforms='wayland'",
      "-Dcpp_rtti=false",
      "-Dshared-glapi=enabled",
      "-Dgbm=enabled",
      "-Dzstd=disabled",
      "-Dzlib=enabled",
      "-Dglvnd=false",
      "-Dvulkan-drivers=",
      "-Dshader-cache=disabled",
      "-Dexpat=disabled",
      "-Dvideo-codecs=''",
      "-Dtools=''",
      "-Degl=enabled",
      "-Dglx-read-only-text=true",
      "-Dgallium-xa=disabled",
      "-Dgallium-vdpau=disabled",
      "-Dgallium-va=disabled",
      "-Dgallium-opencl=disabled",
      "-Dimagination-srv=false",
      "-Dglx=disabled",
      "-Dopencl-spirv=false",
      "-Dosmesa=false",
      "-Dvulkan-beta=false",
      "-Degl-native-platform=drm",
    ],
  },
}
& {
  drvs,
  mesa,
  lib,
  _mesa2426 | lib.MesonPackage = {

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
      # drvs.wayland,
      # drvs.waylandProtocols,
      drvs.linuxHeaders,
      drvs.m4,
      drvs.git,
      drvs.pyyaml,
      drvs.llvmFull,
      drvs.llvmConfigStatic,
      drvs.spirvTools,
      drvs.spirvLlvmTranslator,
      drvs.wayland,
      drvs.waylandProtocols,
    ],
    extraMesonArgs = [
      "-Dgles1=disabled",
      "-Dxmlconfig=disabled",
      "-Dshared-llvm=disabled",
      "-Dgles2=enabled",
      "-Dgallium-nine=false",
      "-Ddri3=disabled",
      "-Dopengl=true",
      "-Dgallium-drivers=radeonsi,virgl,iris,i915,crocus",
      "-Dplatforms='wayland'",
      "-Dcpp_rtti=false",
      "-Dshared-glapi=enabled",
      "-Dgbm=enabled",
      "-Dzstd=disabled",
      "-Dzlib=enabled",
      "-Dglvnd=false",
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
      "-Dopencl-spirv=false",
      "-Dosmesa=false",
      "-Dvulkan-beta=false",
      "-Degl-native-platform=wayland",
      "-Dintel-clc=enabled",
      "-Dllvm=enabled",
    ],

    singleSource | priority 1 = {
      uri = "https://gitlab.freedesktop.org/mesa/mesa/-/archive/mesa-24.2.6/mesa-mesa-24.2.6.tar.gz",
      sha256sum = "5456ca326e84b5dda0dd93e91337ee337ac79cba15ee9d98bfae1002c24cfce1",
    },

    extraEnv = {
      PATH = "/usr/libexec:${PATH}"
    },
    patches | priority 1 = [
      {
        file = "0.patch",
        sha256sum = "f5b6671dae52941927aeb8d86155b2f5d4f3966651673942b29218864c4fd08f"
      },
      # {
      #   sha256sum="15af07497dd74b2d302af2ca7f41214fbe9f3da20ae3f78db716ea384079ec72",
      #   file="50783351bcff9be116cd6d714877ccd0952df2c4.patch",
      # },
      {

        file = "32439.patch",

        sha256sum = "0d324c58a955a5cfa475417e845d915b20e79d4a2efaf0d122dee5d0896b562f",
      }
    ],
    preConfigurePhase | priority 1 = [
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
          "%,

      # https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/32439/diffs?commit_id=8a453669e2bd44651cacdeac1c372d6e80cab0a7

      # m%"
      # sed -i \
      #   's@#include <spirv-tools/optimizer.hpp>@#include <spirv-tools/optimizer.hpp>\n#include <llvm/Support/VirtualFileSystem.h>@g' \
      #   ${SRC}/src/compiler/clc/clc_helpers.cpp

      # sed -i \
      #   's@c->createDiagnostics(new clang::TextDiagnosticPrinter(@c->createDiagnostics(*llvm::vfs::getRealFileSystem(), new clang::TextDiagnosticPrinter(@g' \
      #   ${SRC}/src/compiler/clc/clc_helpers.cpp

      # "%
    ],
    baseBuildinputPackages = std.array.filter (fun v => v.name != drvs.llvm.name) lib.MesonPackage.baseBuildinputPackages,
  },

  llvmConfigStatic | lib.Package = {
    installPhase = [
      m%"
          install -d -m0755 ${DEST}/usr/bin
          printf "#!/bin/sh
          case "\${1}" in
            "--shared-mode")
            exec echo "static"
            ;;
          esac

          exec /usr/bin/llvm-config.unwrapped "\$@"

          " > ${DEST}/usr/bin/llvm-config
          chmod +x ${DEST}/usr/bin/llvm-config
          "%,
      # m%"
      # install -d -m0755 ${DEST}/usr/libexec
      # ln -s ${DEST}/usr/bin/llvm-config-static ${DEST}/usr/libexec/llvm-config

      # "%
    ],
  },

  mesaOpengl | lib.MesonPackage =
    _mesa2426
    & {

      extraMesonArgs | priority 1 = lib.functions.replaceArrayElem "-Dopengl=false" "-Dopengl=true" _mesa2426.extraMesonArgs,

      postInstallPhase = [
        "cd ${DEST}/usr/lib/pkgconfig",
        "ln -s egl.pc opengl.pc",
      ]
    },

  mesaGlx2426 | lib.MesonPackage =
    _mesa2426
    & {

      extraMesonArgs | priority 1 = [
        "-Dgles1=disabled",
        "-Dxmlconfig=disabled",
        "-Dshared-llvm=disabled",
        "-Dgles2=enabled",
        "-Dgallium-nine=false",
        "-Ddri3=disabled",
        "-Dopengl=true",
        "-Dgallium-drivers=radeonsi,virgl,iris,i915,crocus",
        "-Dplatforms='x11,wayland'",
        "-Dcpp_rtti=false",
        "-Dshared-glapi=enabled",
        "-Dgbm=enabled",
        "-Dzstd=disabled",
        "-Dzlib=enabled",
        "-Dglvnd=false",
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
        "-Dglx=dri",
        "-Dopencl-spirv=false",
        "-Dosmesa=false",
        "-Dvulkan-beta=false",
        "-Degl-native-platform=drm",
        "-Dintel-clc=enabled",
        "-Dllvm=enabled",
      ],
      biDrvs | priority 1 =
        _mesa2426.biDrvs
        @ [
          # drvs.wayland,
          # drvs.waylandProtocols,
          drvs.libxcursor,
          drvs.xorgMacros,
          drvs.xorgproto,
          drvs.xtrans,
          drvs.libxcb,
          drvs.xcbProto,
          drvs.libxau,
          drvs.libx11,
          drvs.libxrender,
          drvs.libxfixes,
          drvs.xcbRenderutil,
          drvs.libxfont2,
          drvs.libfontenc,
          drvs.libxcvt,
          drvs.libxshmfence,
          drvs.xwayland,
          drvs.libxkbfile,
          drvs.openssl,
          drvs.xcbUtilWm,
          drvs.xcbUtilErrors,
          drvs.libxext,
          drvs.libxf86vm,
          drvs.libxrandr,
        ]
    },
}
& {
  lib,
  drvs,
  mesa2,
  mesa2NoHidden =
    mesa2
    & {
      postInstallPhase = [
        m%"
        cd ${DEST}/usr/lib 
      "%,
        m%"
      for sym in $(llvm-nm libEGL.a |grep " t egl"|cut -d ' ' -f3); do
        llvm-objcopy --globalize-symbol ${sym} libEGL.a
      done
      "%,

        # m%"
        # for sym in $(llvm-nm libEGL.a |grep " t egl"|cut -d ' ' -f3); do
        #   llvm-objcopy --globalize-symbol ${sym} libEGL.a
        # done
        # "%,
      ]
    }
}
& {
  lib,
  drvs,
  pyyaml | lib.SetuptoolPackage = {
    singleSource = {
      uri = "https://github.com/yaml/pyyaml/archive/refs/tags/6.0.2.tar.gz",
      sha256sum = "9377c381ac3fccad8df73d96b5139ef8b1a2c57a0d913e95ab0a2275d66b5caa",
    },
    baseBuildinputPackages | priority 1 =
      lib.Package.baseBuildinputPackages
      @ [
        drvs.pythonDynamic,
        drvs.pythonSetuptools,
        drvs.muslShared,
      ]
  }
}
& (
  let newMesa = (true) in
  {
    _mesa250,
    # _mesa2521,
    _mesa2426,
    _spirvTools,
    # _spirvTools2,
    # mesa2 = if newMesa then _mesa2521 else _mesa2426,
    # mesa2 = _mesa2521,
    # spirvTools = if newMesa then _spirvTools2 else _spirvTools,
    # spirvTools = _spirvTools2
    # spirvTools2 = _spirvTools2,

    # mesa2 = _mesa2426,

    # "mesa-25.0" = _mesa250,
  }
)
