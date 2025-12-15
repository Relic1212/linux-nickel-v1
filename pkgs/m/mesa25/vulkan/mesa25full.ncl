{
  lib,
  drvs,
  mesa2,
  mesaFull =
    mesa2
    & {

      extraMesonArgs | priority 1 = [
        "-Dgles1=disabled",
        "-Dxmlconfig=disabled",
        "-Dshared-llvm=disabled",
        "-Dgles2=enabled",
        # "-Dgles2=disabled",
        #   "-Ddri3=disabled",
        "-Dopengl=true",
        # "-Dopengl=false",
        "-Dgallium-drivers=radeonsi,virgl,i915,crocus,iris",
        # "-Dgallium-drivers=''",
        "-Dplatforms='wayland,x11'",
        # "-Dplatforms=''",
        "-Dcpp_rtti=false",
        "-Dgbm=enabled",
        # "-Dgbm=disabled",
        "-Dzstd=enabled",
        "-Dzlib=enabled",
        "-Dglvnd=disabled",
        "-Dvulkan-drivers=amd,virtio,intel",
        # "-Dvulkan-layers=device-select",
        "-Dvulkan-layers=overlay,device-select",
        # "-Dvulkan-layers=''",
        "-Dshader-cache=disabled",
        "-Dexpat=disabled",
        "-Dvideo-codecs='all'",
        "-Dtools=''",
        "-Degl=enabled",
        "-Dglx-read-only-text=true",
        "-Dimagination-srv=false",
        "-Dglx=dri",
        "-Dglx=disabled",
        #   "-Dopencl-spirv=false",
        #   "-Dosmesa=false",
        "-Dvulkan-beta=true",
        "-Degl-native-platform=wayland",
        # "-Degl-native-platform=drm",
        # "-Degl-native-platform=auto",
        #  "-Dllvm=disabled",
        "-Dunversion-libgallium=true",
        "-Dradv-build-id=eacebefb-54f9-4b7f-9ebe-3f9c33ae41da",
        "-Damd-use-llvm=false",
      ],
      baseMesonArgs = lib.constants.mesonArgsDebug @ lib.constants.mesonArgsStatic,
      debug = true,
      buildEnv._debug = true,
      options = {
        renamedDl | default = true,
      },

      patches | priority 1 =
        mesa2.patches
        @ [
          {
            sha256sum = "f224c21164f80f9766df0ba2531b11c6da43a6d61178e1e5e55da90cd2c6858c",
            file = "mesa-glx-no-dups.patch"
          },
          {
            file = "mesa-vulkan.patch",
            sha256sum = "2d2a8bee17e092637f11ae3761ae730feb090df994226b59e361ab88573fccc0",
          }
        ],
      preConfigurePhase | priority 1 =
        mesa2.preConfigurePhase
        @ [

          # m%"
          # echo "
          # pkg.generate(
          #   name : 'libvulkan_radeon',
          #   description : 'Mesa libvulkan_radeon Library',
          #   version : meson.project_version(),
          #   libraries : libvulkan_radeon,
          #   libraries_private:  [dep_llvm, dep_thread, dep_elf, dep_dl, dep_m, dep_valgrind, radv_deps, idep_aco, idep_mesautil, idep_nir, idep_vulkan_util, idep_vulkan_wsi, idep_vulkan_runtime, idep_amdgfxregs_h, idep_xmlconfig],
          #   requires_private :  [dep_llvm, dep_thread, dep_elf, dep_dl, dep_m, dep_valgrind, radv_deps, idep_aco, idep_mesautil, idep_nir, idep_vulkan_util, idep_vulkan_wsi, idep_vulkan_runtime, idep_amdgfxregs_h, idep_xmlconfig],
          # )
          # " >> ${SRC}/src/amd/vulkan/meson.build
          # "%,
          m%"echo "
        pkg.generate(libvulkan_radeon)
        " >> ${SRC}/src/amd/vulkan/meson.build"%,
          # m%"sed -i "s|'hidden'|'default'|g" ${SRC}/src/vulkan/runtime/meson.build"%,
          # m%"sed -i "s|'hidden'|'default'|g" ${SRC}/src/amd/vulkan/meson.build"%,
          # m%"sed -i "s|GetPhysicalDeviceProperties2|GetPhysicalDeviceProperties|g" ${SRC}/src/vulkan/wsi/wsi_common.c"%,
          # m%"sed -i 's|&pdp2|\&\(pdp2.properties\)|g' ${SRC}/src/vulkan/wsi/wsi_common.c"%,
        ],

      # buildEnv = {
      #   EXTRA_CFLAGS|priority 1 =   [ "--verbose", "-Wl,--verbose"],
      #   EXTRA_LDFLAGS|priority 1 =  [ "--verbose", "-Wl,--verbose"],

      # },
      postInstallPhase =
        (
          let syms = [
            # "vk_icdGetInstanceProcAddr",
            # "vk_icdGetPhysicalDeviceProcAddr",
            # "vk_icdNegotiateLoaderICDInterfaceVersion",

            #         "vk_common_EnumeratePhysicalDeviceGroups",
            # "vk_common_EnumeratePhysicalDevices",
            # "vk_enumerate_instance_extension_properties",
            # "vk_get_negotiated_icd_version",
            # "vk_instance_add_driver_trace_modes",
            # "vk_instance_end_renderdoc_capture",
            # "vk_instance_finish",
            # "vk_instance_get_physical_device_proc_addr",
            # "vk_instance_get_proc_addr",
            # "vk_instance_get_proc_addr_unchecked",
            # "vk_instance_init",
            # "vk_instance_start_renderdoc_capture",
          ]
          in
          (
            (std.array.map (fun sym => "llvm-objcopy --redefine-sym %{sym}=radeon__%{sym} ${DEST}/usr/lib/libvulkan_radeon.a") syms)
            @ (std.array.map (fun sym => "llvm-objcopy --redefine-sym %{sym}=intel__%{sym} ${DEST}/usr/lib/libvulkan_intel.a") syms)
            @ (std.array.map (fun sym => "llvm-objcopy --redefine-sym %{sym}=virtio__%{sym} ${DEST}/usr/lib/libvulkan_virtio.a") syms)
          )
        )
        @ (
          if options.renamedDl then
            [
              # "llvm-objcopy --redefine-sym dlopen=dlopen_vulkan ${DEST}/usr/lib/libvulkan_radeon.a",
              # "llvm-objcopy --redefine-sym dlsym=dlsym_vulkan ${DEST}/usr/lib/libvulkan_radeon.a",
              # "llvm-objcopy --redefine-sym dladdr=dladdr_vulkan ${DEST}/usr/lib/libvulkan_radeon.a",
              m%"for f in $(find ${DEST}/usr/lib -name '*.a'); do
            llvm-objcopy --redefine-sym dlopen=dlopen_vulkan ${f}
            llvm-objcopy --redefine-sym dlsym=dlsym_vulkan ${f}
            llvm-objcopy --redefine-sym dladdr=dladdr_vulkan ${f}
          done
          "%,

              # m%"
              # for sym in $(llvm-nm ${DEST}/usr/lib/libvulkan_radeon.a |grep " t vk_"|cut -d ' ' -f3); do
              #   echo "globalizing ${sym} in libvulkan_radeon"
              #   llvm-objcopy --globalize-symbol ${sym} ${DEST}/usr/lib/libvulkan_radeon.a
              # done
              # "%,
              # m%"llvm-objcopy --globalize-symbol vk_physical_device_from_handle ${DEST}/usr/lib/libvulkan_radeon.a"%
            ]
          else
            []
        ),
      llvmProvider | priority 1 = drvs.llvmFull,
      biDrvs | priority 1 = [
        drvs.libelf,
        drvs.libdrmDebug,
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
        drvs.spirvToolsDebug,
        drvs.glslangDebug,
        drvs.spirvLlvmTranslatorDebug,
        drvs.wayland,
        drvs.waylandProtocols,
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
        # drvs.xwayland,
        drvs.libxkbfile,
        drvs.openssl,
        drvs.xcbUtilWm,
        drvs.xcbUtilErrors,
        drvs.libxext,
        drvs.libxf86vm,
        drvs.libxrandr,
        drvs.zstd,
      ]
    },
  mesaFullDl =
    mesaFull
    & {
      options.renamedDl = false,
    }
}
& (import "glslang.ncl")
& (import "libdl-vulkan.ncl")
& (import "sway-vulkan.ncl")
& (import "vulkan-headers.ncl")
& (import "vulkan-loader.ncl")
& (import "vulkan-tools.ncl")
