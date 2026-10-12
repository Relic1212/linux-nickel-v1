{
  lib,
  drvs,
  mir | lib.CargoPackage = {
    debug = true,

    singleSource = {
      uri = "https://github.com/canonical/mir/archive/refs/tags/v2.30.0.tar.gz",
      sha256sum = "129c993930af6fd4a8036a3fc5b34f0e7ef9ec26b6b90f3a04634fb6fe13a3f5"
    },
    crates = lib.functions.filterCrates (import "mir-crates.json"),

    # generator = "Ninja",

    # cmakeExtraArgsRecord = {
    #   "-DMIR_ENABLE_TESTS" = false,
    #   "-DMIR_FATAL_COMPILE_WARNINGS" = false,

    #   "-DMIR_PLATFORM" = "'wayland,gbm-kms'",
    #   "-DMIR_ENABLE_RUST" = false,
    # },

    buildEnv = {
      EXTRA_CXXFLAGS = [
        # "-std=c++23",
        "-D_LIBCPP_ENABLE_CXX17_REMOVED_AUTO_PTR",
        "-D_LIBCPP_ENABLE_CXX26_REMOVED_WSTRING_CONVERT",
        "-D_LIBCPP_ENABLE_CXX26_REMOVED_CODECVT",
        "-fexperimental-library",
        # "-Dstd::move_only_function=std::function",
        "-Dmove_only_function=function",

        # "-stdlib=libc++",
      ],
      EXTRA_CPPFLAGS = [
        # "-Dmove_only_function=function",
        #   "-fexperimental-library",
      ],
      EXTRA_LDFLAGS = [
        "$(pkg-config --static --libs xcursor)",
      ],
    },
    extraEnv = {
      CMAKE_GENERATOR = "Ninja",
      DEB_HOST_RUST_TYPE = target,
    },
    target,
    enableCcache = true,

    # preConfigurePhase =
    #   [
    #     m%"sed -i 's@add_subdirectory(examples/)@@g' ${SRC}/CMakeLists.txt"%,
    #     m%"sed -i 's@ SHARED@@g' ${SRC}/tests/unit-tests/CMakeLists.txt"%,
    #     m%"sed -i 's@ SHARED@@g' ${SRC}/src/miral/CMakeLists.txt"%,
    #     m%"sed -i 's@ SHARED@@g' ${SRC}/src/core/CMakeLists.txt"%,
    #     m%"sed -i 's@ SHARED@@g' ${SRC}/src/server/report/lttng/CMakeLists.txt"%,
    #     m%"sed -i 's@ SHARED@@g' ${SRC}/src/platform/CMakeLists.txt"%,
    #     m%"sed -i 's@ SHARED@@g' ${SRC}/src/common/CMakeLists.txt"%,
    #     m%"sed -i 's@ SHARED@@g' ${SRC}/src/server/CMakeLists.txt"%,
    #     m%"sed -i 's@ SHARED@@g' ${SRC}/src/wayland/CMakeLists.txt"%,
    #     m%"sed -i 's@ SHARED@@g' ${SRC}/src/miroil/CMakeLists.txt"%,
    #     m%"sed -i 's@#include <sys/eventfd.h>@#include <sys/eventfd.h>\n#include <cstdlib>@g' ${SRC}/src/common/dispatch/action_queue.cpp"%,
    #     m%"sed -i 's@#include <sys/eventfd.h>@#include <sys/eventfd.h>\n#include <system_error>@g' ${SRC}/src/common/dispatch/action_queue.cpp"%,
    #     m%"sed -i 's@#include <mir/frontend/pointer_input_dispatcher.h>@#include <mir/frontend/pointer_input_dispatcher.h>\n#include <mutex>@g' ${SRC}/src/miroil/gesture_ender.cpp"%,
    #     m%"for f in $(find ${SRC}/src -type f -name CMakeLists.txt);do sed -i 's@ MODULE@@g' ${f};done"%,
    #     m%"sed -i 's|zoned_time|std::chrono::zoned_time|g' ${SRC}/src/core/logging/logger.cpp"%,
    #   ]
    #   @ (
    #     std.array.map
    #       (fun s => "sed -i 's|move_only_function|function|g' %{s}"
    #       )
    #       [
    #         "${SRC}/include/miral/miral/live_config_overrides_list.h",
    #         "${SRC}/src/server/scene/basic_clipboard.h",
    #         "${SRC}/src/server/scene/basic_clipboard.cpp",
    #         "${SRC}/src/include/server/mir/scene/clipboard.h",
    #       ]
    #   ),
    buildPhase =
      let args = [
        # "-DCMAKE_CXX_STANDARD=23",
        " -DCMAKE_C_COMPILER_LAUNCHER=ccache",
        "-DCMAKE_CXX_COMPILER_LAUNCHER=ccache",
        "-DBUILD_SHARED_LIBS:BOOL=OFF",
        "-DBUILD_STATIC_LIBS:BOOL=ON",
        "-DCMAKE_BUILD_TYPE=Release",
        "-DCMAKE_INSTALL_BINDIR:PATH=bin",
        "-DCMAKE_INSTALL_DATAROOTDIR:PATH=share",
        "-DCMAKE_INSTALL_INCLUDEDIR:PATH=include",
        "-DCMAKE_INSTALL_LIBDIR:PATH=lib",
        "-DCMAKE_INSTALL_LIBEXECDIR:PATH=libexec",
        "-DCMAKE_INSTALL_LOCALSTATEDIR:PATH=/var",
        "-DCMAKE_INSTALL_PREFIX=/usr",
        "-DCMAKE_INSTALL_SBINDIR:PATH=bin",
        "-DCMAKE_INSTALL_SHAREDSTATEDIR:PATH=../com",
        "-DCMAKE_INSTALL_SYSCONFDIR:PATH=/etc",
        "-DCMAKE_LINK_SEARCH_START_STATIC:BOOL=OFF",
        "-DCMAKE_SKIP_INSTALL_RPATH:BOOL=ON",
        "-DMIR_ENABLE_RUST:BOOL=OFF",
        "-DMIR_ENABLE_TESTS:BOOL=OFF",
        "-DMIR_FATAL_COMPILE_WARNINGS:BOOL=OFF",
        # "-DMIR_PLATFORM=wayland,gbm-kms,atomic-kms",
      ]
      in
      [
        "patch -p1 << 'EOF'\n%{import "fix.patch" as 'Text}\nEOF\n",
        "patch -p1 << 'EOF'\n%{import "fix2.patch" as 'Text}\nEOF\n",
        "patch -p1 << 'EOF'\n%{import "dlclose.patch" as 'Text}\nEOF\n",
        "patch -p1 << 'EOF'\n%{import "libraries.patch" as 'Text}\nEOF\n",
        "patch -p1 << 'EOF'\n%{import "dladdr.patch" as 'Text}\nEOF\n",
        m%"sed -i 's@add_subdirectory(example-server-lib)@@g' ${SRC}/examples/CMakeLists.txt"%,
        m%"sed -i 's@add_subdirectory(miral-shell)@@g' ${SRC}/examples/CMakeLists.txt"%,
        m%"sed -i 's@add_subdirectory(miral-kiosk)@@g' ${SRC}/examples/CMakeLists.txt"%,
        m%"sed -i 's@add_subdirectory(client)@@g' ${SRC}/examples/CMakeLists.txt"%,
        m%"for f in $(find "${SRC}" -type f -name CMakeLists.txt);do sed -i -e 's@ MODULE@ STATIC@g' -e 's@ SHARED@ STATIC@g' "${f}";done"%,
        m%"sed -i "s@add_dependencies@set_source_files_properties(\${cxxbridge_source} PROPERTIES CXX_SCAN_FOR_MODULES OFF)\nadd_dependencies@g" ${SRC}/cmake/RustLibrary.cmake"%,
        m%"sed -i "s@%{
          m%"set(cxxbridge_include_dir \"\${rust_target_dir}/\$ENV{DEB_HOST_RUST_TYPE}/cxxbridge\")"%
        }@%{
          m%"set(cxxbridge_include_dir \"\${rust_target_dir}/cxxbridge\")"%
        }@g" ${SRC}/cmake/RustLibrary.cmake"%,
        m%"sed -i "s@#include <sys/eventfd.h>@#include <sys/eventfd.h>\n#include <system_error>@g" ${SRC}/src/common/dispatch/action_queue.cpp"%,
        # m%"sed -i 's@set(CMAKE_CXX_STANDARD 26)@set(CMAKE_CXX_STANDARD 23)@g' ${SRC}/CMakeLists.txt"%,
        # m%"sed -i '1i #include <functional>'  ${SRC}/src/include/server/mir/scene/clipboard.h"%,
        m%"sed -i -e 's@#include <experimental/scope>@@g' -e 's@std::experimental::scope_exit(@mir::raii::paired_calls([](){},@g' %{
          std.string.join " " [
          "${SRC}/src/server/console/linux_virtual_terminal.cpp",
         "${SRC}/src/server/compositor/multi_threaded_compositor.cpp",]}"%,
        # m%"sed -i "1i #include<memory>\n#include<vector>" ${SRC}/src/server/shm_backing.cpp"%,
        m%"sed -i "s@#include <format>@#include <format>\n#include<vector>@g" ${SRC}/src/server/shm_backing.cpp"%,
        m%"sed -i "s@#include <type_traits>@#include <type_traits>\n#include<vector>@g" ${SRC}/include/miral/miral/configuration_option.h"%,
        m%"sed -i 's@add_subdirectory(examples/)@@g' ${SRC}/CMakeLists.txt"%,
        m%"sed -i 's@add_subdirectory(doc)@@g' ${SRC}/CMakeLists.txt"%,
        m%"sed -i "s@#include <stdexcept>@#include <stdexcept>\n#include <vector>@g" ${SRC}/src/miroil/set_compositor.cpp"%,
        m%"sed -i "s@#include <functional>@#include <functional>\n#include <vector>@g" ${SRC}/include/miroil/miroil/set_compositor.h"%,
        m%"sed -i "s@#include <boost/throw_exception.hpp>@#include <boost/throw_exception.hpp>\n#include <istream>@g" ${SRC}/src/miral/live_config_overrides_list.cpp"%,
        m%"sed -i "s@#include <locale>@\n#include <locale>\n#include <algorithm>\n#include <ranges>@g" ${SRC}/src/miral/application_switcher.cpp"%,
        m%"sed -i "s@#include <string>@#include <string>\n#include <istream>\n#include <ios>@g" ${SRC}/src/miral/live_config_ini_file_common.cpp"%,
        m%"sed -i "s@#include <miral/live_config_overrides_list.h>@#include <miral/live_config_overrides_list.h>\n#include <vector>@g" ${SRC}/src/miral/live_config_overrides_list_builder.h"%,
        m%"sed -i "s@#include <stdexcept>@#include <stdexcept>\n#include <charconv>@g" ${SRC}/src/miral/basic_store.cpp"%,
        m%"sed -i "s@#include <vector>@#include <vector>\n#include <istream>@g" ${SRC}/src/miral/override_watcher.cpp"%,
        m%"sed -i "s@#include <tuple>@#include <tuple>\n#include <vector>@g" ${SRC}/src/server/frontend_wayland/wlr_screencopy_v1.h"%,
        m%"sed -i "s@#include <mutex>@#include <mutex>\n#include <vector>@g" ${SRC}/src/server/frontend_wayland/foreign_toplevel_manager_v1.h"%,
        m%"sed -i "s@namespace mir@#include <vector>\nnamespace mir@g" ${SRC}/src/server/frontend_wayland/wl_data_source.h"%,
        m%"sed -i "s@#include <future>@#include <future>\n#include <atomic>@g" ${SRC}/src/platforms/atomic-kms/server/kms/atomic_kms_output.h"%,
        # m%"sed -i 's@OBJECT@STATIC@g' ${SRC}/src/miral/CMakeLists.txt"%,
        # m%"sed -i 's@make_unique_context@make_unique_context_registrar@g' ${SRC}/src/server/input/xkb_mapper_registrar.cpp"%,
        ####
        "cd ${BUILDDIR}",
        "cmake -B . -S ${SRC} %{std.string.join " " args}",
        # "ninja target/x86_64-unknown-linux-musl/cxxbridge/mir_platforms_evdev_rs/src/lib.rs.cc",
        "cmake --build .",
      ],
    installPhase = [
      "DESTDIR=${DEST} cmake --install .",
    ],

    postInstallPhase =
      [
        "install -m0755 ${BUILDDIR}/src/miral/libmiral-internal.a ${DEST}/usr/lib",
        "install -m0755 ${BUILDDIR}/target/x86_64-unknown-linux-musl/release/libwayland_rs.a ${DEST}/usr/lib",
        "install -m0755 ${BUILDDIR}/target/x86_64-unknown-linux-musl/release/libmir_platforms_evdev_rs.a ${DEST}/usr/lib",
        "install -dm0755 ${DEST}/usr/lib/mirdeps",
        "for lib in $(find ${BUILDDIR} -type f -name '*.a'); do install -m0755 \"${lib}\" ${DEST}/usr/lib/mirdeps;done",
        "llvm-objcopy --redefine-sym XcursorImagesDestroy=libmir_internal__XcursorImagesDestroy ${DEST}/usr/lib/libmiral-internal.a",
        "cd ${DEST}/usr/lib",
        "cp input-evdev-rs.so.11 input-evdev-rs.a",
        "cp input-evdev.so.11 input-evdev.a",
        "cp renderer-egl-generic.so.24 renderer-egl-generic.a",
        "cp server-virtual.so.24 server-virtual.a",
        "cp graphics-atomic-kms.so.24 graphics-atomic-kms.a",
        "cp graphics-gbm-kms.so.24 graphics-gbm-kms.a",
        "cp graphics-wayland.so.24 graphics-wayland.a",
      ]
      @ (
        let fNames = [
          "add_input_platform_options",
          "create_input_platform",
          "describe_input_module",
          "probe_input_platform",

          #
          "add_graphics_platform_options",
          "create_rendering_platform",
          "describe_graphics_module",
          "probe_rendering_platform",
          #
          "add_graphics_platform_options",
          "create_display_platform",
          "describe_graphics_module",
          "probe_display_platform",
        ]
        in
        std.array.map
          (fun libName =>
            let prefix = std.string.replace "-" "_" libName
            in
            let cmds = (std.array.map (fun sym => "llvm-objcopy --redefine-sym %{sym}=%{prefix}__%{sym} %{libName}.a") fNames)
            in std.string.join "\n" cmds
          )
          [
            "input-evdev-rs",
            "input-evdev",
            "renderer-egl-generic",
            "server-virtual",
            "graphics-atomic-kms",
            "graphics-gbm-kms",
            "graphics-wayland",
          ]
      ),

    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.pythonFull,
      drvs.samurai,
      drvs.cmake,
      drvs.musl,
      drvs.ccacheBin,
    ],
    pDrvs = [
      # drvs.mesa2,
      drvs.bzip2,
      drvs.zstd,
      drvs.xz,
      drvs.boost,
      drvs.glm102,
      drvs.libepoxy,
      drvs.freetype,
      # drvs.glib,
      drvs.libinput,
      drvs.lttngUst,
      drvs.utilLinux,
      # drvs.libxcursor,
      drvs.libxkbcommonX11,
      drvs.libdisplayinfo,
      drvs.pixman,
      drvs.libxmlplusplus,
      drvs.libxml2Cmake,
      drvs.yamlCpp,
      drvs.liburcu,
    ]
  }
}
