{
  lib,
  drvs,
  pkgs,
  hyprland
    | lib.MesonPackage
    = {
      options ={
        glx | default =false,
      },
      sourceInputs = [
        {
          src ={
            uri = "https://github.com/hyprwm/Hyprland/releases/download/v0.47.2/source-v0.47.2.tar.gz",
            sha256sum = "e7f4447c9e24149cf2fd57057410bc90cb3c4ecaa35b6ec2a60a9d44d2fb2feb"
          },
          # src = {
          #   uri = "https://github.com/hyprwm/Hyprland/archive/refs/tags/v0.45.2.tar.gz",
          #   sha256sum = "ad54556ed694e00dc7b433a3cc916c8f5b9633f0b290d2d6f48f2bcdf2886d28",
          # },
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
      patches = [
        #{
        #  file = "no-duplicate-protocols.patch",
        #  sha256sum = "814246ec7f6933ed47bdcf223e6607ca51b36a9fd738487a7a4b969f13086133"
        #}
      ],
      llvmProvider = pkgs.llvmFull,

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
        drvs.hyprwaylandScanner,
        drvs.hyprUtils,
        drvs.hyprlang,
        drvs.hyprcursor,
        #  drvs.cmake,
        drvs.tomlplusplus,
        drvs.utilLinux,
        ###############################################################
        drvs.hyprlandProtocols,
        drvs.udis86,
        drvs.hyprgraphics,
        drvs.re2,
        drvs.abseilCpp,
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
      ] @ ( if options.glx then [
        drvs.aquamarineGlx,
        drvs.mesaGlx,
      ] else [
        drvs.aquamarine,
                drvs.mesa2,

      ]),

      extraMesonArgs = [
        "-Dxwayland=disabled",
        "-Dtracy_enable=false",
        "-Dhyprpm=disabled",
        # "-Dlegacy_renderer=enabled",
      ],

      preConfigurePhase=[
        m%"
        sed -i "s@'opengl'@'egl'@g" ${SRC}/src/meson.build
        "%,
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
      ],
      #generator = "Ninja",
      #cmakeExtraArgsRecord = {
      #  "-DNO_SYSTEMD" = true,
      #  "-DNO_XWAYLAND" = true,
      #  "-DLEGACY_RENDERER" = true,
      #  "-DUSE_TRACY" = false,
      #  "-DNO_HYPRPM" = true,
      #},
      #preConfigurePhase = [
      #  m%"
      #    sed -i \
      #      's@OpenGL::GL@OpenGL::GLES2@g' \
      #      ${SRC}/CMakeLists.txt
      #    "%,
      #],
      buildEnv = {
        EXTRA_LDFLAGS = [ "-lseat", "-ltomlplusplus", "-lzip", "-ldisplay-info" ],
        # EXTRA_LDFLAGS = [ "-l:libwayland-client.a" ],
       #EXTRA_CXXFLAGS = [ "-I/usr/include/aquamarine/protocols"],
       #EXTRA_CPPFLAGS = [ "-I/usr/include/aquamarine/protocols"],
       #EXTRA_CPPFLAGS=["-DXDG_POSITIONER_INTERFACE","-DXDG_SURFACE_INTERFACE","-DHYPRWAYLAND_SCANNER_NO_INTERFACES"],
       #EXTRA_CXXFLAGS=EXTRA_CPPFLAGS,

      }
    },

  hyprwaylandScanner | lib.CmakePackage
    = {
      generator = "Ninja",

      singleSource = {
        # uri = "https://github.com/hyprwm/hyprwayland-scanner/archive/500c81a9e1a76760371049a8d99e008ea77aa59e.zip",
        # sha256sum = "8408af601bfc784500ba033b77a27e3d863a54d5e911ec39f3d84f1e67565937"

        uri = "https://github.com/hyprwm/hyprwayland-scanner/archive/refs/tags/v0.4.4.tar.gz",
        sha256sum = "ac73f626019f8d819ff79a5fca06ce4768ce8a3bded6f48c404445f3afaa25ac"
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
        # uri = "https://github.com/hyprwm/hyprutils/archive/3ce0cde8709cdacbfba471f8e828433b58a561e9.zip",
        # sha256sum = "8278af70177985de8a07fa08387b4bafc969cec90a43c565cc542d98252f6d8d",
        uri = "https://github.com/hyprwm/hyprutils/archive/refs/tags/v0.5.1.tar.gz",
        sha256sum = "0ad1d873012568661667cb5b599ddd59b3bea945a0d03c0f2ca3c7f4dff55798"
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
        #uri = "https://github.com/hyprwm/hyprcursor/archive/0264e698149fcb857a66a53018157b41f8d97bb0.zip",
        #sha256sum = "d533d479f339d559a285dfd8a5d47a5d4491dc834ef6aceaad315f2949748404",

        uri = "https://github.com/hyprwm/hyprcursor/archive/refs/tags/v0.1.11.tar.gz",
        sha256sum = "17e4576b884e6bdb463b445cffff099ad16647b826a87a67b78d38b8cad4c39e"
      },
      patches = [
       # {
       #   file = "hyprcyrsor-no-svg.patch",
       #   sha256sum = "78890380a3531a76b629e2742fcb100ebc74da5299f68f5bfb48d88d6cd2b42b",
       # }
       {
        file = "hyprcyrsor-no-svg-v2.patch",

        sha256sum = "f4621359f73f2193a0e8162d40c5676608d77406139ca8cedd9f0b7e843fa669"
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

        # drvs.librsvg,
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
        #uri = "https://github.com/hyprwm/hyprlang/archive/f054f2e44d6a0b74607a6bc0f52dba337a3db38e.zip",
        #sha256sum = "70e22059dfffabd19568027a56799ebd0e284699ec5801b26cf89165a5cebc52",

        uri = "https://github.com/hyprwm/hyprlang/archive/refs/tags/v0.6.0.tar.gz",
        sha256sum = "b1a163606402041d92507936fb6dcbc40dd0035b8e8abbf44b0ab59be627b52c"
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

      biDrvs = [
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
            # uri = "https://github.com/hyprwm/hyprland-protocols/archive/c7c3f4cd0faed21fc90ba6bd06fe4f3e0e057ea8.zip",
            # sha256sum = "4d38ee1b5a64c9e3ac4eb8820b3a2283a1f29e50c1b5b15cf28142ce980f10b0",

            uri = "https://github.com/hyprwm/hyprland-protocols/archive/refs/tags/v0.6.2.tar.gz",
            sha256sum ="bba082af141599d4342e7b8505401a6e3a32be819d9eb23ce6c90f7407e62c1f"
          }
        },
      ]
    }
}
& (
  let symbols = [
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
  let rr = (std.array.map (fun v => "sed -i 's@%{v}@%{v}_wayland_private@g' \"${f}\"") symbols)
  in
  let r = "\t" ++ (std.string.join "\n\t" rr)
  in
  let c = m%"
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

    wayland2 =
      wayland
      & {
        preConfigurePhase | priority 1
          = [
            c
          ]
      },

    waylandProtocols2 =
      waylandProtocols
      & {
        preConfigurePhase = [
          c
        ]
      }
  }
)

&

{
  lib,
  drvs,
  hyprgraphics | lib.CmakePackage = {
      generator = "Ninja",

    singleSource = {
      uri = "https://github.com/hyprwm/hyprgraphics/archive/refs/tags/v0.1.2.tar.gz",
      sha256sum = "9409b29e80200e06237c124a9eaf5a367ab407e56f43a575bdc84ed2d551a154"
    },
    biDrvs = [
        drvs.pixman,
        drvs.expat,
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

        drvs.libjpegTurboStatic,

        drvs.libspng,

        drvs.file,
        drvs.libwebp,
    ],
    preConfigurePhase = [
      "sed -i 's@hyprgraphics SHARED@hyprgraphics STATIC@g' ${SRC}/CMakeLists.txt"
    ]
  }
}


&

{
  lib,
  drvs,
  hyprpaper|lib.CmakePackage = {
    generator= "Ninja",
    singleSource = {
      uri = "https://github.com/hyprwm/hyprpaper/archive/refs/tags/v0.7.4.tar.gz",
      sha256sum = "a2375dae58d29293b942a60cd465771b2c3c85cfcac628ec4897f11e7008666f",
    },
     biDrvs = [
        drvs.pixman,
        drvs.expat,
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

        drvs.libjpegTurboStatic,

        drvs.libspng,

        drvs.file,
        drvs.libwebp,
        drvs.wayland,
        drvs.waylandProtocols,
        drvs.hyprgraphics,


          drvs.pcre2,
    ],
    preConfigurePhase = [
      "sed -i 's@#include <GLES3/gl32.h>@@g' ${SRC}/src/includes.hpp",
      "sed -i 's@#include <GLES3/gl3ext.h>@@g' ${SRC}/src/includes.hpp",

      "sed -i 's@OpenGL@@g' ${SRC}/CMakeLists.txt",
      "sed -i 's@GLESv2@@g' ${SRC}/CMakeLists.txt",

    ],
    buildEnv={
      EXTRA_LDFLAGS=[
        "-ljpeg",
        "-lspng",
        "-lwebp",
      ]
    }
  }
}

& (import "../hyprland-qtutils/hyprland-qtutils.ncl")

& (import "./hyprland-x11.ncl")

& (import "./aquamarine.ncl")

