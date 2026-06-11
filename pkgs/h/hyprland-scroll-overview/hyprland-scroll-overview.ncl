{
  lib,
  drvs,
  hyprlandScrollOverview | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      # uri = "https://github.com/yayuuu/hyprland-scroll-overview/archive/25335dee0e8b1430356c3218a86dc7ee50d6df71.tar.gz",
      # sha256sum = "6ececd768aff24ad33893e5c4390642c7da23ba4a4bd917ac2eaed53c3cdfbd6",
      uri = "https://github.com/yayuuu/hyprland-scroll-overview/archive/838224568ae3afc10a4c5969ab0cbd82d1e319f4.tar.gz",
      sha256sum = "d1c764cc2769e817bdf0accecf4507564c19fa9d177bb0c0583b32a0b29fe3be",
    },
    eofPatches = [
      {
        patch = import "fix2.patch" as 'Text
      },
    ],
    buildEnv = {
      EXTRA_CXXFLAGS = ["-Wno-c++11-narrowing", ]
    },
    options = {
      glx = false,
    },
    preConfigurePhase =
      (
        std.array.map
          (fun s => "sed -i 's@#define private public@@g' %{s}"
          )
          [
            "${SRC}/OverviewPassElement.cpp",
            "${SRC}/scrollOverview.cpp",
            "${SRC}/Window.cpp",
          ]
      )
      @ [
        "sed -i 's|SHARED|STATIC|g' ${SRC}/CMakeLists.txt",
      ],

    postInstallPhase =
      let s = "scrolloverview", prefix = "scrolloverview" in
      [
        "objcopy --redefine-sym pluginAPIVersion=%{prefix}_pluginAPIVersion ${DEST}/usr/lib/lib%{s}.a",
        "objcopy --redefine-sym pluginExit=%{prefix}_pluginExit ${DEST}/usr/lib/lib%{s}.a",
        "objcopy --redefine-sym pluginInit=%{prefix}_pluginInit ${DEST}/usr/lib/lib%{s}.a",
      ],
    llvmProvider = drvs.llvmFull,

    biDrvs =
      [
        drvs.lua54Symlink,
        drvs.glslang,
        drvs.lua,
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
        drvs.hyprutils,
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
        # drvs.cmake,
        drvs.fribidi,
      ]
      @ (
        if options.glx then
          [
            drvs.aquamarineGlx,
            drvs.mesaGlx,
            drvs.hyprlandX11,
          ]
        else
          [
            drvs.aquamarine,
            drvs.mesa2,
            drvs.hyprland,
          ]
      ),
  },
  lua54Symlink | lib.Package = {
    installPhase = [
      "install -dm0755 ${DEST}/usr/lib/pkgconfig",
      "cd ${DEST}/usr/lib/pkgconfig",
      "ln -s lua.pc lua5.4.pc",
    ]
  }
}
