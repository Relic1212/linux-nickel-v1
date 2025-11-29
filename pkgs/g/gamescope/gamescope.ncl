{
  lib,
  drvs,
  glm,
  gamescope
    | lib.MesonPackage
    = {

      sourceInputs = [
        {
          src = {

            # uri = "https://github.com/ValveSoftware/gamescope/archive/refs/tags/3.16.14.2.tar.gz",
            # sha256sum = "b45f38c26d12a630917e812623b9e64e3ff44c3d9f7e9a9c49a73d5372896685",

            uri = "https://github.com/ValveSoftware/gamescope/archive/refs/tags/3.16.14.5.tar.gz",
            sha256sum = "2a27905b0f19184d284dbc7aed3687901fb28af1859ef69cee3c46443be58811",
          }
        },
        {
          src = {

            # uri = "https://gitlab.freedesktop.org/wlroots/wlroots/-/releases/0.18.2/downloads/wlroots-0.18.2.tar.gz",
            # sha256sum = "cf776c169169f279808d9eabc6583f484338dcd454c966a285ff178c88c105d4",

            # uri = "https://gitlab.freedesktop.org/wlroots/wlroots/-/releases/0.19.0/downloads/wlroots-0.19.0.tar.gz",
            # sha256sum = "aefb0fe2633b0aad1d66123b2f41afab004fb625e2a7790492cdd39a805cac91",
            # uri = "https://gitlab.freedesktop.org/wlroots/wlroots/-/releases/0.19.2/downloads/wlroots-0.19.2.tar.gz",
            # sha256sum = "09a0a8d60104c8b0772fee4f60ba76a89aed7e59dff7659d00960fba06bdf267",

            uri = "https://gitlab.freedesktop.org/wlroots/wlroots/-/archive/0.18.3/wlroots-0.18.3.tar.bz2",
            sha256sum = "17420d4e6fa3fe9c3c5022af2706ec25c3fbd861688d69052b7ef0e77dfb1f90",
          },
          dest = "subprojects/wlroots"
        },
        {
          src = {
            uri = "https://github.com/g-truc/glm/archive/0af55ccecd98d4e5a8d1fad7de25ba429d60e863.tar.gz",
            sha256sum = "e7f187d83523f505eb38dd25d297ea6c0d4ed856d733e808f18253f5a8fa88a0"
          },
          dest = "subprojects/glm",
        },
        {
          src = {
            uri = "https://github.com/nothings/stb/archive/5736b15f7ea0ffb08dd38af21067c314d6a3aae9.tar.gz",
            sha256sum = "d00921d49b06af62aa6bfb97c1b136bec661dd11dd4eecbcb0da1f6da7cedb4c",
          },
          dest = "subprojects/stb",
        },
        {
          src = {
            uri = "https://github.com/ValveSoftware/openvr/archive/ff87f683f41fe26cc9353dd9d9d7028357fd8e1a.tar.gz",
            sha256sum = "22ea84da76f0f37f15d3433aef5f202ad6f8df12c280da7caa47e0475eeb22fd"
          },
          dest = "subprojects/openvr",
        },
        {
          src = {
            uri = "https://github.com/misyltoad/vkroots/archive/5106d8a0df95de66cc58dc1ea37e69c99afc9540.tar.gz",
            sha256sum = "37b77586e91f7ebee70380dcddd73bf01ae4acef1053e6be41d0485ede022422"
          },
          dest = "subprojects/vkroots",
        },
        {
          src = {
            uri = "https://gitlab.freedesktop.org/emersion/libliftoff/-/archive/8b08dc1c14fd019cc90ddabe34ad16596b0691f4/libliftoff-8b08dc1c14fd019cc90ddabe34ad16596b0691f4.tar.gz",
            sha256sum = "8de28aee6f90f47b7fc7037dcd2360166197c0b5d2033f3afdbd34f2ea1bf216",
          },
          dest = "subprojects/libliftoff",
        },
        {
          src = {
            uri = "https://gitlab.freedesktop.org/emersion/libdisplay-info/-/archive/66b802d05b374cd8f388dc6ad1e7ae4f08cb3300/libdisplay-info-66b802d05b374cd8f388dc6ad1e7ae4f08cb3300.tar.gz",
            sha256sum = "bca0664e23671572311b3b91f3b2fff3fd6501940320a8daff5e11b5219554a4",
          },
          dest = "subprojects/libdisplay-info",
        },
        {
          src = {
            uri = "https://github.com/misyltoad/reshade/archive/696b14cd6006ae9ca174e6164450619ace043283.tar.gz",
            sha256sum = "3aa6feda7773cc8ffa8fb012fe95e6207c776101e29198d0e0d34a0c5e339f6a"
          },
          dest = "src/reshade",
        },
        {
          src = {
            uri = "https://github.com/KhronosGroup/SPIRV-Headers/archive/d790ced752b5bfc06b6988baadef6eb2d16bdf96.tar.gz",
            sha256sum = "90141b3f6261dba643fe546d56b4539e61fe40e307c5c3b9985ea9fa0622ac3f",
          },
          dest = "thirdparty/SPIRV-Headers",
        },
        {
          src = {
            uri = "https://raw.githubusercontent.com/AerynOS/recipes/0c0b66498ea61920e31cfb082d5a457fe5fae341/g/gamescope/pkg/ftbfs-libc%2B%2B.patch",
            sha256sum = "367e498532f1333ede2828d0519686f9d6e3c1cc3ebf7fc8eae100359c85e2f8"
          }
        }
      ],
      patches = [
        {
          file = "gamescope.patch",
          sha256sum = "5ae1f5fd84a4ff2778f260723a07329228be16ac09e7064e4d5369b3fb3040c2",
        },
      ],
      buildEnv.EXTRA_LDFLAGS = [
        "-lc++",
        "-ldl_vulkan",
        "-l:libVkLayer_MESA_device_select.a",
        "-Wl,-u,vk_common_GetPhysicalDeviceProperties2",
        "-Wl,-u,vk_common_CreateSamplerYcbcrConversion",
        "-Wl,-u,radv_CreateSampler",
        "-Wl,-u,radv_CreateDescriptorPool",
        "-Wl,-u,vk_common_CreateFramebuffer",
        "-Wl,-u,vk_common_CmdCopyBufferToImage",
        "-Wl,-u,radv_CmdCopyBufferToImage2",
        "$(pkg-config --libs --static vulkan_radeon)",
      ],
      preConfigurePhase = [
        "(cd ${SRC} && patch -p1 < ftbfs-libc++.patch)",
        "(cd ${SRC}/subprojects && cp packagefiles/glm/meson.build glm/)",
        "(cd ${SRC}/subprojects && cp packagefiles/stb/meson.build stb/)",
        m%"sed -i "s|subdir('test')||g" ${SRC}/subprojects/libliftoff/meson.build"%,
        m%"sed -i 's|shared_library|library|g' ${SRC}/layer/meson.build"%,
      ],

      # extraMesonArgs = [
      # "-Dwlroots:backends=drm,libinput",
      # "-Dwlroots:color-management=enabled",
      # "-Dwlroots:renderers=gles2,vulkan",
      # ],

      llvmProvider = drvs.llvmFull,
      muslProvider = drvs.muslBothRenamedDl,
      debug = true,

      biDrvs = [
        drvs.expat,
        drvs.jsonC,
        drvs.pcre2,
        drvs.wayland,
        drvs.waylandProtocols,
        drvs.libelf,
        drvs.libpciaccess,
        drvs.libdrm,
        drvs.libxkbcommon,
        drvs.pixman,
        drvs.eudev,
        drvs.seatd,
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
        #  drvs.cmake,
        drvs.utilLinux,
        ###############################################################

        ###############################################################
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
        ###################################################
        drvs.git,
        drvs.libzip,
        drvs.spirvTools,
        drvs.mesaFullDl,
        drvs.vulkanLoaderDl,
        drvs.vulkanHeaders,
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
        # drvs.glm,
        drvs.cmake,
        drvs.libxdamage,
        drvs.libxcomposite,
        drvs.libxtst,
        drvs.libxi,
        drvs.libxres,
        drvs.libsm,
        drvs.libice,
        drvs.libxmu,
        drvs.libxt,
        drvs.elogindWithPolkit,
        drvs.libpam,
        drvs.libcap,
        drvs.attr,
        drvs.acl,
        drvs.dbus,
        drvs.libxslt,
        drvs.gudev,
        drvs.libdecor,
        drvs.glslang,
        drvs.luajit,
        drvs.libdl_vulkan,
        drvs.zstd,
        drvs.libxrandr,
      ]
    },
}
