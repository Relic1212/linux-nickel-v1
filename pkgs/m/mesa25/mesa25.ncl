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
      "-Dgallium-drivers=radeonsi,virgl,i915,crocus,iris",
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
      # "-Dllvm=enabled",
      "-Dunversion-libgallium=true",

      # "-Dllvm=disabled",
      # "-Damd-use-llvm=false",
      # "-Dmesa-clc=disabled",
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
        sha256sum = "a6b7e687652f1776e8aad6f04d2b0f613c939745581f6bd3013710cb4640ea6f",
        file = "mesa2521.patch"
      },
      {
        file = "mesa-no-virgl-cache.patch",
        sha256sum = "f5b6671dae52941927aeb8d86155b2f5d4f3966651673942b29218864c4fd08f"
      },
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
      drvs.spirvHeaders2,
      drvs.spirvLlvmTranslator,
      # drvs.spirvTools_glslang,
      # drvs.glslang,
      drvs.wayland,
      drvs.waylandProtocols,
    ],
  },
}
& {
  lib,
  drvs,
  mesa2,
  mesaExp =
    mesa2
    & {
      extraMesonArgs | priority 1 = [
        "-Dgles1=disabled",
        "-Dxmlconfig=disabled",
        "-Dshared-llvm=disabled",
        "-Dgles2=enabled",
        #   "-Dgallium-nine=false",
        #   "-Ddri3=disabled",
        "-Dopengl=true",
        "-Dgallium-drivers=radeonsi,virgl,i915,crocus,iris",
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
        "-Dlegacy-wayland='bind-wayland-display'",
        #   "-Dintel-clc=enabled",
        "-Dllvm=enabled",
        "-Dunversion-libgallium=true",
      ],
      postInstallPhase = [
        m%"
        cd ${DEST}/usr/lib 
      "%,
        m%"
      for sym in $(llvm-nm libEGL.a |grep " t egl"|cut -d ' ' -f3); do
        llvm-objcopy --globalize-symbol ${sym} libEGL.a
      done
      "%,

        # "llvm-objcopy --globalize-symbol noopEGLImageTargetRenderbufferStorageOES libgallium_dri.a",
        # "llvm-objcopy --redefine-sym=noopEGLImageTargetRenderbufferStorageOES=glEGLImageTargetRenderbufferStorageOES libgallium_dri.a",
        # "llvm-objcopy --globalize-symbol noopEGLImageTargetTexture2DOES libgallium_dri.a",
        # "llvm-objcopy --redefine-sym=noopEGLImageTargetTexture2DOES=glEGLImageTargetTexture2DOES libgallium_dri.a",
        "llvm-objcopy --redefine-sym=_mesa_EGLImageTargetRenderbufferStorageOES=glEGLImageTargetRenderbufferStorageOES libgallium_dri.a",
        "llvm-objcopy --redefine-sym=_mesa_EGLImageTargetTexture2DOES=glEGLImageTargetTexture2DOES libgallium_dri.a",

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
  mesaExp,
  mesaExpKwin =
    mesaExp
    & {
      postInstallPhase | priority 1 =
        mesaExp.postInstallPhase
        @ (
          std.array.map
            (fun s =>
              "llvm-objcopy --redefine-sym=_mesa_%{s}=gl%{s} libgallium_dri.a"
            )
            [
              "QueryCounter",
              "GetQueryObjecti64v",
              "BufferStorage",
              "BindFragDataLocation",
              "GetTexImage",
            ]
        )
    }
}
& (import "mesa25glx.ncl")
& (import "mesa25full.ncl")
