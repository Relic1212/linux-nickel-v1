{
  lib,
  drvs,
  mir | lib.CmakePackage = {

    singleSource = {
      uri = "https://github.com/canonical/mir/archive/refs/tags/v2.25.2.tar.gz",
      sha256sum = "68e7bc083ebf3e1c08ae13aefe787eecf9e5ca4f1c1f5cf31ec540a25e9378b4"
    },

    generator = "Ninja",

    cmakeExtraArgsRecord = {
      "-DMIR_ENABLE_TESTS" = false,
      "-DMIR_FATAL_COMPILE_WARNINGS" = false,

      "-DMIR_PLATFORM" = "'wayland,gbm-kms'",
    },

    buildEnv = {
      EXTRA_CXXFLAGS = [
        "-D_LIBCPP_ENABLE_CXX17_REMOVED_AUTO_PTR",
      ]
    },

    preConfigurePhase = [
      m%"sed -i 's@add_subdirectory(examples/)@@g' ${SRC}/CMakeLists.txt"%,
      m%"sed -i 's@ SHARED@@g' ${SRC}/tests/unit-tests/CMakeLists.txt"%,
      m%"sed -i 's@ SHARED@@g' ${SRC}/src/miral/CMakeLists.txt"%,
      m%"sed -i 's@ SHARED@@g' ${SRC}/src/core/CMakeLists.txt"%,
      m%"sed -i 's@ SHARED@@g' ${SRC}/src/server/report/lttng/CMakeLists.txt"%,
      m%"sed -i 's@ SHARED@@g' ${SRC}/src/platform/CMakeLists.txt"%,
      m%"sed -i 's@ SHARED@@g' ${SRC}/src/common/CMakeLists.txt"%,
      m%"sed -i 's@ SHARED@@g' ${SRC}/src/server/CMakeLists.txt"%,
      m%"sed -i 's@ SHARED@@g' ${SRC}/src/wayland/CMakeLists.txt"%,
      m%"sed -i 's@ SHARED@@g' ${SRC}/src/miroil/CMakeLists.txt"%,
      m%"sed -i 's@#include <sys/eventfd.h>@#include <sys/eventfd.h>\n#include <cstdlib>@g' ${SRC}/src/common/dispatch/action_queue.cpp"%,
      m%"sed -i 's@#include <sys/eventfd.h>@#include <sys/eventfd.h>\n#include <system_error>@g' ${SRC}/src/common/dispatch/action_queue.cpp"%,
      m%"sed -i 's@#include <mir/frontend/pointer_input_dispatcher.h>@#include <mir/frontend/pointer_input_dispatcher.h>\n#include <mutex>@g' ${SRC}/src/miroil/gesture_ender.cpp"%,
      m%"for f in $(find ${SRC}/src -type f -name CMakeLists.txt);do sed -i 's@ MODULE@@g' ${f};done"%
    ],

    postInstallPhase = [
      "cd ${DEST}/usr/lib",
      "mv input-evdev.so.10 input-evdev.a",
      "mv renderer-egl-generic.so.23 renderer-egl-generic.a",
      "mv server-virtual.so.23 server-virtual.a",
    ],

    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.expat,
      drvs.jsonC,
      drvs.pcre2,
      drvs.mesa2,
      drvs.spirvTools,
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
      drvs.nlohmannJson,
      drvs.tomlplusplus,
      drvs.utilLinux,
      drvs.libyaml,
      drvs.boost,
      drvs.gdkPixbufFull,
      drvs.libjpegTurbo,
      drvs.basu,
      drvs.lcms,
      drvs.scdoc,

      # X11
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
      drvs.xcbRenderutil,
      drvs.libxfont2,
      drvs.libfontenc,
      drvs.libxcvt,
      drvs.libxshmfence,
      drvs.xwayland,
      drvs.libxkbfile,
      drvs.openssl,
      drvs.xcbUtilWm,
      drvs.glm,
      drvs.libepoxy,
      drvs.lttngUst212,
      drvs.liburcu,
      drvs.libxml2Cmake,
      drvs.libxmlplusplus,
      drvs.libsigcpp2,
      drvs.glibmm,
      drvs.yamlCpp,
      drvs.pythonFull,
      drvs.gmp,
    ]
  }
}
