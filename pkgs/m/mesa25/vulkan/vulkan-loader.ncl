{
  lib,
  drvs,
  vulkanLoader | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      # uri = "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.4.318.tar.gz",
      # sha256sum = "b0e9488ab13d1fa946d50d7905fa71ea0536151db846ae4d3b485f869639efcb",
      # uri = "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.4.334.tar.gz",
      # sha256sum = "c2020c76f24c8f1139fe76f06d4d15bad615895de4ec32f9034cb321514824dd",
      uri = "https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v1.4.343.tar.gz",
      sha256sum = "42d78c1b7c70e52f12055a2bc91a33a4ca22f16dd6d76c7caee6ade096200002",
    },

    patches = [
      # https://stackoverflow.com/questions/5378528/install-export-problem-for-library-with-dependencies
      # https://github.com/KhronosGroup/Vulkan-Loader/commit/161b28c1e9a9894ca11f67fc9593dbcf64866bfe
      # {
      #   sha256sum = "7d08a70a4b4af1a4ce79b6ea3e36dccb342841e4aecf0d12e350ae117fa3eebe",
      #   file = "vulkan-loader-no-shared.patch"
      # },
      # {
      #   sha256sum = "4d5014c01a1afe60cd76c0c4356f06fe10e7ec0e93448a1f2a9a5a2f0f2fc873",
      #   file = "vulkan-loader-no-shared-v2.patch"
      # },
      {
        sha256sum = "87a54b939172c0f639990951883c3e82fb0034009110d0df97e5bc97682d5afd",
        file = "vulkan-loader-no-shared-v3.patch"
      },
    ],

    preConfigurePhase = [
      # m%"sed -i 's|SHARED|STATIC|g' ${SRC}/loader/CMakeLists.txt"%,
      # m%"sed -i 's|EXPORT VulkanLoaderConfig DESTINATION|EXPORT vulkan VulkanLoaderConfig DESTINATION|g' ${SRC}/loader/CMakeLists.txt"%,

      # m%"sed -i 's|TARGETS vulkan EXPORT VulkanLoaderConfig|TARGETS vulkan loader_specific_options EXPORT VulkanLoaderConfig|g' ${SRC}/loader/CMakeLists.txt"%,

      #   m%"
      #   for f in $(find ${SRC} -type f -name CMakeLists.txt); do
      #     sed -i 's@ SHARED @ @g' ${f}
      #     sed -i 's@ SHARED)@)@g' ${f}
      #     # sed -i 's@ SHARED\n@\n@g' ${f}
      #   done
      #   "%
      m%"sed -i 's|HAVE_REALPATH|NO_HAVE_REALPATH|g' ${SRC}/loader/loader.c"%,
    ],
    cmakeExtraArgsRecord = {
      "-DCMAKE_BUILD_TYPE" | priority 1 = "Debug",
      "-DBUILD_WSI_XCB_SUPPORT" = false,
      "-DBUILD_WSI_XLIB_SUPPORT" = false,
      "-DBUILD_WSI_XLIB_XRANDR_SUPPORT" = false,
    },
    debug = true,
    options = {
      renameDl | default = true,
    },

    postInstallPhase = (
      if options.renameDl then
        [
          # "llvm-objcopy -W loader_platform_open_library ${DEST}/usr/lib/libvulkan.a",
          # "llvm-objcopy -W loader_platform_get_proc_address ${DEST}/usr/lib/libvulkan.a",
          "llvm-objcopy --redefine-sym dlopen=dlopen_vulkan ${DEST}/usr/lib/libvulkan.a",
          "llvm-objcopy --redefine-sym dlsym=dlsym_vulkan ${DEST}/usr/lib/libvulkan.a",
          "llvm-objcopy --redefine-sym dladdr=dladdr_vulkan ${DEST}/usr/lib/libvulkan.a",
        ]
      else
        []
    ),
    llvmProvider | priority 1 = drvs.llvmFullDebug,

    biDrvs = [
      drvs.googletest,
      drvs.pythonFull,
      drvs.vulkanHeaders,
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
      # drvs.mesaFull,
    ]
  },
  vulkanLoaderDl =
    vulkanLoader
    & {

      options.renameDl = false,
      cmakeExtraArgsRecord = {
        "-DCMAKE_BUILD_TYPE" | priority 1 = "Debug",
        "-DBUILD_WSI_XCB_SUPPORT" | priority 1 = true,
        "-DBUILD_WSI_XLIB_SUPPORT" | priority 1 = true,
        "-DBUILD_WSI_XLIB_XRANDR_SUPPORT" | priority 1 = true,
      },
    },
}
