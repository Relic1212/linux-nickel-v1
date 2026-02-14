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
