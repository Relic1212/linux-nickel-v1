{
  lib,
  drvs,
  ags | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/Aylur/ags/archive/refs/tags/v3.1.2.tar.gz",
      sha256sum = "7c9bf38cddfa9661ca3bc70268df0f3124174dad0d6ff85433445816471690f4"
    },
    sourceInputs = [
      {
        src = singleSource,
      },
      {
        src = {
          uri = "https://proxy.golang.org/github.com/evanw/esbuild/@v/v0.25.10.zip",
          sha256sum = "1c47c22c32c65061631d557bcca13771bff671ba9d35563290d1855607eee2d2"
        },
      },
      {
        src = {
          uri = "https://proxy.golang.org/github.com/godbus/dbus/v5/@v/v5.1.0.zip",
          sha256sum = "03dfa8e71089a6f477310d15c4d3a036d82d028532881b50fee254358e782ad9"
        },
      },
      {
        src = {
          uri = "https://proxy.golang.org/github.com/titanous/json5/@v/v1.0.0.zip",
          sha256sum = "955cc45b5d0f44fe87e3d084789e7a1d12705747c4df6b16725ce86dbb6f99e0"
        }
      },
      {
        src = {
          uri = "https://proxy.golang.org/github.com/spf13/cobra/@v/v1.10.1.zip",
          sha256sum = "00955783267c9ced54274df456377a15bc1b658362f93f85dfda0708b54f9a28",
        },
      },
      {
        src = {
          uri = "https://proxy.golang.org/golang.org/x/sys/@v/v0.36.0.zip",
          sha256sum = "894ee9a48e191265cd3d2200ddd81b8d75c554a0eabe9fc1a9afbab25a4b29c4"
        }
      },
      {
        src = {
          uri = "https://proxy.golang.org/github.com/spf13/pflag/@v/v1.0.10.zip",
          sha256sum = "a246b8c9d3daa87d6c634cdfee1bdf7fa53d5817eeef4fa0c6da43edd12de4ca"
        }
      },
    ],

    unpackPhase = [
      "tar xf /tmp/workdir/packed/%{singleSource.sha256sum}/*.tar.gz -C /tmp/workdir/src --strip-components=1",
    ],

    buildEnv = {
      EXTRA_LDFLAGS = [
        "/tmp/workdir/src/dlopen.o",
      ],
      PKG_CONFIG = null,
    },
    extraEnv = {
      "GOROOT" = "/usr/lib/go",
      "HOME" = "/tmp/home",
    },
    preConfigurePhase =
      [
        lib.functions.writeFile "${SRC}/dlopen.c" (import "astal_dlopen.c" as 'Text),
        "${CC} ${CFLAGS} -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
        "mkdir ${HOME}",
        "export GOPROXY=\"file:///tmp/workdir/build/goproxy\"",
        "mkdir ${BUILDDIR}/goproxy",
      ]
      @ (
        std.array.map
          (fun src =>
            let dest = std.string.replace "https://proxy.golang.org/" "" src.src.uri, fsrc = "/tmp/workdir/packed/%{src.src.sha256sum}/%{std.string.split "/" src.src.uri |>std.array.last}" in
            "UNZIPDIR=${BUILDDIR}/%{src.src.sha256sum}"
            ++ "\n"
            ++ "mkdir ${UNZIPDIR}"
            ++ "\n"
            ++ "(cd ${UNZIPDIR}/ && unzip %{fsrc})"
            ++ "\n"
            ++ "install -Dm0755 %{fsrc} ${BUILDDIR}/goproxy/%{dest}"
            ++ "\n"
            ++ "GOMOD=\"$(find ${UNZIPDIR} -name go.mod)\""
            ++ "\n"
            ++ "cp -v $(dirname ${GOMOD})/*.mod $(dirname ${BUILDDIR}/goproxy/%{dest})"
            ++ "\n"
            ++ "cp -v ${GOMOD} ${BUILDDIR}/goproxy/%{std.string.replace ".zip" ".mod" dest}"
          )
        #
          (std.array.drop_first sourceInputs)
        #
      ),
    llvmProvider = drvs.llvmFull,
    pythonProvider = drvs.pythonDynamic,
    muslProvider = drvs.muslBothRenamedDl,

    biDrvs = [
      # drvs.fontconfig,
      # drvs.freetype,
      # drvs.zlibNg,
      # drvs.gperf,
      # drvs.pixman,
      # drvs.wayland,
      # drvs.waylandProtocols,
      # drvs.libffi,
      # drvs.libxkbcommon,
      # drvs.expat,
      # drvs.linuxHeaders,
      # drvs.ncurses,
      # drvs.readline,
      # drvs.pcre2,
      # drvs.pango, #??
      # drvs.pango,
      # drvs.cairo,
      # drvs.libpng,
      # drvs.harfbuzzFull,
      drvs.glibGobject,
      drvs.muslShared,
      drvs.hwdata,
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
      drvs.llvmConfigStatic,
      # drvs.spirvTools,
      # drvs.spirvLlvmTranslator,
      # drvs.gtk4,
      drvs.valaDoc,
      drvs.pythonSetuptools,
      # drvs.libtiff,
      # drvs.graphene,
      # drvs.gtk4LayerShell,
      drvs.waylandGtk4LayerShell,
      # drvs.libadwaita,

      # drvs.cairoGobject,
      drvs.gdkPixbufIntrospectionDynamic & { priority = -1 },
      drvs.glibGobjectDynamic & { priority = -2 },
      # drvs.gobjectDynamic,
      drvs.gobjectDynamicCairo2 & { priority = -1 },
      drvs.grapheneIntrospection & { priority = -1 },
      drvs.gtk4IntrospectionDynamic & { priority = -1 },
      drvs.gtk4LayerShellIntrospection & { priority = -1 },
      drvs.harfbuzzGobjectDynamic & { priority = -1 },
      drvs.pangoGobject & { priority = -1 },
      drvs.pythonPygobject,
      drvs.libadwaitaIntrospection & { priority = -1 },
      drvs.astalIo,
      drvs.astalGtk4,
      drvs.go_1_26,
      drvs.gjs,
      # drvs.cairoGobject,
      drvs.gtk4LayerShell,
      drvs.bash,
    ],
    neverInclude = [
      drvs.wayland,
    ],
    pDrvs = [
      drvs.gtk4,
    ]
  }
}
