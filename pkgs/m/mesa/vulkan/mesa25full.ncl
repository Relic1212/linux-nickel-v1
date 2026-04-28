{
  lib,
  drvs,
  mesa2,
  mesaFull =
    mesa2
    & {
      singleSource | priority 1 = {
        uri = "https://mesa.freedesktop.org/archive/mesa-26.0.0.tar.xz",
        sha256sum = "2a44e98e64d5c36cec64633de2d0ec7eff64703ee25b35364ba8fcaa84f33f72"
      },

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
        [
          {
            sha256sum = "0e84a42748ef7b8af159047e647907de17e107ad4e39557bafdc877a329257a4",
            file = "mesa-26.0.0.patch",
          },
          {
            file = "mesa-26.0.0-no-virgl-cache.patch",

            sha256sum = "9af9263c2590fc092f2f8c96cf3ce08591b241423be121ed14980882b9479893"
          },
        ]
        @ [
          {
            sha256sum = "f224c21164f80f9766df0ba2531b11c6da43a6d61178e1e5e55da90cd2c6858c",
            file = "mesa-glx-no-dups.patch"
          },
          {
            file = "mesa-vulkan.patch",
            sha256sum = "d235a0d32a2c12ebbd9174ad4b8f2957f1f563ee494b3c2d949e7b4bfef76244",
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
          m%"sed -i "s@hidden@default@g" ${SRC}/src/amd/vulkan/meson.build"%,
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
        @ [
          # m%"for symbol in $(llvm-nm ${DEST}/usr/lib/libvulkan_radeon.a |grep "w radv_"|rev | cut -d ' ' -f1|rev); do"%,
          # m%"  echo "globalizing: ${symbol}""%,
          # "  objcopy --globalize-symbol ${symbol} ${DEST}/usr/lib/libvulkan_radeon.a",
          # "done"
        ]
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
        drvs.bison,
        drvs.flex,
        drvs.git,
        drvs.glslangDebug,
        drvs.libdrmDebug,
        drvs.libelf,
        drvs.libffi,
        drvs.libfontenc,
        drvs.libpciaccess,
        drvs.libx11,
        drvs.libxau,
        drvs.libxcb,
        drvs.libxcursor,
        drvs.libxcvt,
        drvs.libxext,
        drvs.libxf86vm,
        drvs.libxfixes,
        drvs.libxfont2,
        drvs.libxkbfile,
        drvs.libxrandr,
        drvs.libxrender,
        drvs.libxshmfence,
        drvs.linuxHeaders,
        drvs.llvmConfigStatic,
        drvs.m4,
        drvs.openssl,
        drvs.pythonMako,
        drvs.pythonMarkupsafe,
        drvs.pythonPackaging,
        drvs.pyyaml,
        drvs.spirvLlvmTranslatorDebug,
        drvs.spirvToolsDebug,
        drvs.wayland,
        drvs.waylandProtocols,
        drvs.xcbProto,
        drvs.xcbRenderutil,
        drvs.xcbUtilErrors,
        drvs.xcbUtilWm,
        drvs.xorgMacros,
        drvs.xorgproto,
        drvs.xtrans,
        drvs.zlibNg,
        drvs.zstd,
      ],
      propagatedBuildInputs | priority 1 = [],
    },
  mesaFullDl =
    mesaFull
    & {
      options.renamedDl = false,

      preConfigurePhase | priority 2 =
        mesaFull.preConfigurePhase
        @ [
          # m%"sed -i 's|VK_ENTRY_WEAK VK_ENTRY_HIDDEN||g' ${SRC}/src/vulkan/util/vk_entrypoints_gen.py"%,
          # m%"sed -i 's|VK_ENTRY_WEAK VK_ENTRY_HIDDEN|VK_ENTRY_HIDDEN|g' ${SRC}/src/vulkan/util/vk_entrypoints_gen.py"%,
          # m%"sed -i 's|VK_ENTRY_WEAK VK_ENTRY_HIDDEN|VK_ENTRY_WEAK|g' ${SRC}/src/vulkan/util/vk_entrypoints_gen.py"%,
          # m%"sed -i 's@VK_ENTRY_WEAK VK_ENTRY_HIDDEN@__attribute__((weak))@g' ${SRC}/src/vulkan/util/vk_entrypoints_gen.py"%,
        ],

      # postInstallPhase | priority 1 =  [
      #   "objcopy --globalize-symbol wsi_EnumerateInstanceVersion ${DEST}/usr/lib/libvulkan_radeon.a",
      #   "objcopy --globalize-symbol vk_common_EnumerateInstanceVersion ${DEST}/usr/lib/libvulkan_radeon.a",
      # ]
    },
}
& (import "glslang.ncl")
& (import "libdl-vulkan.ncl")
& (import "sway-vulkan.ncl")
& (import "vulkan-headers.ncl")
& (import "vulkan-loader.ncl")
& (import "vulkan-tools.ncl")
