{
  lib,
  drvs,
  distro,
  hyprland
    | lib.CmakePackage
    = {
      generator = "Ninja",

      sourceInputs = [
        {
          src = {

            uri = "https://github.com/hyprwm/Hyprland/archive/refs/tags/v0.54.3.tar.gz",
            sha256sum = "4bc4b870e7c7529006c6c3782695e446df915851b941f9866adfe9f8c4ed445b",
          },
        },
      ],
      options = {
        glx | default = false,
      },

      # extraMesonArgs = [
      #   "-Dxwayland=disabled",
      #   "-Dtracy_enable=false",
      #   # "-Dhyprpm=disabled",
      #   "-Dhyprpm=enabled",

      #   # "-Dlegacy_renderer=enabled",
      # ],
      cmakeExtraArgsRecord = {
        "-DNO_XWAYLAND" = true,
        "-DUSE_TRACY" = false,
        "-DNO_HYPRPM" = true,
      },
      preConfigurePhase = [
        # m%"sed -i "s@'opengl'@'egl'@g" ${SRC}/src/meson.build"%,
        m%"sed -i "s|OpenGL::GL ||g" ${SRC}/CMakeLists.txt"%,
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
            "$(pkg-config --static --libs wayland-client)",
            "$(pkg-config --static --libs xcursor)",
            "-ltomlplusplus",
            "-lzip",
            "-ldisplay-info",
            "-lffi",
          ]
          @ (if distro.pam then ["-lcap"] else []),
      },
      llvmProvider = drvs.llvmFull,

      biDrvs =
        [
          drvs.hyprwire,
          drvs.muparser,
          drvs.expat,
          drvs.jsonC,
          drvs.pcre2,
          drvs.waylandWeaksyms2,
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
          drvs.hyprutils,
          drvs.hyprlang,
          drvs.hyprcursor,
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
    },
}
& (import "../hyprland-qtutils/hyprland-qtutils.ncl")
& (import "./aquamarine.ncl")
& (import "./hyprcursor.ncl")
& (import "./hyprland-protocols.ncl")
& (import "./hyprland-with-plugins.ncl")
& (import "./hyprland-x11.ncl")
& (import "./hyprlang.ncl")
& (import "./hyprpaper.ncl")
& (import "./hyprgraphics.ncl")
& (import "./hyprutils.ncl")
& (import "./hyprwayland-scanner.ncl")
