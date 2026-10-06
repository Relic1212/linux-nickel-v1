{
  lib,
  drvs,
  wayfire | lib.MesonPackage = {
    sourceInputs =
      [
        {
          src = {
            uri = "https://github.com/WayfireWM/wayfire/archive/refs/tags/v0.11.0.tar.gz",
            sha256sum = "90e3750e685e874b17c64546b97df7a521b47e3fce8f74ebfc785ddeb9a8bd0a",
          }
        },
        #  {
        #   src = {
        #     uri = "https://gitlab.freedesktop.org/wlroots/wlroots/-/archive/e8e76dc2954e1bc4cfe6bbf104996a932b9eb807/wlroots-e8e76dc2954e1bc4cfe6bbf104996a932b9eb807.tar.gz",
        #     sha256sum = "f89797791f20e14df8319acdfa68e57002fb85efc5977bf22ae9b45fe7583e5d"
        #   },
        #   dest = "subproject/wlroots"
        # },
      ]
      @ [
        {
          src = {
            uri = "https://github.com/WayfireWM/wf-config/archive/add9ba7a47492d4f86482b0a308d9054a825637e.tar.gz",
            sha256sum = "e7ab33a3731bcb310277b317abad2581b7ac0a9d8ed880d815ccb1ddd94c917e"
          },
          dest = "subprojects/wf-config"
        },
        {
          src = {
            uri = "https://gitlab.freedesktop.org/wlroots/wlroots/-/archive/d783533489e1f75d6886c2ab5c5960090ef268f8/wlroots-d783533489e1f75d6886c2ab5c5960090ef268f8.tar.gz",

            sha256sum = "d4d7c5f4ff5729d5eff33859b58ab7ced812aca54367b75ecbdaf9aae448fff6"
          },
          dest = "subprojects/wlroots"
        },
        {
          src = {
            uri = "https://github.com/WayfireWM/wf-utils/archive/329c3ff01724d82947f61c45332f75d3534e8454.tar.gz",
            sha256sum = "8db61d58daf7daf4484b0d5318456f80a30cda13b619b8f8cb5f623b0f0974a3"
          },
          dest = "subprojects/wf-utils"
        },
        {
          src = {
            uri = "https://github.com/WayfireWM/wf-touch/archive/d7ae5e7fa4de9536e2de2af74f168f981eb8a77a.tar.gz",
            sha256sum = "bdb2b0548ad42ccc90f0b918f172d58de7df38184143db3cc9d940b7986d72f1"
          },
          dest = "subprojects/wf-touch"
        },
        {
          src = {
            uri = "https://github.com/WayfireWM/wf-json/archive/70039e13cdeaebd8ec498ed30bf5ab91c2e313ec.tar.gz",
            sha256sum = "749d9f649f82570d860c0742c11ff83ff1b108ca7a8ec02c5c3e5f439084fafa"
          },
          dest = "subprojects/wf-json"
        },
        {
          src = {
            # uri = "https://gitlab.freedesktop.org/ammen99/wlroots/archive/4c89d4b687826641b37e65441ad1cdd1eca40551.tar.gz",
            uri = "https://gitlab.freedesktop.org/ammen99/wlroots/-/archive/4c89d4b687826641b37e65441ad1cdd1eca40551/wlroots-4c89d4b687826641b37e65441ad1cdd1eca40551.tar.gz",
            sha256sum = "2fcb9f8b01f94e24cd95c03ba97c853b4b6cbcbf012b7bbf524b4e089625c025"
          },
          dest = "subprojects/wlroots-vkfx"
        },
        # {
        #   src = {
        #     uri = "https://github.com/ibireme/yyjson/archive/refs/tags/0.13.0.tar.gz",
        #     sha256sum = "34e0f62a2bc11ab20d601e8ca1cc2b2079503aa45119a19133d89d19b94a0fae"
        #   },
        #   dest = "subprojects/yyjson",
        # },
      ],

    extraMesonArgs = [
      "-Dwlroots:backends=drm,libinput",
      "-Denable_openmp=false",
      "-Denable_gles32=false",
      "-Dtests=disabled",
      "-Dxwayland=disabled",
    ],

    buildEnv = {
      EXTRA_LDFLAGS = ["-lc++"],
      EXTRA_CPPFLAGS = ["-I/usr/include/libxml2"],
      EXTRA_CXXFLAGS = ["-I/usr/include/libxml2", ],
    },

    preConfigurePhase = [
      ###
      m%"sed -i "s@#include <functional>@#include <functional>\n#include <vector>@g" ${SRC}/src/api/wayfire/signal-provider.hpp"%,
      ###
      m%"sed -i "s@#include <algorithm>@#include <algorithm>\n#include <cmath>@g" ${SRC}/src/api/wayfire/geometry.hpp"%,
      ### 
      m%"sed -i 's@shared_library@library@g' ${SRC}/plugins/blur/meson.build"%,
      m%"sed -i 's@shared_module@library@g' ${SRC}/plugins/*/meson.build"%,
      m%"sed -i 's@shared_module@library@g' ${SRC}/src/meson.build"%,
    ],

    llvmProvider = drvs.llvmFull,
    biDrvs = [
      # drvs.cmake,
      drvs.gettext,
    ],
    pDrvs = [
      drvs.pango,
      drvs.mesa2,
      drvs.glmWf,
      drvs.libinput,
      drvs.seatd,
      drvs.libxkbcommon,
      drvs.hwdata,
      drvs.libdisplayinfo,
      drvs.yyjson,
      drvs.libxml2,
    ],
  },
}
