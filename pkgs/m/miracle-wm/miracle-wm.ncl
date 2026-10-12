{
  lib,
  drvs,
  miracleWm | lib.CmakePackage = {
    debug = true,
    singleSource = {
      uri = "https://github.com/miracle-wm-org/miracle-wm/archive/refs/tags/v0.11.2.tar.gz",
      sha256sum = "71e244ec4991c21fb875182e220bc17227cd45c361f4b674aecb9af785134d45"
    },

    buildEnv = {
      EXTRA_CPPFLAGS = ["-D_GNU_SOURCE"],
      EXTRA_CXXFLAGS = [
        "-D_GNU_SOURCE",
      ],

      EXTRA_LDFLAGS = [
        "-lc++",
        "-lc++experimental",
        "-lboost_program_options",
        "-lboost_iostreams",
        "-lmiral-internal",
        "$(pkg-config --static --libs gio-2.0 gobject-2.0 libdisplay-info libudev lttng-ust xcb xcursor xcb-res xcb-xfixes freetype2 xcb-composite)",
        "-llttng-ust-tracepoint",
        "/tmp/workdir/src/dlopen.o",
        "/tmp/workdir/src/obj.o",
        "/usr/lib/input-evdev-rs.a",
        "/usr/lib/input-evdev.a",
        "/usr/lib/renderer-egl-generic.a",
        "/usr/lib/server-virtual.a",
        "/usr/lib/graphics-gbm-kms.a",
        "/usr/lib/graphics-atomic-kms.a",
        "/usr/lib/graphics-wayland.a",
        "$(pkg-config --static --libs mircommon mirplatform libinput egl mirwayland pixman-1 epoxy wayland-egl)",
        "-lwayland_rs",
        "-lmir_platforms_evdev_rs",
        "/usr/lib/mirdeps/libmirplatforminputevdevrs_rust-cxxbridge.a",
        "/usr/lib/mirdeps/libgraphics_platform_common.a",
        "/usr/lib/mirdeps/libmirsharedgbmservercommon-static.a",
        "/usr/lib/mirdeps/libkms_utils.a",
        "/usr/lib/mirdeps/libmirsharedatomickmscommon-static.a",
        "/usr/lib/mirdeps/libmirplatformwayland-graphics.a",
        "/usr/lib/mirdeps/libmirplatformwayland-input.a",
      ],
    },

    cmakeExtraArgsRecord = {
      "-DENABLE_TESTS" = false,
      "-DFEATURE_PLUGIN_SYSTEM" = false,
      "-DFEATURE_PARENT_CONTAINER_WALLPAPERS" = false,
      "-DBUILD_ERROR_REPORTER" = false,
      "-DBUILD_DEBUG_OVERLAY" = false,
    },

    preConfigurePhase =
      let lu = [
        "\"lttng_ust_tp_rcu_read_lock\"",
        "\"lttng_ust_tp_rcu_read_unlock\"",
        "\"lttng_ust_tp_rcu_dereference_sym\"",
        "\"lttng_ust_tp_rcu_read_lock\"",
        "\"lttng_ust_tp_rcu_read_unlock\"",
        "\"lttng_ust_tp_rcu_dereference_sym\"",
        "\"lttng_ust_tracepoint_module_register\"",
        "\"lttng_ust_tracepoint_module_unregister\"",
        "\"lttng_ust_tp_disable_destructors\"",
        "\"lttng_ust_tp_get_destructors_state\"",
        "\"lttng_ust_tp_rcu_read_lock\"",
        "\"lttng_ust_tp_rcu_read_unlock\"",
        "\"lttng_ust_tp_rcu_dereference_sym\"",
        "\"lttng_ust_tp_rcu_read_lock\"",
        "\"lttng_ust_tp_rcu_read_unlock\"",
        "\"lttng_ust_tp_rcu_dereference_sym\"",
        "\"lttng_ust_tp_rcu_read_lock\"",
        "\"lttng_ust_tp_rcu_read_unlock\"",
        "\"lttng_ust_tp_rcu_dereference_sym\"",
        "\"lttng_ust_tp_rcu_read_lock\"",
        "\"lttng_ust_tp_rcu_read_unlock\"",
        "\"lttng_ust_tp_rcu_dereference_sym\"",
        "\"lttng_ust_tp_rcu_read_lock\"",
        "\"lttng_ust_tp_rcu_read_unlock\"",
        "\"lttng_ust_tp_rcu_dereference_sym\"",
        "\"lttng_ust_tp_rcu_read_lock\"",
        "\"lttng_ust_tp_rcu_read_unlock\"",
        "\"lttng_ust_tp_rcu_dereference_sym\"",
        # "\"ltt_probe_register\"",
        # "\"liblttng-ust.so.1\"",
      ]
      in
      let
        getInputSyms = fun prefix =>
          std.string.join
            ","
            (
              std.array.map
                (fun s => m%""%{prefix}%{s}""%)
                [
                  "add_input_platform_options",
                  "create_input_platform",
                  "describe_input_module",
                  "probe_input_platform",
                ]
            ),
        getGSyms = fun prefix =>
          std.string.join
            ","
            (
              std.array.map
                (fun s => m%""%{prefix}%{s}""%)
                [
                  "add_graphics_platform_options",
                  "create_rendering_platform",
                  "describe_graphics_module",
                  "probe_rendering_platform",
                ]
            ),
        getDSyms = fun prefix =>
          std.string.join
            ","
            (
              std.array.map
                (fun s => m%""%{prefix}%{s}""%)
                [
                  "add_graphics_platform_options",
                  "create_display_platform",
                  "describe_graphics_module",
                  "probe_display_platform",
                ]
            ),
        getGDSyms = fun prefix =>
          std.string.join
            ","
            (
              std.array.map
                (fun s => m%""%{prefix}%{s}""%)
                [
                  "add_graphics_platform_options",
                  "create_display_platform",
                  "create_rendering_platform",
                  "describe_graphics_module",
                  "probe_display_platform",
                  "probe_rendering_platform",
                ]
            ),
      in
      let libs = [
        m%"'{"names":["server-virtual.so.24"],"symbols":[%{getDSyms "server_virtual__" }],"prefix":"server_virtual__"}'"%,
        m%"'{"names":["renderer-egl-generic.so.24"],"symbols":[%{getGSyms "renderer_egl_generic__" }],"prefix":"renderer_egl_generic__"}'"%,
        m%"'{"names":["input-evdev-rs.so.11"],"symbols":[%{getInputSyms  "input_evdev_rs__"}],"prefix":"input_evdev_rs__"}'"%,
        m%"'{"names":["input-evdev.so.11"],"symbols":[%{getInputSyms  "input_evdev__"}],"prefix":"input_evdev__"}'"%,
        m%"'{"names":["graphics-atomic-kms.so.24"],"symbols":[%{getDSyms  "graphics_atomic_kms__"}],"prefix":"graphics_atomic_kms__"}'"%,
        m%"'{"names":["graphics-gbm-kms.so.24"],"symbols":[%{getGDSyms  "graphics_gbm_kms__"}],"prefix":"graphics_gbm_kms__"}'"%,
        m%"'{"names":["graphics-wayland-kms.so.24"],"symbols":[%{getInputSyms  "graphics_wayland__"},%{getDSyms  "graphics_wayland__"}],"prefix":"graphics_wayland__"}'"%,
      ]
      in
      [
        # m%"sed -i 's@add_subdirectory(tests/)@@g' ${SRC}/CMakeLists.txt"%,

        # m%"sed -i 's@uint@unsigned int@g' ${SRC}/miracle-wm-config/include/miracle/miracle-wm-config-c.h"%,
        # # m%"sed -i 's@uint@unsigned int@g' ${SRC}/miracle-wm-config/include/miracle/miracle-wm-config-c.cpp"%,
        # m%"sed -i 's@uint@unsigned int@g' ${SRC}/miracle-wm-config/include/miracle/miracle-wm-config.h"%,
        # # m%"sed -i 's@uint@unsigned int@g' ${SRC}/miracle-wm-config/include/miracle/miracle-wm-config.cpp"%,
        # m%"sed -i 's@uint@unsigned int@g' ${SRC}/miracle-wm-config/include/miracle/keyboard.h"%,
        # m%"sed -i 's@uint@unsigned int@g' ${SRC}/miracle-wm-config/include/miracle/modifiers.h"%,

        # m%"sed -i 's@uint@unsigned int@g' ${SRC}/src/config.h"%,

        # m%"sed -i 's@uint@unsigned int@g' ${SRC}/tests/test_leaf_container.cpp"%,
        # "sed -i 's@-lpcre2-16 -lpcre2-32@@g' ${SRC}/CMakeLists.txt",
        m%"sed -i "s@#include <stdlib.h>@#include <sys/types.h>\n#include <stdlib.h>@g" ${SRC}/miracle-wm-c/include/miracle/config.h"%,
        m%"sed -i "s@#include <cstdlib>@#include <cstdlib>\n#include <sys/types.h>@g" ${SRC}/miracle-wm-c/include/miracle/cpp/modifiers.h"%,
        m%"sed -i 's@SHARED@STATIC@g' ${SRC}/miracle-wm-c/CMakeLists.txt ${SRC}/CMakeLists.txt"%,
        m%"dl-func '{"names":["liblttng-ust-tracepoint.so.1"],"symbols":["ltt_probe_register",%{std.string.join "," lu}]}' '{"names":["liblttng-ust.so.1"],"symbols":[]}' %{std.string.join " " libs}> ${SRC}/dlopen.c"%,
        "${CC} ${CFLAGS} -Werror -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
        lib.functions.writeFile "${SRC}/obj.c" "__attribute__((weak)) void* ltt_probe_register = 0;\n",
        "${CC} ${CFLAGS} -Werror -c ${SRC}/obj.c -o ${SRC}/obj.o",
      ],
    generator = "Ninja",
    biDrvs = [
      drvs.pcre2cmake,
      drvs.pythonDlFunc,
      drvs.pythonFull,
    ],
    neverInclude = [
      drvs.pcre2,
    ],

    pDrvs = [
      # drvs.mesa2,
      # drvs.elogindWithPolkit,
      # drvs.boost,
      drvs.mir,
      drvs.nlohmannJsonCmake,
      drvs.googletest,
      drvs.jsonC,
    ],

    llvmProvider = drvs.llvmFull,
    muslProvider = if debug then drvs.muslBothRenamedDlDebug else drvs.muslBothRenamedDl,
  }
}
& {
  lib,
  drvs,
  glm102 | lib.CmakePackage = {
    singleSource = {
      uri = "https://github.com/g-truc/glm/archive/refs/tags/1.0.2.tar.gz",
      sha256sum = "19edf2e860297efab1c74950e6076bf4dad9de483826bc95e2e0f2c758a43f65"
    },
    generator = "Ninja",
  }
}
& {
  lib,
  drvs,
  lttngUst | lib.AutotoolsPackage = {
    debug = true,
    singleSource = {
      # uri = "https://lttng.org/files/lttng-ust/lttng-ust-2.15.1.tar.bz2",
      # sha256sum = "37c9b58ea7aa7bc47d6630b52ba1a48ebce095b9a196eab4ddd273d78301792d",
      uri = "https://lttng.org/files/lttng-ust/lttng-ust-2.14.3.tar.bz2",
      sha256sum = "3c232b514f33c4248ce23155f64ad272fdaae3323255f69d5e7a5c3d6812b7ea",
    },
    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.pkgconfMeson,
      drvs.popt,
      drvs.libxml2,
      drvs.liburcu,
      drvs.muslShared,
      drvs.linuxHeaders,
    ],
    # separateBuildDir = false,
    isStatic = false,
    buildEnv._isStatic = false,
    enableParallel = false,
    configureFlags = [
      #     "--enable-shared=yes",
      "--prefix=/usr",
      "--disable-numa",
      "--disable-examples",
      "--disable-python-agent",
      "--enable-static",
      "--disable-shared",
    ],
    buildPhase = [
      "make",
      "make -C src/lib/lttng-ust-common V=1",
      "make DESTDIR=${DEST} install",
    ],
    installPhase = [],
    # patches = [
    #   {
    #     sha256sum = "87707ee9f7ceea41b4993c15174a53f4acac73ca8b747f26abd7d0a4f6b67ce5",
    #     file =  "ng-no-tests.patch"
    #   }
    # ],
    preConfigurePhase = [
      #   "sed -i 's@cd tests@echo true#@g' ${SRC}/Makefile.am",
      #   "sed -i 's@tests@@g' ${SRC}/Makefile.am",

      #     "sed -i 's@cd tests@echo true#@g' ${SRC}/Makefile.in",
      #   "sed -i 's@tests@@g' ${SRC}/Makefile.in",
      lib.functions.writeFile "${SRC}/tests/Makefile.in" (import "Makefile" as 'Text),
      lib.functions.writeFile "${SRC}/tests/Makefile.am" (import "Makefile" as 'Text),
      m%"sed -i 's|if test "$enable_shared" = no|if test "$enable_shared" = yes|g' ${SRC}/configure"%,
      m%"sed -i 's|if test "$enable_static" = yes|if test "$enable_static" = no|g' ${SRC}/configure"%,
    ],

    #separateBuildDir = false,
  }
}
& {
  lib,
  drvs,
  lttngTools | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://lttng.org/files/lttng-tools/lttng-tools-2.14.3.tar.bz2",
      sha256sum = "473ebcf26cae02860ee23e7cbf4ec875586017bd06f32613ba21b6586420e2ed"
    },
    biDrvs = [
      drvs.pkgconf,
      drvs.popt,
      drvs.libxml2,
      drvs.liburcu,
    ],
  }
}
& {
  lib,
  drvs,
  lttngModules | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://lttng.org/files/lttng-modules/lttng-modules-2.14.3.tar.bz2",
      sha256sum = "35a1875ad96e8b4b6aa8729f59af350bfc788ba65c6856deaa84d33acc0f28c2"
    },
    biDrvs = [
      drvs.pkgconf,
    ],
  }
}
& {
  lib,
  drvs,
  liburcu | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://lttng.org/files/urcu/userspace-rcu-0.14.3.tar.bz2",
      sha256sum = "bdcbf18ed37911f489851aa80e98b8d5bc565b329ee2fb66c11ee7a019f43aa0"
    }
  }
}
