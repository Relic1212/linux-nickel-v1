{
  lib,
  drvs,
  _plasma_sources,
  kwin | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://download.kde.org/stable/plasma/6.5.0/kwin-6.5.0.tar.xz",
      # sha256sum = "decf1cb79127c285c7eda768e7ff4f97c72f314735c82685758f0b956ac151f7"
      sha256sum = _plasma_sources."%{uri}",
    },
    llvmProvider = drvs.llvmFull,
    biDrvs = [
      # drvs.pkgconf,
      ###
      # drvs.harfbuzz,
      # drvs.pkgconf,
      drvs.alsaLibs,
      drvs.attr,
      drvs.bison,
      drvs.breezeIcons,
      drvs.bzip2,
      drvs.cairo,
      drvs.dbusForQt,
      drvs.ecm,
      drvs.eudev,
      drvs.expat,
      drvs.file,
      drvs.flex,
      drvs.fontconfig,
      drvs.freetype,
      drvs.gettext,
      drvs.glib,
      drvs.harfbuzz,
      drvs.harfbuzzFull,
      drvs.hwdata,
      drvs.jsonC,
      drvs.karchive,
      drvs.kauth,
      drvs.kbookmarks,
      drvs.kcmutils,
      drvs.kcodecs,
      drvs.kcolorscheme,
      drvs.kcompletion,
      drvs.kconfig,
      drvs.kconfigwidgets,
      drvs.kcoreaddons,
      drvs.kcrash,
      drvs.kdbusaddons,
      drvs.kdecoration,
      drvs.kded,
      drvs.kglobalaccel,
      drvs.kguiaddons,
      drvs.ki18n,
      drvs.kiconthemes,
      drvs.kidletime,
      drvs.kio,
      drvs.kirigami,
      drvs.kitemviews,
      drvs.kjobwidgets,
      drvs.kmod,
      drvs.knotifications,
      drvs.kpackage,
      drvs.kservice,
      drvs.ksvg,
      drvs.kwallet,
      drvs.kwayland,
      drvs.kwidgetsaddons,
      drvs.kwindowsystem,
      drvs.kxmlgui,
      drvs.lcms,
      drvs.libcanberra,
      drvs.libcap,
      drvs.libdisplayinfo,
      drvs.libdrm,
      drvs.libelf,
      # drvs.libepoxyPatched,
      drvs.libevdev,
      drvs.libffi,
      drvs.libinput,
      drvs.libjpegTurboStatic,
      drvs.libogg,
      drvs.libpciaccess,
      # drvs.libplasma,
      drvs.libpng,
      drvs.libspng,
      drvs.libtool,
      drvs.libvorbis,
      drvs.libwebp,
      drvs.libx11,
      drvs.libxau,
      drvs.libxcb,
      drvs.libxcursor,
      drvs.libxcvt,
      drvs.libxfixes,
      drvs.libxkbcommon,
      drvs.libxrender,
      drvs.linuxHeaders,
      drvs.llvmConfigStatic,
      drvs.m4,
      drvs.mesaExpKwin,
      drvs.mtdev,
      drvs.openssl,
      drvs.pango,
      drvs.pcre2,
      drvs.pixman,
      # drvs.plasmaActivities,
      drvs.plasmaWaylandProtocols,
      drvs.pythonFull,
      drvs.pythonMako,
      drvs.pythonMarkupsafe,
      drvs.pythonPackaging,
      drvs.pyyaml,
      drvs.qt5compat,
      drvs.qtTools,
      drvs.qtbase,
      drvs.qtdeclarative,
      # drvs.qtsensors,
      drvs.qtsensorsKwin,
      drvs.qtshadertools,
      drvs.qtsvg,
      drvs.qtwayland,
      drvs.solid,
      drvs.spirvLlvmTranslator,
      drvs.spirvTools,
      drvs.switcherooControl,
      drvs.utilLinuxWeak,
      drvs.vala,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.xcbProto,
      drvs.xcbRenderutil,
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.xtrans,
      drvs.xz,
      drvs.zlibNg,
      drvs.zstd,
      drvs.acl,
      drvs.attica,
      drvs.knewstuff,
      drvs.kdeclarative,
      drvs.kglobalacceld,
      drvs.knighttime,
      drvs.qtpositioning,
      drvs.kholidays,
    ],
    buildEnv = {
      EXTRA_LDFLAGS = [
        # "-Wl,--push-state,--no-as-needed",
        "$(pkg-config --libs --static wayland-client expat glib-2.0 gmodule-2.0 libevdev mtdev gbm egl)",
        "-lEGL",
        "-lgallium_dri",
        # "-Wl,--pop-state",
      ]
    },
    debug = true,
    cmakeExtraArgsRecord = {

      "-DKWIN_BUILD_DECORATIONS" = false,
      "-DKWIN_BUILD_KCMS" = false,
      "-DKWIN_BUILD_NOTIFICATIONS" = false,
      "-DKWIN_BUILD_SCREENLOCKER" = false,
      "-DKWIN_BUILD_TABBOX" = false,
      "-DKWIN_BUILD_X11" = false,
      "-DKWIN_BUILD_X11_BACKEND" = false,
      "-DKWIN_BUILD_GLOBALSHORTCUTS" = false,
      "-DKWIN_BUILD_RUNNERS" = false,

      "-DBUILD_TESTING" = false,

      "-DCMAKE_MODULE_LINKER_FLAGS:STRING" = "\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -ldrm $(pkg-config --libs --static dri glesv2 gbm egl wayland-client expat glib-2.0 gmodule-2.0 libevdev mtdev)\""
    },
    preConfigurePhase =
      let prePatch = (
        [
          m%"sed -i 's|IdleTime|IdleTime\n\tArchive|g' ${SRC}/CMakeLists.txt"%,
          m%"sed -i 's|IdleTime|IdleTime\n\tArchive\nKIO\nNotifications|g' ${SRC}/CMakeLists.txt"%,
          m%"sed -i 's|#include <private/qtx11extras_p.h>||g' ${SRC}/src/helpers/killer/killer.cpp"%,
          m%"sed -i 's|add_subdirectory(killer)||g' ${SRC}/src/helpers/CMakeLists.txt"%,
          m%"sed -i 's|kwin SHARED|kwin STATIC|g' ${SRC}/src/CMakeLists.txt"%,
          m%"sed -i 's|epoxy::epoxy|EGL::EGL|g' ${SRC}/src/CMakeLists.txt"%,
          m%"sed -i 's|install(TARGETS kwin EXPORT KWinTargets|install(TARGETS kwin WaylandProtocols_xml EXPORT KWinTargets|g' ${SRC}/src/CMakeLists.txt"%,
          m%"sed -i 's| MODULE | STATIC |g' ${SRC}/src/kcms/common/CMakeLists.txt"%,
          m%"sed -i 's| SHARED | STATIC |g' ${SRC}/src/kcms/common/CMakeLists.txt"%,

          # m%"sed -i 's|KF6::Svg|KF6::Archive\n\tKF6::svg|g' ${SRC}/src/kcms/screenedges/CMakeLists.txt"%,

          # m%"sed -i 's|KF6::Svg|KF6::Archive\n\tKF6::svg|g' ${SRC}/src/plugins/screenedge/CMakeLists.txt"%,
        ]
        @ (
          let files = [
            # "src/CMakeLists.txt",
            "src/scene/surfaceitem.cpp",
            "src/core/outputbackend.h",
            "src/opengl/gltexture.h",
            "src/utils/drm_format_helper.h",
            "src/opengl/eglcontext.h",
            "src/opengl/egldisplay.h",
            "src/opengl/egl_context_attribute_builder.cpp",
            "src/opengl/eglimagetexture.cpp",
            "src/opengl/eglnativefence.h",
            "src/opengl/gllut3D.h",
            "src/opengl/glvertexbuffer_p.h",
            "src/opengl/gllut.h",
            "src/opengl/glvertexbuffer.h",
            "src/opengl/gltexture_p.h",
            "src/opengl/eglswapchain.h",
            "src/opengl/glrendertimequery.h",
            "src/backends/drm/drm_egl_layer.h",
            "src/opengl/eglbackend.h",
            "src/opengl/glframebuffer.h",
            "src/opengl/glplatform.cpp",
            "src/opengl/eglutils_p.h",
            "src/opengl/glshader.h",
            "src/backends/drm/drm_gpu.h",
            "src/backends/drm/drm_virtual_egl_layer.h",
            "src/scripting/windowthumbnailitem.h",
            "src/plugins/colorpicker/colorpicker.cpp",
            "src/plugins/qpa/integration.h",
            "src/plugins/qpa/eglplatformcontext.h",
            "src/plugins/qpa/eglhelpers.h",
            "src/plugins/qpa/window.cpp",
            "src/plugins/qpa/offscreensurface.h",
          ]
          in
          std.array.map
            (fun s =>
              (
                std.string.join
                  "\n"
                  [
                    m%"sed -i 's|#include <epoxy/gl.h>|#include <GL/gl.h>\n#include <GL/glext.h>|g' ${SRC}/%{s}"%,
                    m%"sed -i 's|#include <epoxy/egl.h>|#include <EGL/egl.h>\n#include <EGL/eglext.h>|g' ${SRC}/%{s}"%,
                    # "sed -i 's|epoxy/egl.h|EGL/egl.h|g' ${SRC}/%{s}",
                    #  "sed -i 's|epoxy/glext.h|GL/glext.h|g' ${SRC}/%{s}",
                  ]
              )
            )
            files
        )
      )
      in
      [],
    patches = [
      # https://github.com/celestiamobile/celestia-web/blob/b278e8111a6090bdb023235a086203664d8cb336/patches/gles.patch#L124
      {
        sha256sum = "60b8802949a6c9cc4e612d65aa3bf253bd07a2b1385ad02a53069704549ad775",
        file = "0001-kwin.patch",
      }
    ]
  },

  qtsensors,
  qtsensorsKwin =
    qtsensors
    & {
      postInstallPhase = [
        "cd ${DEST}/usr/lib/qt6/plugins/sensors/",
        m%"for sym in $(llvm-nm libqtsensors_iio-sensor-proxy.a | grep OrgFreedesktopDBusPropertiesInterface);do
        echo 'redefining "${sym}"="__qtsensors__${sym}"'
        llvm-objcopy --redefine-sym="${sym}"="__qtsensors__${sym}" libqtsensors_iio-sensor-proxy.a
      done
      "%
        # "objcopy --prefix-symbols=__qtsensors__ ${DEST}/usr/lib/qt6/plugins/sensors/libqtsensors_iio-sensor-proxy.a"
      ]
    }
}
& (import "plasma.ncl")
