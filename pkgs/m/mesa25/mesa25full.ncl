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
        #   "-Ddri3=disabled",
        "-Dopengl=true",
        "-Dgallium-drivers=radeonsi,virgl,i915,crocus,iris",
        "-Dplatforms='wayland,x11'",
        "-Dcpp_rtti=false",
        "-Dgbm=enabled",
        "-Dzstd=enabled",
        "-Dzlib=enabled",
        "-Dglvnd=disabled",
        "-Dvulkan-drivers=amd,virtio,intel",
        "-Dvulkan-layers=device-select",
        "-Dvulkan-layers=''",
        "-Dshader-cache=disabled",
        "-Dexpat=disabled",
        "-Dvideo-codecs='all'",
        "-Dtools=''",
        "-Degl=enabled",
        "-Dglx-read-only-text=true",
        "-Dimagination-srv=false",
        "-Dglx=dri",
        #   "-Dopencl-spirv=false",
        #   "-Dosmesa=false",
        "-Dvulkan-beta=false",
        "-Degl-native-platform=wayland",
        #  "-Dllvm=disabled",
        "-Dunversion-libgallium=true",
        "-Dradv-build-id=eacebefb-54f9-4b7f-9ebe-3f9c33ae41da",
        "-Damd-use-llvm=false",
      ],
      baseMesonArgs = lib.constants.mesonArgsDebug @ lib.constants.mesonArgsStatic,
      debug = true,
      buildEnv._debug = true,

      patches | priority 1 =
        mesa2.patches
        @ [
          {
            sha256sum = "f224c21164f80f9766df0ba2531b11c6da43a6d61178e1e5e55da90cd2c6858c",
            file = "mesa-glx-no-dups.patch"
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
          "llvm-objcopy --redefine-sym dlopen=dlopen_vulkan ${DEST}/usr/lib/libvulkan_radeon.a",
          "llvm-objcopy --redefine-sym dlsym=dlsym_vulkan ${DEST}/usr/lib/libvulkan_radeon.a",
          "llvm-objcopy --redefine-sym dladdr=dladdr_vulkan ${DEST}/usr/lib/libvulkan_radeon.a",

          # m%"
          # for sym in $(llvm-nm ${DEST}/usr/lib/libvulkan_radeon.a |grep " t vk_"|cut -d ' ' -f3); do
          #   echo "globalizing ${sym} in libvulkan_radeon"
          #   llvm-objcopy --globalize-symbol ${sym} ${DEST}/usr/lib/libvulkan_radeon.a
          # done
          # "%,
          # m%"llvm-objcopy --globalize-symbol vk_physical_device_from_handle ${DEST}/usr/lib/libvulkan_radeon.a"%
        ],
      biDrvs | priority 1 = [
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
        drvs.spirvTools_glslang,
        drvs.glslang,
        drvs.spirvLlvmTranslator,
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
    }
}
& {
  lib,
  drvs,
  glslang | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/KhronosGroup/glslang/archive/refs/tags/15.4.0.tar.gz",
      sha256sum = "b16c78e7604b9be9f546ee35ad8b6db6f39bbbbfb19e8d038b6fe2ea5bba4ff4"
    },
    cmakeExtraArgsRecord = {
      # "-DBUILD_EXTERNAL" = false,
      "-DALLOW_EXTERNAL_SPIRV_TOOLS" = true
    },
    biDrvs = [
      drvs.googletest,
      drvs.pythonFull,
      drvs.bison,
      drvs.spirvTools_glslang,
      drvs.spirvLlvmTranslator,
    ]
  },
  spirvTools_glslang | lib.CmakePackage = {
    generator = "Ninja",
    sourceInputs = [
      {
        src = {
          uri = "https://github.com/KhronosGroup/SPIRV-Tools/archive/33e02568181e3312f49a3cf33df470bf96ef293a.tar.gz",
          sha256sum = "44d1005880c583fc00a0fb41c839214c68214b000ea8dcb54d352732fee600ff",
        }
      },
      {
        dest = "external/spirv-headers",
        src = {

          uri = "https://github.com/KhronosGroup/SPIRV-Headers/archive/2a611a970fdbc41ac2e3e328802aed9985352dca.tar.gz",
          sha256sum = "c2225a49c3d7efa5c4f4ce4a6b42081e6ea3daca376f3353d9d7c2722d77a28a",
        }
      },
    ],

    cmakeExtraArgsRecord = {
      "-DSPIRV_TOOLS_BUILD_STATIC" = true
    },

    biDrvs = [
      drvs.pythonFull,
    ],

    patches = [
      # {
      #   file = "0001-no-shared.patch",
      #   sha256sum = "8f08d8582c8da16bd4e80ec3ec475988b3b2ad0f61d68fde74453c151f4ead7d",
      # }
      {
        sha256sum = "50d23b899d39519d0d28b4310c2858f8ac5ca3698e0a1cd5af38b595a24a66a4",
        file = "mesa-glslang-spirv.patch"
      }
    ]
  },
}
& {
  lib,
  drvs,
  vulkanHeaders | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/KhronosGroup/Vulkan-Headers/archive/refs/tags/v1.4.318.tar.gz",
      sha256sum = "24df01da8a5c54ee19dfee92259b7edcf44693875fbf96ccdfec69d6e3eef0bc"
    }
  }
}
& {
  lib,
  drvs,
  vulkanLoader | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.4.318.tar.gz",
      sha256sum = "b0e9488ab13d1fa946d50d7905fa71ea0536151db846ae4d3b485f869639efcb"
    },

    patches = [
      # https://stackoverflow.com/questions/5378528/install-export-problem-for-library-with-dependencies
      # https://github.com/KhronosGroup/Vulkan-Loader/commit/161b28c1e9a9894ca11f67fc9593dbcf64866bfe
      {
        sha256sum = "7d08a70a4b4af1a4ce79b6ea3e36dccb342841e4aecf0d12e350ae117fa3eebe",
        file = "vulkan-loader-no-shared.patch"
      }
    ],
    # preConfigurePhase = [
    #   m%"
    #   for f in $(find ${SRC} -type f -name CMakeLists.txt); do
    #     sed -i 's@ SHARED @ @g' ${f}
    #     sed -i 's@ SHARED)@)@g' ${f}
    #     # sed -i 's@ SHARED\n@\n@g' ${f}
    #   done
    #   "%
    # ],
    cmakeExtraArgsRecord = {
      "-DCMAKE_BUILD_TYPE" | priority 1 = "Debug",
    },
    debug = true,

    postInstallPhase = [
      # "llvm-objcopy -W loader_platform_open_library ${DEST}/usr/lib/libvulkan.a",
      # "llvm-objcopy -W loader_platform_get_proc_address ${DEST}/usr/lib/libvulkan.a",
      "llvm-objcopy --redefine-sym dlopen=dlopen_vulkan ${DEST}/usr/lib/libvulkan.a",
      "llvm-objcopy --redefine-sym dlsym=dlsym_vulkan ${DEST}/usr/lib/libvulkan.a",
      "llvm-objcopy --redefine-sym dladdr=dladdr_vulkan ${DEST}/usr/lib/libvulkan.a",
    ],

    biDrvs = [
      drvs.googletest,
      drvs.pythonFull,
      drvs.vulkanHeaders,
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
      drvs.spirvTools_glslang,
      drvs.glslang,
      drvs.spirvLlvmTranslator,
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
      drvs.xwayland,
      drvs.libxkbfile,
      drvs.openssl,
      drvs.xcbUtilWm,
      drvs.xcbUtilErrors,
      drvs.libxext,
      drvs.libxf86vm,
      drvs.libxrandr,
      drvs.zstd,
      # drvs.mesaFull,
    ]
  }
}
& {
  lib,
  drvs,
  sway,
  libdl_vulkan,

  swayVulkan =
    sway
    & {
      debug = true,
      buildEnv._debug = true,
      extraMesonArgs | priority 1 = [
        "-Dwlroots:backends=drm,libinput",
        "-Dwlroots:color-management=enabled",
        "-Dwlroots:renderers=vulkan",
        "-Dgdk-pixbuf=enabled",
        "-Dtray=enabled",
        "-Dman-pages=enabled",
      ],

      # buildEnv.EXTRA_CFLAGS | priority 1=  [ 
      #   "-Wl,--whole-archive",
      #   "-l:libdl_vulkan.a",

      #   ],
      # buildEnv.EXTRA_LDFLAGS |priority 1 = sway.buildEnv.EXTRA_LDFLAGS @ [ "-Wl,-u,vkCreateSampler"],

      sourceInputs | priority 1 =
        sway.sourceInputs
        @ [
          {
            src = libdl_vulkan.singleSource,
            dest = "lib"
          }
        ],
      buildEnv.EXTRA_LDFLAGS | priority 1 =
        sway.buildEnv.EXTRA_LDFLAGS
        @ [
          "-L/tmp/workdir/src/lib",
          # "-Wl,--whole-archive",
          "-l:libdl_vulkan.a",
          # "-Wl,--no-whole-archive",

          # "-l:libvulkan_radeon.a",
          # "-l:libvulkan_intel.a",
          # "-l:libvulkan_virtio.a",
          "$(pkg-config --libs --static vulkan_radeon)",
          #  "-Wl,-u,vkCreateSampler",
        ],

      preConfigurePhase | priority 1 =
        sway.preConfigurePhase
        @ [
          "clang  --verbose -c -DHAVE_RADEON ${SRC}/lib/dl2.c -o ${SRC}/lib/dl.c.o",
          "llvm-ar rcs ${SRC}/lib/libdl_vulkan.a ${SRC}/lib/dl.c.o",
          "llvm-ranlib ${SRC}/lib/libdl_vulkan.a",
        ],
      baseMesonArgs = lib.constants.mesonArgsDebug @ lib.constants.mesonArgsStatic,

      biDrvs | priority 1 = [
        # drvs.libdl_vulkan,
        drvs.expat,
        drvs.jsonC,
        drvs.pcre2,
        drvs.mesaFull,
        drvs.spirvTools_glslang,
        drvs.glslang,
        drvs.vulkanLoader,
        drvs.vulkanHeaders,
        drvs.wayland,
        drvs.waylandProtocols,
        drvs.libelf,
        drvs.libpciaccess,
        drvs.libdrm,
        drvs.libxkbcommon,
        drvs.pixman,
        drvs.eudev,
        drvs.libdisplayinfo,
        drvs.libinput,
        drvs.libffi,
        drvs.libevdev,
        drvs.mtdev,
        drvs.pango,
        drvs.cairo,
        drvs.libpng,
        drvs.freetype,
        drvs.fontconfig,
        drvs.zlibNg,
        drvs.harfbuzz,
        drvs.glib,
        drvs.hwdata,
        drvs.linuxHeaders,

        # For optional features
        drvs.gdkPixbufFull,
        drvs.libjpegTurbo,
        # drvs.basu,
        drvs.lcms,
        drvs.scdoc,
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
        drvs.zstd,
      ],
    }
}
& {
  lib,
  drvs,
  libdl_vulkan | lib.Package = {
    singleSource = {
      uri = "/home/user/Projects/test-static-linking/vulkan/dl2.c",
      # uri = "/home/user/Projects/test-static-linking/vulkan/libdl_vulkan.a",
      sha256sum = "2fbd8207c0ae473c6d13314841d10dff9b2b769927d8978f4add1f8c554870f7"
    },
    buildPhase = [
      "clang -c ${SRC}/dl2.c -o dl.c.o",
      "llvm-ar rcs libdl_vulkan.a dl.c.o",
      "llvm-ranlib libdl_vulkan.a",
    ],

    installPhase = [
      "install -d -m755 ${DEST}/usr/lib",
      "install -m755 libdl_vulkan.a ${DEST}/usr/lib",
    ],
    biDrvs = [
      drvs.llvm,
    ]
  }
}
