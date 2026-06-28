{
  drvs,
  mesa,
  lib,
  mesa2 | lib.MesonPackage = {

    extraMesonArgs = [
      "-Dgles1=disabled",
      "-Dxmlconfig=disabled",
      "-Dshared-llvm=disabled",
      "-Dgles2=enabled",
      #   "-Dgallium-nine=false",
      #   "-Ddri3=disabled",
      "-Dopengl=true",
      "-Dgallium-drivers=radeonsi,virgl,i915,crocus,iris",
      # "-Dgallium-drivers=radeonsi,virgl,i915,crocus,iris,nouveau",
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
      "-Dradv-build-id=eacebefb-54f9-4b7f-9ebe-3f9c33ae41da",
      "-Dradeonsi-build-id=facebefb-54f9-4b7f-9ebe-3f9c33ae41da",
      "-Damd-use-llvm=false",

      # "-Dllvm=disabled",
      # "-Dmesa-clc=disabled",
    ],

    singleSource = {
      # uri = "https://gitlab.freedesktop.org/mesa/mesa/-/archive/mesa-25.2.1/mesa-mesa-25.2.1.tar.gz",
      # sha256sum = "ae8534d4da0b8fc0e384db9e82605677143ff86bfcb7833bd8551ad36e99ca73",

      # uri = "https://gitlab.freedesktop.org/mesa/mesa/-/archive/mesa-25.2.6/mesa-mesa-25.2.6.tar.bz2",
      # sha256sum = "a33d8400c0f4ee729c1b7224834a84415681c842dbd36e2431fade180440d0a5",

      # uri = "https://gitlab.freedesktop.org/mesa/mesa/-/archive/mesa-25.3.0/mesa-mesa-25.3.0.tar.bz2",
      # sha256sum = "f30228a63cf567225ffea42464d87fdc2026e1f5c55f5cc7de69b2531688e1ce",
      # uri = "https://gitlab.freedesktop.org/mesa/mesa/-/archive/mesa-25.3.2/mesa-mesa-25.3.2.tar.bz2",
      # sha256sum = "e52aba61bee1f2fd1b9e3503626788fcf9c161bc64dcb0a9dbfdd022c7992eb8",

      # uri = "https://mesa.freedesktop.org/archive/mesa-26.0.0.tar.xz",
      # sha256sum = "2a44e98e64d5c36cec64633de2d0ec7eff64703ee25b35364ba8fcaa84f33f72",

      uri = "https://archive.mesa3d.org/mesa-26.0.4.tar.xz",
      sha256sum = "6d91541e086f29bb003602d2c81070f2be4c0693a90b181ca91e46fa3953fe78",
      # uri = "https://gitlab.freedesktop.org/mesa/mesa/-/archive/mesa-26.1.0/mesa-mesa-26.1.0.tar.bz2",
      # sha256sum = "dd7faea0eceae636f88e1aee988ca0f5bd6a1a0d3828d3f34bb030abd4476659",
    },

    extraEnv = {
      PATH = "/usr/libexec:${PATH}"
    },
    # patches = [
    #   {
    #     sha256sum = "9f8f56eaf204a3e4832ba1c898e473fe3f55d0ea5d9157a47739879e16f25dae",
    #     file = "mesa-25.3.0.patch",
    #   },
    #   {
    #     file = "mesa-no-virgl-cache.patch",
    #     sha256sum = "f5b6671dae52941927aeb8d86155b2f5d4f3966651673942b29218864c4fd08f"
    #   },
    # ],

    patches = [
      {
        sha256sum = "0e84a42748ef7b8af159047e647907de17e107ad4e39557bafdc877a329257a4",
        file = "mesa-26.0.0.patch",
      },
      {
        file = "mesa-26.0.0-no-virgl-cache.patch",

        sha256sum = "9af9263c2590fc092f2f8c96cf3ce08591b241423be121ed14980882b9479893"
      },
    ],
    preConfigurePhase = [
      "sed -i 's@main()@print()@g' ${SRC}/bin/install_megadrivers.py",
      "sed -i 's@def print()@def main()@g' ${SRC}/bin/install_megadrivers.py",

      # https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/32439/diffs?commit_id=8a453669e2bd44651cacdeac1c372d6e80cab0a7
    ],

    llvmProvider = drvs.llvmFull,
    biDrvs = [
      # drvs.libelf,
      # drvs.libdrm,
      # drvs.zlibNg,
      drvs.pythonMako,
      drvs.pythonPackaging,
      drvs.pythonMarkupsafe,
      # drvs.libpciaccess,
      # drvs.libffi,
      drvs.bison,
      drvs.flex,
      # drvs.linuxHeaders,
      drvs.m4,
      drvs.git,
      drvs.pyyaml,
      # drvs.llvmConfigStatic,
      # drvs.spirvTools,
      # drvs.spirvHeaders,
      # drvs.spirvLlvmTranslator,
      # drvs.spirvTools_glslang,
      # drvs.glslang,
      # drvs.wayland,
      # drvs.waylandProtocols,
      drvs.spirvHeaders,
      drvs.spirvLlvmTranslator,
      drvs.llvmConfigStatic,
      drvs.libclc,
    ],
    pDrvs = [
      drvs.libelf,
      drvs.libdrm,
      drvs.linuxHeaders,
      drvs.spirvTools,
      drvs.wayland,
      drvs.waylandProtocols,
      # drvs.libffi,
    ]
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
& (import "vulkan/mesa25full.ncl")
