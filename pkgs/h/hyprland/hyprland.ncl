{
  lib,
  drvs,
  distro,
  hyprland
    | lib.MesonPackage
    = {
      options = {
        glx | default = false,
      },
      sourceInputs = [
        {
          src = {

            uri = "https://github.com/hyprwm/Hyprland/archive/refs/tags/v0.52.2.tar.gz",
            sha256sum = "5588ba57539f47d52091135628bdab6533a2b0e9c6d46f507af7391d44015f9f",
          },
        },
      ],
      llvmProvider = drvs.llvmFull,

      biDrvs =
        [
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
          drvs.libdisplayinfo,
          drvs.libinput,
          drvs.libffi,
          drvs.libevdev,
          drvs.mtdev,
          drvs.pango,
          drvs.fribidi,
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
          drvs.glaze,
          drvs.cmake,
          drvs.libjpegTurboStatic,
          drvs.libspng,
          drvs.libwebp,
          drvs.file, # libmagic
        ]
        @ (
          if options.glx then
            [
              drvs.aquamarineGlx,
              drvs.mesaGlx,
            ]
          else
            [
              drvs.aquamarine,
              drvs.mesa2,
            ]
        ),

      propagatedBuildInputs = [
        drvs.seatd,
      ],

      extraMesonArgs = [
        "-Dxwayland=disabled",
        "-Dtracy_enable=false",
        # "-Dhyprpm=disabled",
        "-Dhyprpm=enabled",

        # "-Dlegacy_renderer=enabled",
      ],

      preConfigurePhase = [
        m%"
        sed -i "s@'opengl'@'egl'@g" ${SRC}/src/meson.build
        "%,
      ],

      postInstallPhase = [
        m%"sed -i 's|  private:||g' ${DEST}/usr/include/hyprland/src/render/Renderer.hpp"%,
        m%"sed -i 's|  private:||g' ${DEST}/usr/include/hyprland/src/render/OpenGL.hpp"%,
        m%"sed -i 's|  private:||g' ${DEST}/usr/include/hyprland/src/managers/KeybindManager.hpp"%,
        m%"sed -i 's|  private:||g' ${DEST}/usr/include/hyprland/src/config/ConfigManager.hpp"%,
      ],

      buildEnv = {
        EXTRA_LDFLAGS =
          [
            "$(pkg-config --libs --static libseat)",
            "$(pkg-config --libs --static libjpeg)",
            "$(pkg-config --libs --static libwebp)",
            "$(pkg-config --libs --static libmagic)",
            "-ltomlplusplus",
            "-lzip",
            "-ldisplay-info"
          ]
          @ (if distro.pam then ["-lcap"] else []),
      }
    },

  # hyprlandLibs | lib.MesonPackage =
  #   hyprland
  #   & {
  #     postInstallPhase | priority 1 =
  #       hyprland.postInstallPhase
  #       @ [
  #         m%"sed -i 's|  private:||g' ${DEST}/usr/include/hyprland/src/render/Renderer.hpp"%,
  #         m%"sed -i 's|  private:||g' ${DEST}/usr/include/hyprland/src/render/OpenGL.hpp"%,
  #         m%"sed -i 's|  private:||g' ${DEST}/usr/include/hyprland/src/managers/KeybindManager.hpp"%,
  #         m%"sed -i 's|  private:||g' ${DEST}/usr/include/hyprland/src/config/ConfigManager.hpp"%,
  #       ]
  #   },

  hyprwaylandScanner | lib.CmakePackage = {
    generator = "Ninja",

    singleSource = {

      uri = "https://github.com/hyprwm/hyprwayland-scanner/archive/refs/tags/v0.4.5.tar.gz",
      sha256sum = "2125d279eea106e3e6c8dc9fa15181c75d67467b5352d24e2a07903b10abad62"
    },
    biDrvs = [
      drvs.pugixml,
    ]
  },

  pugixml | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/zeux/pugixml/releases/download/v1.14/pugixml-1.14.tar.gz",
      sha256sum = "2f10e276870c64b1db6809050a75e11a897a8d7456c4be5c6b2e35a11168a015"
    }
  },

  hyprUtils | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {

      uri = "https://github.com/hyprwm/hyprutils/archive/refs/tags/v0.11.0.tar.gz",
      sha256sum = "1f097eb9915081f1b929973701643bcd8581b469c242eae5446275b120a3b229",
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
  hyprcursor | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {

      uri = "https://github.com/hyprwm/hyprcursor/archive/refs/tags/v0.1.13.tar.gz",
      sha256sum = "82af8b2ce27242ffdd6baebaa71b3f6c8665dc25c52bfcfccc16912622896af8",
    },
    patches = [
      {
        sha256sum = "9a39fa9ec0b150627f34c6f64a5dda260f40918b2ae278c70a6992bb8b87a035",
        file = "hyprcyrsor-no-svg-v3.patch",
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
  libzip | lib.CmakePackage = {
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
  hyprlang | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {

      uri = "https://github.com/hyprwm/hyprlang/archive/refs/tags/v0.6.7.tar.gz",
      sha256sum = "e8d54af895ec04fe99553c68d1255dceddb43723ada4a134acdd46bfe1dbf924",
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
  tomlplusplus | lib.MesonPackage = {
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
  udis86 | lib.AutomakePackage = {
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
  hyprlandProtocols | lib.MesonPackage = {
    sourceInputs = [
      {
        src = {

          uri = "https://github.com/hyprwm/hyprland-protocols/archive/refs/tags/v0.7.0.tar.gz",
          sha256sum = "ee419006d7cd20927b9b7c8b5fc430571c151b0385d600508de1a7957294498c",
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

    #   wayland2 =
    #     wayland
    #     & {
    #       preConfigurePhase | priority 1 = [
    #         c
    #       ]
    #     },

    #   waylandProtocols2 =
    #     waylandProtocols
    #     & {
    #       preConfigurePhase = [
    #         c
    #       ]
    #     }
  }
)
& {
  lib,
  drvs,
  hyprgraphics | lib.CmakePackage = {
    generator = "Ninja",

    singleSource = {
      uri = "https://github.com/hyprwm/hyprgraphics/archive/refs/tags/v0.4.0.tar.gz",
      sha256sum = "1ee818778eafd36919a463481fe0838ea3440d53fbd2305a5bf1449c61148678",
    },

    patches = [
      {
        sha256sum = "84097f3c9db4e5dc5482624c4e0ced9a1d6175b4a1c8408b1515b0fbb0f1e9ae",
        file = "hyprgraphics-no-svg.patch"
      }
    ],
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
      drvs.fribidi,
      drvs.pcre2,
    ],
    preConfigurePhase = [
      "sed -i 's@hyprgraphics SHARED@hyprgraphics STATIC@g' ${SRC}/CMakeLists.txt"
    ]
  }
}
& {
  lib,
  drvs,
  hyprpaper | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/hyprwm/hyprpaper/archive/refs/tags/v0.7.6.tar.gz",
      sha256sum = "a19f59e21abb8b1e3f4103ffeeac7c4658c1c09433047979836b2210a4edc40e",
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
      drvs.fribidi,
    ],
    preConfigurePhase = [
      "sed -i 's@#include <GLES3/gl32.h>@@g' ${SRC}/src/includes.hpp",
      "sed -i 's@#include <GLES3/gl3ext.h>@@g' ${SRC}/src/includes.hpp",
      "sed -i 's@OpenGL@@g' ${SRC}/CMakeLists.txt",
      "sed -i 's@GLESv2@@g' ${SRC}/CMakeLists.txt",
    ],
    buildEnv = {
      EXTRA_LDFLAGS = [
        "-ljpeg",
        "-lspng",
        "-lwebp",
      ]
    }
  }
}
& (import "../hyprland-qtutils/hyprland-qtutils.ncl")
& (import "./hyprland-x11.ncl")
& (import "./hyprland-with-plugins.ncl")
& (import "./aquamarine.ncl")
