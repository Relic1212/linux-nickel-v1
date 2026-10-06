{
  drvs,
  mesa,
  lib,
  libdrm,
  libdrm26 = libdrm & { options.new = true },
  mesa26 | lib.MesonPackage = {
    debug = true,
    singleSource = {

      uri = "https://archive.mesa3d.org/mesa-26.2.4.tar.xz",
      sha256sum = "bce5f7fbebb934373b86c999a064d52fb5065878dc57f287f95346648ec832e9",
    },

    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lLLVMABI",
      ],
    },
    # extraEnv = {
    #   PATH = "/usr/libexec:${PATH}"
    # },

    eofPatches = [
      {
        patch = import "mesa26-gpm.patch" as 'Text,
      },
    ],

    extraMesonArgs = [
      "-Dgles1=disabled",
      "-Dxmlconfig=disabled",
      "-Dshared-llvm=disabled",
      "-Dgles2=enabled",
      # "-Dgallium-nine=false",
      # "-Ddri3=disabled",
      "-Dopengl=true",
      "-Dgallium-drivers=radeonsi,virgl,i915,crocus,iris",
      # "-Dgallium-drivers=radeonsi,virgl,i915,crocus,iris,nouveau",
      "-Dplatforms='wayland'",
      "-Dcpp_rtti=false",
      # "-Dshared-glapi=enabled",
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
      # "-Dgallium-xa=disabled",
      # "-Dgallium-vdpau=disabled",
      # "-Dgallium-va=disabled",
      # "-Dgallium-opencl=disabled",
      "-Dimagination-srv=false",
      "-Dglx=disabled",
      #   "-Dopencl-spirv=false",
      #   "-Dosmesa=false",
      "-Dvulkan-beta=false",
      "-Degl-native-platform=surfaceless",
      # "-Dintel-clc=enabled",
      # "-Dllvm=enabled",
      "-Dunversion-libgallium=true",
      "-Dradv-build-id=eacebefb-54f9-4b7f-9ebe-3f9c33ae41da",
      "-Dradeonsi-build-id=facebefb-54f9-4b7f-9ebe-3f9c33ae41da",
      "-Damd-use-llvm=false",
      "-Dlegacy-wayland='bind-wayland-display'",

      # "-Dllvm=disabled",
      # "-Dmesa-clc=disabled",
    ],

    preConfigurePhase = [
      "sed -i 's@main()@print()@g' ${SRC}/bin/install_megadrivers.py",
      "sed -i 's@def print()@def main()@g' ${SRC}/bin/install_megadrivers.py",
      # m%"sed -i 's@2.4.133@2.4.131@g' ${SRC}/meson.build"%,
      m%"for f in $(find "${SRC}" -name "meson.build" ); do sed -i 's@shared_library@library@g' "${f}";done"%,
      m%"sed -i -e "s@dri_gbm@libdri_gbm@g" -e "s@'gbm'@''@g" ${SRC}/src/gbm/backends/dri/meson.build"%,

      ##
      # this is to avoid errors in virgl_disk_cache_create
      m%"sed -i "s@cc.has_function('dl_iterate_phdr')@false # cc.has_function('dl_iterate_phdr')@g" ${SRC}/meson.build"%,
    ],
    postInstallPhase = [
      "mv ${DEST}/usr/lib/libgallium_dri.so ${DEST}/usr/lib/libgallium_dri.a",
      # m%"cd ${DEST}/usr/lib"%,
      # "/usr/lib/gbm/dri_gbm.a",
      m%"sed -i 's@-lgbm@ -ldri_gbm -lgbm@g' ${DEST}/usr/lib/pkgconfig/gbm.pc"%,
    ],

    llvmProvider = drvs.llvmFull,
    pythonProvider = drvs.pythonDl,
    biDrvs = [
      drvs.pythonMako,
      drvs.pythonPackaging,
      drvs.pythonMarkupsafe,
      drvs.bison,
      drvs.flex,
      drvs.m4,
      drvs.git,
      drvs.pyyaml,
      drvs.spirvHeaders,
      drvs.spirvLlvmTranslator,
      drvs.llvmConfigStatic,
      drvs.libclc,
    ],
    pDrvs = [
      drvs.libelf,
      drvs.libdrm26,
      drvs.linuxHeaders,
      drvs.spirvTools,
      drvs.wayland,
      drvs.waylandProtocols,
      # drvs.libffi,
    ]
  },
}

# postInstallPhase = [
#   m%"
#   cd ${DEST}/usr/lib 
# "%,
#   m%"
# for sym in $(llvm-nm libEGL.a |grep " t egl"|cut -d ' ' -f3); do
#   llvm-objcopy --globalize-symbol ${sym} libEGL.a
# done
# "%,

#   # "llvm-objcopy --globalize-symbol noopEGLImageTargetRenderbufferStorageOES libgallium_dri.a",
#   # "llvm-objcopy --redefine-sym=noopEGLImageTargetRenderbufferStorageOES=glEGLImageTargetRenderbufferStorageOES libgallium_dri.a",
#   # "llvm-objcopy --globalize-symbol noopEGLImageTargetTexture2DOES libgallium_dri.a",
#   # "llvm-objcopy --redefine-sym=noopEGLImageTargetTexture2DOES=glEGLImageTargetTexture2DOES libgallium_dri.a",
#   "llvm-objcopy --redefine-sym=_mesa_EGLImageTargetRenderbufferStorageOES=glEGLImageTargetRenderbufferStorageOES libgallium_dri.a",
#   "llvm-objcopy --redefine-sym=_mesa_EGLImageTargetTexture2DOES=glEGLImageTargetTexture2DOES libgallium_dri.a",

#   # m%"
#   # for sym in $(llvm-nm libEGL.a |grep " t egl"|cut -d ' ' -f3); do
#   #   llvm-objcopy --globalize-symbol ${sym} libEGL.a
#   # done
#   # "%,
# ]

#   mesaExp.postInstallPhase
#   @ (
#     std.array.map
#       (fun s =>
#         "llvm-objcopy --redefine-sym=_mesa_%{s}=gl%{s} libgallium_dri.a"
#       )
#       [
#         "QueryCounter",
#         "GetQueryObjecti64v",
#         "BufferStorage",
#         "BindFragDataLocation",
#         "GetTexImage",
#       ]
#   )
