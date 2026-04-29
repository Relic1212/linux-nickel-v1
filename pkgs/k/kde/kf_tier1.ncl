let
  tiers = import "_kf_tiers.ncl",
  srcData = import "_kf_misc.ncl"
in

let d = {
  _kCommon = {
    tier1names = std.record.filter (fun k v => v == 1) tiers |> std.record.fields,
    tier2names = std.record.filter (fun k v => v == 2) tiers |> std.record.fields,
    tier3names = std.record.filter (fun k v => v == 3) tiers |> std.record.fields,

    tier1sources = (std.array.map (fun p => srcData."%{p}" & { dest = p }) tier1names),
    tier2sources = (std.array.map (fun p => srcData."%{p}" & { dest = p }) tier2names),
    tier3sources = (std.array.map (fun p => srcData."%{p}" & { dest = p }) tier3names),
  },
  lib,
  drvs,
  _kfBase | lib.QtPackage = {

    generator = "Ninja",

    llvmProvider = drvs.llvmFull,
    # 

    options = {
      version = "6.25",

      waylandSyms = false,
      xkbcommonX11 | default = false,
    },

    biDrvs | priority -2 =
      [
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
        # drvs.harfbuzz,
        drvs.glib,
        drvs.hwdata,
        drvs.linuxHeaders,
        drvs.libjpegTurboStatic,
        drvs.libspng,
        drvs.file,
        drvs.libwebp,
        drvs.dbusForQt,
        drvs.qtdeclarative,
        drvs.qtbase,
        drvs.qtshadertools,
        drvs.qtwayland,
        drvs.qt5compat,
        drvs.qtTools,
        drvs.qtsensors,
        drvs.qtsvg,
        drvs.mesa2,
        # drvs.pkgconf,
        drvs.libelf,
        drvs.libdrm,
        drvs.pythonMako,
        drvs.pythonPackaging,
        drvs.pythonMarkupsafe,
        drvs.libpciaccess,
        drvs.bison,
        drvs.flex,
        drvs.harfbuzzFull,
      ]
      @ (
        if options.waylandSyms then
          [
            drvs.waylandWeaksyms
          ]
        else
          [
            drvs.wayland
          ]
      )
      @ [
        drvs.waylandProtocols,
        drvs.m4,
        drvs.pyyaml,
        drvs.llvmConfigStatic,
        drvs.spirvTools,
        drvs.spirvLlvmTranslator,
        ###
        drvs.jsonC,
        drvs.pcre2,
      ]
      @ (
        if options.xkbcommonX11 then
          [
            drvs.libxkbcommonX11,
          ]
        else
          [
            drvs.libxkbcommon,
          ]
      )
      @ [
        drvs.openssl,
        drvs.kmod,
        drvs.zstd,
        drvs.xz,
        drvs.bzip2,
        drvs.eudev,
        drvs.libinput,
        drvs.ecm,
        drvs.plasmaWaylandProtocols,
        drvs.gperf,
        drvs.isoCodes,
        drvs.pythonFull,
        drvs.gettext,
        drvs.libqrencode,
        drvs.libdmtx,
        drvs.zxing,
        drvs.utilLinux,
        drvs.hunspell,
        drvs.perl,
      ],
    buildEnv =
      let common_flags = ["-DQT_STATICPLUGIN"] in
      {
        EXTRA_CFLAGS = common_flags,
        EXTRA_CPPFLAGS = common_flags,
        EXTRA_CXXFLAGS = common_flags,

        BASE_LDFLAGS | priority 1 = [],
        EXTRA_LDFLAGS = [
          "$(pkg-config --libs --static gbm glesv2 egl dri wayland-client glib-2.0 gmodule-2.0 expat)",
        ]
      },
    cmakeExtraArgsRecord = {

      "-DBUILD_TESTING" = false,
      "-DWITH_X11" = false,
      "-DBUILD_DESIGNERPLUGIN" = false,

      "-DKWINDOWSYSTEM_X11" = false,
      "-DKWINDOWSYSTEM_WAYLAND" = true,
      "-DKSYNTAXHIGHLIGHTING_USE_GUI" = false,
      "-DWITH_MULTIMEDIA" = false,
    },
  },

  kftier1 | lib.QtPackage =
    _kfBase
    & {
      sourceInputs = _kCommon.tier1sources,
      separateBuildDir = false,
      preConfigurePhase =
        let cmake = std.string.join "\n" (std.array.map (fun s => "add_subdirectory(%{s})") _kCommon.tier1names) in
        let genCmake = m%"
cat >${SRC}/CMakeLists.txt <<EOF
cmake_minimum_required(VERSION 4.1)
%{cmake}
EOF
"%
        in
        [
          # genCmake,
          # kidlteime
          "sed -i 's@add_subdirectory(examples)@#add_subdirectory(examples)@g' ${SRC}/kidletime/CMakeLists.txt",
          m%"
        for f in $(find ${SRC}/kidletime -name CMakeLists.txt); do
          sed -i 's@ MODULE@@g' ${f}
        done
        "%,
          # -kidletime
          # kwindowsystem
          # fixes
          # ld.lld: error: duplicate symbol: wl_display_interface
          # >>> defined at wayland-protocol.c
          # >>>            meson-generated_.._wayland-protocol.c.o:(wl_display_interface) in archive /usr/lib/libwayland-client.a
          # >>> defined at wayland-wayland-protocol.c
          # >>>            src/platforms/wayland/CMakeFiles/KF6WindowSystemKWaylandPlugin.dir/wayland-wayland-protocol.c.o:(.data.rel.ro.wl_display_interface+0x0)
          "sed -i 's@MODULE@STATIC@g' ${SRC}/kwindowsystem/src/platforms/wayland/CMakeLists.txt",
          # -kwindowsystem
        ],
      cmakeArgs,
      configurePhase = [
        "for d in $(ls); do ",
        "echo \"building $d\"",
        "cd $d",
        "cmake -B build -S . %{std.string.join " " cmakeArgs }",
        "cmake --build build",
        "DESTDIR=${DEST} cmake --install build",
        "cd ..",
        "done",
      ],
      buildPhase = [],
      installPhase = [
        # "cat F",
      ],
    },

  kftier2 | lib.QtPackage =
    _kfBase
    & {
      sourceInputs = _kCommon.tier2sources,
      separateBuildDir = false,
      preConfigurePhase = [

        # kauth
        "sed -i 's@ MODULE @ @g' ${SRC}/kauth/src/CMakeLists.txt",
        # -kauth

        # kpackage
        m%"sed -i 's@NOT BUILD_SHARED_LIBS@FALSE@g' ${SRC}/kpackage/src/kpackage/CMakeLists.txt"%, # it really is kpackage/src/kpackage
        # -kpackage
      ],
      cmakeExtraArgsRecord,
      cmakeArgs,
      configurePhase = [
        "for d in $(ls); do ",
        "echo \"building $d\"",
        "cd $d",
        "cmake -B build -S . %{std.string.join " " cmakeArgs }",
        "cmake --build build",
        "DESTDIR=${DEST} cmake --install build",
        "cd ..",
        "done",
      ],
      buildPhase = [],
      installPhase = [],
      biDrvs | priority 1 =
        _kfBase.biDrvs
        @ [
          drvs.kftier1,
          drvs.libcanberra,
          drvs.libogg,
          drvs.libtool,
          drvs.libvorbis,
        ]
    }
}
in
d
