{
  lib,
  drvs,
  _pipewire | lib.MesonPackage = {
    singleSource = {
      # uri = "https://gitlab.freedesktop.org/pipewire/pipewire/-/archive/1.3.83/pipewire-1.3.83.tar.gz",
      # sha256sum = "fb9ffee4c8cece297dd44cb83bc070d9fdf0d264a08858b21b401e17683ca790",

      # 1.4.7
      # uri = "https://gitlab.freedesktop.org/pipewire/pipewire.git",
      # sha256sum = "1c542e9a0ca4226c9befb08fe9c19170aca3ce95",

      uri = "https://gitlab.freedesktop.org/pipewire/pipewire/-/archive/1.4.7/pipewire-1.4.7.tar.gz",
      sha256sum = "9d54f025e1e7ae73b980a6c8be2e8e6387e24d554d58478d6495734ce1ee5a93"
      # uri = "/run/data/user/Projects/pipewire-static-playground.tar.gz",
      # sha256sum = "07b0d9f39a4ec30f87b0a33d8a42b177e3ba9e5ccc0ed29cd788a274658fe14c",

      # uri = "/run/data/user/Projects/pipewire-static-playground.tar.gz",
      # sha256sum = "778c297988beefc78f6b2d0c6b43dcd69c8ab5500cb7e818603d06abb2bc588a"
    },

    sourceInputs = [
      { src = singleSource },
      {
        src = {
          uri = "https://gitlab.freedesktop.org/pipewire/wireplumber/-/archive/0.5.10/wireplumber-0.5.10.tar.gz",
          sha256sum = "c2e021d8e6ef1db644facd4a97f5a644b67481c641da9100e851aab6752ba446"
        },
        dest = "subprojects/wireplumber"
      }
    ],

    options = {
      patchfile | default = "pipewire.patch"
    },

    patches = [
      {
        file = "pipewire.patch",
        sha256sum = "ff8f28a8a8c4eb57cad4466e3d83fe57268c0f34c5ec0b287990a807fac68a51"
      },
      {
        file = "wireplumber.patch",
        sha256sum = "33dc3740f9372b8c1981e659a11387ff7b1d129fafd9e113425a9fa42a422286"
      }
    ],
    patchPhase = [
      "(cd ${SRC} && patch -p1 < /tmp/workdir/patches/%{options.patchfile})",
      "(cd ${SRC}/subprojects/wireplumber && patch -p1 < /tmp/workdir/patches/wireplumber.patch)",
    ],
    # https://github.com/kiss-community/community/blob/0715e574d128e1df6137f3959bacc9c66fffcb18/community/pipewire/build

    preConfigurePhase = [
      # m%"
      # for f in $(find "${SRC}" -name meson.build); do
      #   sed -i 's@shared_library@library@g' "${f}"
      # done
      # "%,

      # "sed -i 's@, plugin_dependencies@@g' ${SRC}/src/modules/meson.build",
    ],
    # buildPhase = [
    #         "meson compile -j1"
    # ],
    llvmProvider = drvs.llvmFull,
  },
}
& {
  lib,
  drvs,
  _pipewire,
  pipewire =
    _pipewire
    & {
      options.patchfile = "pipewire2.patch",
      patches | priority 1 = [
        {
          sha256sum = "a3f641fc0ca0c70ea5d3403ecfd9f2ff6e6ec4115c22c8389854651229520acd",
          file = "pipewire2.patch"
        },
        {
          file = "wireplumber.patch",
          sha256sum = "0229cc4fde33b0d6b3e74395b441629a8f5a5aaadc65fa1e8d1584cda01d93d8"
        }
      ],

      options = {
        elogind | default = true
      },

      extraMesonArgs | priority 1 = [
        "-Dsession-managers=wireplumber",
        # "-Dsession-managers=[]",
        "-Dvideotestsrc=disabled",
        "-Dvideoconvert=enabled",
        # "-Dv4l2=disabled",
        "-Dsupport=enabled",
        "-Dspa-plugins=enabled",
        "-Dtests=disabled",
        # "-Davb=disabled",
        # "-Draop=disabled",
        "-Dsndfile=enabled",
        "-Dudev=enabled",
        "-Dwireplumber:system-lua=true",
        "-Dwireplumber:tests=false",
        "-Dbluez5=enabled",
        "-Dbluez5-backend-hsp-native=enabled",
        "-Dbluez5-backend-hfp-native=enabled",
        "-Dbluez5-backend-ofono=enabled",
        "-Dbluez5-backend-hsphfpd=enabled",
        "-Dbluez5-codec-aptx=disabled",
        # "-Dbluez5-codec-ldac=enabled",
        "-Dbluez5-codec-aac=enabled",

        # TODO: lc3plus and lc3
        "-Dlibcamera=disabled",
        "-Dgsettings=disabled",
        "-Dwireplumber:elogind=%{ if options.elogind then "enabled" else "disabled" }",
        "-Dlogind=%{ if options.elogind then "enabled" else "disabled" }",
        "-Dlogind-provider=libelogind",
      ],
      biDrvs | priority 1 = [
        drvs.dbus,
        drvs.alsaLibs,
        drvs.fontconfig,
        drvs.freetype,
        drvs.zlibNg,
        drvs.gperf,
        # drvs.pixman,
        # drvs.wayland,
        # drvs.waylandProtocols,
        drvs.libffi,
        drvs.libxkbcommon,
        drvs.expat,
        drvs.linuxHeaders,
        drvs.ncurses,
        drvs.readline,
        drvs.pcre2,
        drvs.glib,
        drvs.hwdata,
        drvs.eudev,
        drvs.kmod,
        drvs.xz,
        drvs.openssl,
        drvs.zstd,
        drvs.utilLinux,
        drvs.libevdev,
        (drvs.findutils & { priority = 1 }),
        drvs.libsndfile,
        drvs.libopus,
        drvs.lua,
        drvs.bluez,
        drvs.sbc,
        drvs.libusb,
        drvs.ffmpeg,
        drvs.jansson,
        drvs.fdkAac,
        drvs.ldacbt,
        # 
        drvs.libyaml,

        ## if gsettings
        # drvs.gobjectDynamic,
        # drvs.cairoGobject,
        # drvs.fribidi,
        # drvs.gdkPixbufFull,
        # drvs.libjpegTurbo,
        # drvs.libepoxy,
        # drvs.atSpi2Core,
        # drvs.mesa2,
        # drvs.libelf,
        # drvs.libdrm,
        # drvs.libpciaccess,
        # drvs.llvmConfigStatic,
        # drvs.spirvTools,
        # drvs.spirvLlvmTranslator,
        # drvs.gtk3,
        # drvs.muslShared,
        # drvs.pango,
        # drvs.cairo,
        # drvs.libpng,
        # drvs.harfbuzz,
      ],
      allowDubplicateBuldInputs = true,
      propagatedBuildInputs = (
        if (options.elogind) then
          [
            drvs.elogindWithPolkit,
            drvs.libcap,
          ]
        else
          []
      ),
    }
}
