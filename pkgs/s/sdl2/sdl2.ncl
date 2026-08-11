{
  lib,
  drvs,
  sdl2 | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/libsdl-org/SDL/archive/refs/tags/release-2.32.10.tar.gz",
      sha256sum = "03f9d7c191a837525c9cda6406af2f2e48be02b5e7eb03d949cc9f1e9ca41c8b"
    },

    cmakeExtraArgsRecord = {
      "-DSDL_X11" = false,
      "-DSDL_DEPS_SHARED" = false,
      "-DSDL_VULKAN" = false,
      "-DSDL_RPATH" = false,
      "-DSDL_KMSDRM_SHARED" = false,
      "-DSDL_WAYLAND_SHARED" = false,
    },

    # extraConfigureFlags = [
    #   "--disable-rpath",
    #   "--disable-loadso",
    #   "--disable-alsa-shared",
    #   "--disable-jack-shared",
    #   "--disable-esd-shared",
    #   "--disable-pipewire-shared",
    #   "--disable-pulseaudio-shared",
    #   "--disable-arts-shared",
    #   "--disable-nas-shared",
    #   "--disable-sndio-shared",
    #   "--disable-fusionsound-shared",
    #   "--disable-libsamplerate-shared",
    #   "--disable-wayland-shared",
    #   "--disable-libdecor-shared",
    #   "--disable-x11-shared",
    #   "--disable-directfb-shared",
    #   "--disable-kmsdrm-shared",
    #   "--enable-video-wayland",
    #   "--enable-video-opengles2",
    #   "--enable-video-opengl",
    #   "--enable-video-vulkan",
    #   "--enable-render",
    #   "--enable-kmsdrm",
    # ],

    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.lcms,
      drvs.scdoc,
      # drvs.pkgconfMeson,
    ],
    propagatedBuildInputs = [
      drvs.mesa2,
      drvs.dbus,
      drvs.eudev,
      drvs.libxkbcommon,
    ]
  },
  sdl2Debug =
    sdl2
    & {
      debug = true,
      postInstallPhase =
        [
          "cd ${DEST}/usr/lib",
        ]
        @ (
          std.array.map
            (fun l => "ln -s %{l} %{std.string.replace "d.a" ".a" l}")
            [
              "libSDL2d.a",
              "libSDL2maind.a",
            ]
        )
    }
}
