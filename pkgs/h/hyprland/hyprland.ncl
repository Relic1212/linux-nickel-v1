{
  lib,
  drvs,
  pkgs,
  hyprland
    | lib.CmakePackage
    = {
      sourceInputs = [
        {
          src = {
            uri = "https://github.com/hyprwm/Hyprland/archive/e58e97b0a38b8ccc87a4304c9e4e2b37c9966875.zip",
            sha256sum = "1f67dfed21af0dae1199f7affb23c230e82bbb65edefe935fbd29596ab8f0f22",
          },
        },
        # {
        #   dest = "subprojects/hyprland-protocols",
        #   src = {
        #     uri = "https://github.com/hyprwm/hyprland-protocols/archive/c7c3f4cd0faed21fc90ba6bd06fe4f3e0e057ea8.zip",
        #     sha256sum = "4d38ee1b5a64c9e3ac4eb8820b3a2283a1f29e50c1b5b15cf28142ce980f10b0"
        #   }
        # },
        # {
        #   dest = "subprojects/tracy",
        #   src = {
        #     uri = "https://github.com/wolfpld/tracy/archive/37aff70dfa50cf6307b3fee6074d627dc2929143.zip",
        #     sha256sum = "22a7180fe790194af3db3c796a4c239da7c8b9bd98f680811598b911ef9d23da"
        #   }
        # },
        # {
        #   dest = "subprojects/udis86",
        #   src = {
        #     uri = "https://github.com/canihavesomecoffee/udis86/archive/5336633af70f3917760a6d441ff02d93477b0c86.zip",
        #     sha256sum = "91c06980bd6abce1cd071196e3af655599ca2fcfd62328f06fcd915ed2645671",
        #   }
        # }
      ],
      llvmProvider = pkgs.llvmFull,

      biDrvs = [
        drvs.expat,
        drvs.jsonC,
        drvs.pcre2,
        drvs.mesa2,
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
        drvs.hyprwaylandScanner,
        drvs.aquamarine,
        drvs.hyprUtils,
        drvs.hyprlang,
        drvs.hyprcursor,
        #  drvs.cmake,
        drvs.tomlplusplus,
        drvs.utilLinux,
        ###############################################################
        drvs.hyprlandProtocols,
        drvs.udis86,
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
      ],

      # extraMesonArgs = [
      #   "-Dxwayland=disabled",
      #   "-Dtracy_enable=false",
      # ],

      # preConfigurePhase=[
      #   m%"
      #   sed -i "s@'opengl'@'egl'@g" ${SRC}/src/meson.build
      #   "%,
      #   # m%"
      #   # sed -i "s@server_protos,@@g" ${SRC}/src/meson.build
      #   # "%,
      #   m%"
      #   sed -i \
      #     's@link_with: lib_server_protos,@@g' \
      #     ${SRC}/protocols/meson.build
      #   "%,
      #   m%"
      #   sed -i \
      #     's@sources: wl_protocols + wayland_protocol,@sources: wayland_protocol,@g' \
      #     ${SRC}/protocols/meson.build
      #   "%,
      # ],
      generator = "Ninja",
      cmakeExtraArgsRecord = {
        "-DNO_SYSTEMD" = true,
        "-DNO_XWAYLAND" = true,
      },
       preConfigurePhase = [
        m%"
          sed -i \
            's@OpenGL::GL@OpenGL::GLES2@g' \
            ${SRC}/CMakeLists.txt

          "%,
      
      ]
    },

  aquamarine | lib.CmakePackage
    = {
      generator = "Ninja",
      singleSource = {
        uri = "https://github.com/hyprwm/aquamarine/archive/a49bc3583ff223f426cb3526fdaa4bcaa247ec14.zip",
        sha256sum = "5eb940774429f6d26245ad93f051f89d20d9e68badfaefeabf5e00a1884b3704",
      },
      llvmProvider = pkgs.llvmFull,

      biDrvs = [
        drvs.expat,
        drvs.jsonC,
        drvs.pcre2,
        drvs.mesa2,
        drvs.wayland2,
        drvs.waylandProtocols2,
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
        drvs.hyprwaylandScanner,
        drvs.hyprUtils,
      ],
      preConfigurePhase = [
        m%"
          sed -i \
            's@OpenGL::OpenGL@OpenGL::GLES2@g' \
            ${SRC}/CMakeLists.txt

          "%,
        m%"
        sed -i \
          's@aquamarine SHARED@aquamarine STATIC@g' \
          ${SRC}/CMakeLists.txt
        "%,
      ]
    },
  hyprwaylandScanner | lib.CmakePackage
    = {
      generator = "Ninja",

      singleSource = {
        uri = "https://github.com/hyprwm/hyprwayland-scanner/archive/500c81a9e1a76760371049a8d99e008ea77aa59e.zip",
        sha256sum = "8408af601bfc784500ba033b77a27e3d863a54d5e911ec39f3d84f1e67565937"
      },
      biDrvs = [
        drvs.pugixml,
      ]
    },

  pugixml | lib.CmakePackage
    = {
      generator = "Ninja",
      singleSource = {
        uri = "https://github.com/zeux/pugixml/releases/download/v1.14/pugixml-1.14.tar.gz",
        sha256sum = "2f10e276870c64b1db6809050a75e11a897a8d7456c4be5c6b2e35a11168a015"
      }
    },

  hyprUtils | lib.CmakePackage
    = {
      generator = "Ninja",
      singleSource = {
        uri = "https://github.com/hyprwm/hyprutils/archive/3ce0cde8709cdacbfba471f8e828433b58a561e9.zip",
        sha256sum = "8278af70177985de8a07fa08387b4bafc969cec90a43c565cc542d98252f6d8d"
      },
      biDrvs = [
        drvs.pixman,
      ],
      preConfigurePhase = [
        m%"
        sed -i \
          's@hyprutils SHARED@hyprutils STATIC@g' \
          ${SRC}/CMakeLists.txt
        "%
      ]
    }
}
& {
  lib,
  drvs,
  hyprcursor1 | lib.CmakePackage
    = {
      generator = "Ninja",
      singleSource = {
        # uri="https://github.com/hyprwm/hyprcursor/archive/0264e698149fcb857a66a53018157b41f8d97bb0.zip",
        # sha256sum="d533d479f339d559a285dfd8a5d47a5d4491dc834ef6aceaad315f2949748404"
        uri = "https://github.com/hyprwm/hyprcursor/archive/14faee7ed14264c85505f95f800837bfb30487d0.zip",
        sha256sum = "752c945117176d3f2c6442b10b2d331f39a86369c6343ec48bb920b170f42ee9"
      },
      biDrvs = [
        drvs.cairo,
        drvs.libzip,
        drvs.pixman,
        drvs.zlibNg,
        drvs.freetype,
        drvs.fontconfig,
        drvs.libpng,
        drvs.expat,
        drvs.hyprlang,
        drvs.hyprUtils,
      ],
      buildEnv = {
        EXTRA_CXXFLAGS = [
          "-l:libhyprlang.a -l:libhyprutils.a"
        ],
      },
      preConfigurePhase = [
        m%"
      sed -i \
        's@PUBLIC -std=gnu++2b -D__cpp_concepts=202002L@PUBLIC $<$<COMPILE_LANGUAGE:CXX>:-std=gnu++2b -D__cpp_concepts=202002L>@g' \
        ${SRC}/CMakeLists.txt
      "%,
        m%"
        sed -i \
          's@output, DATA->data@output, (uint8_t*)DATA->data@g' \
          ${SRC}/libhyprcursor/hyprcursor.cpp
          "%,
        m%"
        sed -i \
          's@hyprcursor SHARED@hyprcursor STATIC@g' \
          ${SRC}/CMakeLists.txt
        "%,
      ],
    }
}
& {
  lib,
  drvs,
  hyprcursor | lib.CmakePackage
    = {
      generator = "Ninja",
      singleSource = {
        uri = "https://github.com/hyprwm/hyprcursor/archive/0264e698149fcb857a66a53018157b41f8d97bb0.zip",
        sha256sum = "d533d479f339d559a285dfd8a5d47a5d4491dc834ef6aceaad315f2949748404"
      },
      patches = [
        {
          file = "hyprcyrsor-no-svg.patch",
          sha256sum = "78890380a3531a76b629e2742fcb100ebc74da5299f68f5bfb48d88d6cd2b42b",
        }
      ],
      biDrvs = [
        drvs.cairo,
        drvs.libzip,
        drvs.pixman,
        drvs.zlibNg,
        drvs.freetype,
        drvs.fontconfig,
        drvs.libpng,
        drvs.expat,
        drvs.hyprlang,
        drvs.hyprUtils,
        drvs.tomlplusplus,
      ],
      buildEnv = {
        EXTRA_CXXFLAGS = [
          "-l:libhyprlang.a -l:libhyprutils.a"
        ],
      },
      preConfigurePhase = [
        m%"
        sed -i \
          's@hyprcursor SHARED@hyprcursor STATIC@g' \
          ${SRC}/CMakeLists.txt
        "%,
      ],
    }
}
& {
  lib,
  drvs,
  librsvg | lib.MesonPackage
    = {
      singleSource = {
        uri = "https://gitlab.gnome.org/GNOME/librsvg/-/archive/2.59.2/librsvg-2.59.2.tar.gz",
        sha256sum = "ddd8e51426b41ef886898dc4198ca48d7e296668be19595173631fc86c79d689",
      }
    }
}
& {
  lib,
  drvs,
  libzip | lib.CmakePackage
    = {
      generator = "Ninja",
      singleSource = {
        uri = "https://github.com/nih-at/libzip/releases/download/v1.11.2/libzip-1.11.2.tar.xz",
        sha256sum = "5d471308cef4c4752bbcf973d9cd37ba4cb53739116c30349d4764ba1410dfc1",
      },
      biDrvs = [
        drvs.zlibNg,
      ]
    }
}
& {
  lib,
  drvs,
  hyprlang | lib.CmakePackage
    = {
      generator = "Ninja",
      singleSource = {
        uri = "https://github.com/hyprwm/hyprlang/archive/f054f2e44d6a0b74607a6bc0f52dba337a3db38e.zip",
        sha256sum = "70e22059dfffabd19568027a56799ebd0e284699ec5801b26cf89165a5cebc52",
      },
      biDrvs = [
        drvs.hyprUtils,
      ],
      preConfigurePhase = [
        m%"
        sed -i \
          's@hyprlang SHARED@hyprlang STATIC@g' \
          ${SRC}/CMakeLists.txt
        "%
      ]
    }
}
& {
  lib,
  drvs,
  tomlplusplus | lib.MesonPackage
    = {
      # generator="Ninja",
      singleSource = {
        uri = "https://github.com/marzer/tomlplusplus/archive/refs/tags/v3.4.0.tar.gz",
        sha256sum = "8517f65938a4faae9ccf8ebb36631a38c1cadfb5efa85d9a72e15b9e97d25155",
      },
      biDrvs = [
        drvs.cmake,
      ]
    }
}
& {
  lib,
  drvs,
  udis86 | lib.AutomakePackage
    = {
      # generator = "Ninja",
      sourceInputs = [
        {
          src = {
            uri = "https://github.com/canihavesomecoffee/udis86/archive/5336633af70f3917760a6d441ff02d93477b0c86.zip",
            sha256sum = "91c06980bd6abce1cd071196e3af655599ca2fcfd62328f06fcd915ed2645671",
          }
        }
      ],

      biDrvs=[
        drvs.pythonFull,
      ]
    }
}
& {
  lib,
  drvs,
  hyprlandProtocols | lib.MesonPackage
    = {
      sourceInputs = [
        {
          src = {
            uri = "https://github.com/hyprwm/hyprland-protocols/archive/c7c3f4cd0faed21fc90ba6bd06fe4f3e0e057ea8.zip",
            sha256sum = "4d38ee1b5a64c9e3ac4eb8820b3a2283a1f29e50c1b5b15cf28142ce980f10b0"
          }
        },
      ]
    }
}
&
(
  let symbols=[
#      "zwp_linux_buffer_params_v1_interface",
#  "zwp_linux_dmabuf_feedback_v1_interface",
#  "wl_callback_interface",
#  "wl_registry_interface",
#  "zwp_linux_dmabuf_v1_interface",
#  "wl_surface_interface",
#  "wl_region_interface",
#  "wl_buffer_interface",
#  "wl_shm_pool_interface",
#  "wl_data_source_interface",
#  "wl_data_device_interface",
#  "wl_shell_surface_interface",
#  "wl_pointer_interface",
#  "wl_keyboard_interface",
#  "wl_touch_interface",
#  "wl_subsurface_interface",
#  "wl_display_interface",
#  "wl_compositor_interface",
#  "wl_shm_interface",
#  "wl_data_offer_interface",
"wl",
"zwp",
"WL",
  ]
  in 
  let 
  rr=(std.array.map (fun v => "sed -i 's@%{v}@%{v}_wayland_private@g' \"${f}\"") symbols)
  in
  let 
  r="\t" ++ (std.string.join "\n\t" rr )
  in
  let 
  c=  m%"
        rm -rf ${SRC}/.gitlab
        for f in $(find ${SRC} -type f);do
          sed -i 's@wl@wl_wayland_private@g' "${f}"
          sed -i 's@zwp@zwp_wayland_private@g' "${f}"
          sed -i 's@WL@WL_WAYLAND_PRIVATE@g' "${f}"
          sed -i 's@wl_wayland_private_interface@wl_interface@g' "${f}"
          sed -i 's@wl_wayland_private_proxy_get_version@wl_proxy_get_version@g' "${f}"
          sed -i 's@wl_wayland_private_proxy@wl_proxy@g' "${f}"
          sed -i 's@wl_wayland_private_fixed_t@wl_fixed_t@g' "${f}"
          sed -i 's@wl_wayland_private_array@wl_array@g' "${f}"


        done
        "%
        in
  {
    drvs,
    wayland,
    waylandProtocols,

    wayland2=wayland & {
      preConfigurePhase=[
      c
      ]
    },

    waylandProtocols2=waylandProtocols & {
      preConfigurePhase=[
      c
      ]
    }

  }

)