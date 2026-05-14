{
  lib,
  drvs,
  hyprlandPlugins | lib.MesonPackage = {
    singleSource = {
      # uri = "https://github.com/hyprwm/hyprland-plugins/archive/refs/tags/v0.53.0.tar.gz",
      # sha256sum = "23c90d35fe81f5f15192704769cda2cf4f349a294d9aa347627dc223f30c6358",
      # uri = "https://github.com/hyprwm/hyprland-plugins/archive/b85a56b9531013c79f2f3846fd6ee2ff014b8960.tar.gz",
      # sha256sum = "e683637b728ebca18251be029962b787bdd69989e882a5a7964dfb26e325a94b",
      uri = "https://github.com/hyprwm/hyprland-plugins/archive/3aa21f2e0ca72412f1b434c3126f8f1fec3c716c.tar.gz",
      sha256sum = "8c93cd4be1be9c13227c404c0e7da0c4b16f6e482e63d61f822c8f5e6da2cc9d",
    },
    # patches = [
    #   {
    #     file = "hyprland-plugins.patch",
    #     sha256sum = "3cf0ffc0fb8a3a826fd354f24001c2c2efbac44bd7cb4b62d92be79650c0cd92"
    #   },
    # ],

    options = {
      glx = false,
      plugins = [
        "borders-plus-plus",
        # "csgo-vulkan-fix",
        "hyprbars",
        # "hyprexpo",
        "hyprfocus",
        # "hyprscrolling", # https://github.com/hyprwm/hyprland-plugins/issues/637
        # "hyprtrails",
        # "hyprwinwrap",
        # "xtra-dispatchers",
      ],
      # libs = [
      #   "libborders-plus-plus",
      #   "libhyprbars",
      #   "libhyprexpo",
      #   "libhyprfocus",
      #   "libhyprscrolling",
      #   "libxtra-dispatchers",
      # ]
    },

    preConfigurePhase =
      [
        #   m%"
        #   echo "
        #   project('hyprland-plugins', 'cpp',
        #   version: '0.1',
        #   default_options: ['buildtype=release'],
        #   )
        #   subdir('hyprexpo')
        #   " > ${SRC}/meson.build
        #   "%,
        "for f in $(find ${SRC} -name meson.build); do sed -i 's@shared_module@library@g' ${f};done",
        # m%"for f in $(find ${SRC} -name meson.build); do sed -i 's@c++23@c++20@g' ${f};done"%,
      ]
      @ (
        std.array.map
          (fun s => "sed -i 's|#define private public||g' ${SRC}/%{s}"
          )
          [
            # "xtra-dispatchers/main.cpp",
            # "hyprwinwrap/main.cpp",
            # "borders-plus-plus/main.cpp",
            "hyprfocus/main.cpp",
            # "hyprexpo/overview.cpp",
            # "hyprscrolling/main.cpp",
            "hyprbars/barDeco.hpp",
          ]
      )
      @ [
        # "export SRC=\"/tmp/workdir/src/hyprexpo\"",
      ],
    mesonArgs,
    configurePhase =
      std.array.flatten (
        std.array.map
          (fun p =>
            [
              "mkdir ${BUILDDIR}/%{p}",
              "(cd ${SRC}/%{p} && meson setup %{std.string.join lib.constants.buildFlagSep mesonArgs} ../../build/%{p})"
            ]
          )
          options.plugins
      ),

    buildPhase =
      std.array.flatten (
        std.array.map
          (fun p =>
            [
              "(cd ${SRC}/%{p} && meson compile -C ../../build/%{p})"
            ]
          )
          options.plugins
      ),

    installPhase =
      std.array.flatten (
        std.array.map
          (fun p =>
            [
              "(cd %{p} && meson install --destdir ${DEST})"
            ]
          )
          options.plugins
      ),
    postInstallPhase =
      std.array.flatten (
        std.array.map
          (fun s =>
            let prefix = std.string.replace "-" "_" s in
            [
              "objcopy --redefine-sym pluginAPIVersion=%{prefix}_pluginAPIVersion ${DEST}/usr/lib/lib%{s}.a",
              "objcopy --redefine-sym pluginExit=%{prefix}_pluginExit ${DEST}/usr/lib/lib%{s}.a",
              "objcopy --redefine-sym pluginInit=%{prefix}_pluginInit ${DEST}/usr/lib/lib%{s}.a",
            ]
          )
          options.plugins
      ),

    llvmProvider = drvs.llvmFull,

    pDrvs =
      if options.glx then
        [
          drvs.hyprlandX11
        ]
      else
        [
          drvs.hyprland,
        ]
  }
}
