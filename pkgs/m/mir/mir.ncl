{
  lib,
  drvs,
  mir | lib.CmakePackage = {

    singleSource = {
      uri = "https://github.com/canonical/mir/archive/refs/tags/v2.28.0.tar.gz",
      sha256sum = "c21648f0a72dfc590cc5bd3fa52f41c84407ba02eacad4f7455a259ae9c0925a"
    },

    generator = "Ninja",

    cmakeExtraArgsRecord = {
      "-DMIR_ENABLE_TESTS" = false,
      "-DMIR_FATAL_COMPILE_WARNINGS" = false,

      "-DMIR_PLATFORM" = "'wayland,gbm-kms'",
      "-DMIR_ENABLE_RUST" = false,
    },

    buildEnv = {
      EXTRA_CXXFLAGS = [
        "-D_LIBCPP_ENABLE_CXX17_REMOVED_AUTO_PTR",
        "-fexperimental-library",
      ],
      # EXTRA_CPPFLAGS = [
      #   "-fexperimental-library",
      # ]
    },

    preConfigurePhase =
      [
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
        m%"for f in $(find ${SRC}/src -type f -name CMakeLists.txt);do sed -i 's@ MODULE@@g' ${f};done"%,
        m%"sed -i 's|zoned_time|std::chrono::zoned_time|g' ${SRC}/src/core/logging/logger.cpp"%,
      ]
      @ (
        std.array.map
          (fun s => "sed -i 's|move_only_function|function|g' %{s}"
          )
          [
            "${SRC}/include/miral/miral/live_config_overrides_list.h",
            "${SRC}/src/server/scene/basic_clipboard.h",
            "${SRC}/src/server/scene/basic_clipboard.cpp",
            "${SRC}/src/include/server/mir/scene/clipboard.h",
          ]
      ),

    postInstallPhase = [
      "cd ${DEST}/usr/lib",
      "mv input-evdev.so.10 input-evdev.a",
      "mv renderer-egl-generic.so.23 renderer-egl-generic.a",
      "mv server-virtual.so.23 server-virtual.a",
    ],

    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.pythonFull,
    ],
    pDrvs = [
      # drvs.mesa2,
      drvs.boost,
      drvs.glm102,
      drvs.libepoxy,
      drvs.freetype,
      # drvs.glib,
      drvs.libinput,
      drvs.lttngUst,
      drvs.utilLinux,
      drvs.libxcursor,
      drvs.libxkbcommon,
      drvs.libdisplayinfo,
      drvs.pixman,
      drvs.libxmlplusplus,
      drvs.libxml2Cmake,
      drvs.yamlCpp,
      drvs.liburcu,
    ]
  }
}
