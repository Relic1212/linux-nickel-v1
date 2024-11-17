{
  lib,
  drvs,
  wayfire | lib.MesonPackage
    = {
      sourceInputs = [
        {
          src = {
            uri = "https://github.com/WayfireWM/wayfire/releases/download/v0.9.0/wayfire-0.9.0.tar.xz",
            sha256sum = "dd0c9c08b8a72a2d8c3317c8be6c42b17a493c25abab1d02ac09c24eaa95229d",
          }
        },
        #  {
        #   src = {
        #     uri = "https://gitlab.freedesktop.org/wlroots/wlroots/-/archive/e8e76dc2954e1bc4cfe6bbf104996a932b9eb807/wlroots-e8e76dc2954e1bc4cfe6bbf104996a932b9eb807.tar.gz",
        #     sha256sum = "f89797791f20e14df8319acdfa68e57002fb85efc5977bf22ae9b45fe7583e5d"
        #   },
        #   dest = "subproject/wlroots"
        # },
      ],
      llvmProvider = drvs.llvmFull,
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
        #drvs.libudevZero,
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
        drvs.nlohmannJson,
        drvs.glm,
        drvs.libxml2,
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
      }
    }
}
& {
  lib,
  drvs,
  nlohmannJson | lib.MesonPackage
    = {
      singleSource = {
        uri = "https://github.com/nlohmann/json/archive/refs/tags/v3.11.3.tar.gz",
        sha256sum = "0d8ef5af7f9794e3263480193c491549b2ba6cc74bb018906202ada498a79406",
      }
    }
}
& {
  lib,
  drvs,
  glm | lib.CmakePackage
    = {
      generator = "Ninja",
      singleSource = {
        uri = "https://github.com/g-truc/glm/archive/33b4a621a697a305bc3a7610d290677b96beb181.zip",
        sha256sum = "79263e9526124b5b57c943f53e5e55b3e635aa9037f2a6326cd3193bba9816ec",
      }
    }
}
