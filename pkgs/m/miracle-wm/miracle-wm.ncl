{
  lib,
  drvs,
  miracleWm | lib.CmakePackage = {
    singleSource = {
      uri = "https://github.com/miracle-wm-org/miracle-wm/archive/refs/tags/v0.6.2.tar.gz",
      sha256sum = "f10f9c0bf03b815a15265171d4926221e45fe0ca2e997d31f69ba34a3839a2b3"
    },

    patches = [
      {
        sha256sum = "d7e22201d8afeee1c17e9b2999462757e39a7414bfee46a20ffb0d14f11b7abf",
        file = "miracle-wm.patch",
      }
    ],

    buildEnv = {
      EXTRA_CPPFLAGS = ["-D_GNU_SOURCE"],
      EXTRA_CXXFLAGS = [
        "-D_GNU_SOURCE",
      ]
      # @ EXTRA_LDFLAGS
      ,

      EXTRA_LDFLAGS = [
        "-l:input-evdev.a",
        "-l:libmircommon.a",
        "-l:libmiroil.a",
        "-l:libmirserver.a",
        "-l:libmirwayland.a",
        "-l:renderer-egl-generic.a",
        "-l:libmiral.a",
        "-l:libmircore.a",
        "-l:libmirplatform.a",
        "-l:libmirserverlttng.a",
        "-l:server-virtual.a",

        #     "-l:libboost_atomic.a",
        # "-l:libboost_charconv.a",
        # "-l:libboost_chrono.a",
        # "-l:libboost_container.a",
        # "-l:libboost_context.a",
        # "-l:libboost_contract.a",
        # "-l:libboost_coroutine.a",
        # "-l:libboost_date_time.a",
        "-l:libboost_exception.a",
        # "-l:libboost_fiber.a",
        # "-l:libboost_filesystem.a",
        # "-l:libboost_graph.a",
        # "-l:libboost_iostreams.a",
        # "-l:libboost_json.a",
        # "-l:libboost_locale.a",
        # "-l:libboost_log.a",
        # "-l:libboost_log_setup.a",
        # "-l:libboost_math_c99.a",
        # "-l:libboost_math_c99f.a",
        # "-l:libboost_math_c99l.a",
        # "-l:libboost_math_tr1.a",
        # "-l:libboost_math_tr1f.a",
        # "-l:libboost_math_tr1l.a",
        # "-l:libboost_nowide.a",
        # "-l:libboost_prg_exec_monitor.a",
        # "-l:libboost_process.a",
        "-l:libboost_program_options.a",
        # "-l:libboost_python312.a",
        # "-l:libboost_random.a",
        # "-l:libboost_regex.a",
        # "-l:libboost_serialization.a",
        # "-l:libboost_stacktrace_basic.a",
        # "-l:libboost_stacktrace_from_exception.a",
        # "-l:libboost_stacktrace_noop.a",
        # "-l:libboost_system.a",
        # "-l:libboost_test_exec_monitor.a",
        # "-l:libboost_thread.a",
        # "-l:libboost_timer.a",
        # "-l:libboost_type_erasure.a",
        # "-l:libboost_unit_test_framework.a",
        # "-l:libboost_url.a",
        # "-l:libboost_wave.a",
        # "-l:libboost_wserialization.a",
        "-lxkbcommon",
        "-lglib-2.0",
        "-lfreetype",
        "$(pkg-config --static --libs xkbcommon mirserver miral xcb wayland-client wayland-server)",
      ]
    },

    preConfigurePhase = [
      m%"sed -i 's@add_subdirectory(tests/)@@g' ${SRC}/CMakeLists.txt"%,

      # m%"sed -i 's@uint@unsigned int@g' ${SRC}/miracle-wm-config/include/miracle/miracle-wm-config-c.h"%,
      # # m%"sed -i 's@uint@unsigned int@g' ${SRC}/miracle-wm-config/include/miracle/miracle-wm-config-c.cpp"%,
      # m%"sed -i 's@uint@unsigned int@g' ${SRC}/miracle-wm-config/include/miracle/miracle-wm-config.h"%,
      # # m%"sed -i 's@uint@unsigned int@g' ${SRC}/miracle-wm-config/include/miracle/miracle-wm-config.cpp"%,
      # m%"sed -i 's@uint@unsigned int@g' ${SRC}/miracle-wm-config/include/miracle/keyboard.h"%,
      # m%"sed -i 's@uint@unsigned int@g' ${SRC}/miracle-wm-config/include/miracle/modifiers.h"%,

      # m%"sed -i 's@uint@unsigned int@g' ${SRC}/src/config.h"%,

      # m%"sed -i 's@uint@unsigned int@g' ${SRC}/tests/test_leaf_container.cpp"%,
      "sed -i 's@-lpcre2-16 -lpcre2-32@@g' ${SRC}/CMakeLists.txt"
    ],
    generator = "Ninja",

    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.basu,
      drvs.boost,
      drvs.cairo,
      drvs.eudev,
      drvs.expat,
      drvs.fontconfig,
      drvs.freetype,
      drvs.gdkPixbufFull,
      drvs.glib,
      drvs.glibmm,
      drvs.glm,
      drvs.gmp,
      drvs.harfbuzz,
      drvs.hwdata,
      drvs.jsonC,
      drvs.lcms,
      drvs.libdisplayinfo,
      drvs.libdrm,
      drvs.libelf,
      drvs.libepoxy,
      drvs.libevdev,
      drvs.libffi,
      drvs.libfontenc,
      drvs.libinput,
      drvs.libjpegTurbo,
      drvs.libpciaccess,
      drvs.libpng,
      drvs.libsigcpp2,
      drvs.liburcu,
      drvs.libx11,
      drvs.libxau,
      drvs.libxcb,
      drvs.libxcursor,
      drvs.libxcvt,
      drvs.libxfixes,
      drvs.libxfont2,
      drvs.libxkbcommon,
      drvs.libxkbfile,
      drvs.libxml2Cmake,
      drvs.libxmlplusplus,
      drvs.libxrender,
      drvs.libxshmfence,
      drvs.libyaml,
      drvs.linuxHeaders,
      drvs.lttngUst212,
      drvs.lua,
      drvs.mesa2,
      drvs.mir,
      drvs.mtdev,
      drvs.nlohmannJsonCmake,
      drvs.openssl,
      drvs.pango,
      drvs.pcre2,
      drvs.pixman,
      drvs.pythonFull,
      drvs.scdoc,
      drvs.seatd,
      drvs.spirvTools,
      drvs.tomlplusplus,
      drvs.utilLinux,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.xcbProto,
      drvs.xcbRenderutil,
      drvs.xcbUtilWm,
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.xtrans,
      drvs.xwayland,
      drvs.yamlCpp,
      drvs.zlibNg,
      drvs.googletest,
    ]
  }
}
& {
  lib,
  drvs,
  mir | lib.CmakePackage = {

    singleSource = {
      uri = "https://github.com/canonical/mir/archive/refs/tags/v2.23.0.tar.gz",
      sha256sum = "8c39b7f327d945b2c4680b1a0de7969ca3245a35c5eade1c39ff738325b412c0"
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
    singleSource = {
      uri = "https://lttng.org/files/lttng-ust/lttng-ust-2.14.0.tar.bz2",
      sha256sum = "82cdfd304bbb2b2b7d17cc951a6756b37a9f73868ec0ba7db448a0d5ca51b763",
    },
    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.pkgconf,
      drvs.popt,
      drvs.libxml2,
      drvs.liburcu,
      drvs.muslShared,
      drvs.linuxHeaders,
    ],
    isStatic = false,
    buildEnv._isStatic = false,
    enableParallel = false,
    configureFlags = [
      #     "--enable-shared=yes",
      "--prefix=/usr",
      "--disable-numa",
      "--disable-examples",
      "--disable-python-agent"
    ],
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
    ],

    #separateBuildDir = false,
  }
}
& {
  lib,
  drvs,
  lttngUst212 | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://lttng.org/files/lttng-ust/lttng-ust-2.12.10.tar.bz2",
      sha256sum = "aa802851c6d08c653ac1dd7da8f552baaa5d87e9b03c2d6a8b7a04322e53dc47"
    },

    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lurcu-bp"
      ]
    },

    biDrvs = [
      drvs.pkgconf,
      drvs.popt,
      drvs.libxml2,
      drvs.liburcu,
    ],
    extraConfigureFlags = [
      "--enable-shared=yes",
      "--disable-numa",
      "--disable-examples",
    ],

    preConfigurePhase = [
      #   m%"sed -i 's@if test "$enable_shared" = no@if test "$enable_shared" = yes@g' ${SRC}/configure"%,
    ]
  }
}
& {
  lib,
  drvs,
  lttngUst213 | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://lttng.org/files/lttng-ust/lttng-ust-2.13.9.tar.bz2",
      sha256sum = "2ad6d69a54a1d924c18a4aa7a233db104e3cc332bcdd240e196bf7adbed3f712"
    },

    biDrvs = [
      drvs.pkgconf,
      drvs.popt,
      drvs.libxml2,
      drvs.liburcu,
    ],
    extraConfigureFlags = [
      #     "--enable-shared=yes",
      "--disable-numa",
      "--disable-examples",
    ],

    preConfigurePhase = [
      m%"sed -i 's@if test "$enable_shared" = no@if test "$enable_shared" = yes@g' ${SRC}/configure"%,
    ]
  }
}
& {
  lib,
  drvs,
  lttngTools | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://lttng.org/files/lttng-tools/lttng-tools-2.14.0.tar.bz2",
      sha256sum = "d8c39c26cec13b7bd82551cd52a22efc358b888e36ebcf9c1b60ef1c3a3c2fd3"
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
      uri = "https://lttng.org/files/lttng-modules/lttng-modules-2.14.0.tar.bz2",
      sha256sum = "f2261e738b1dd1027640e5ba3040dee292241b847d5745766b3ba640e168c94a"
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
      uri = "https://lttng.org/files/urcu/userspace-rcu-0.15.3.tar.bz2",
      sha256sum = "26687ec84e3e114759454c884a08abeaf79dec09b041895ddf4c45ec150acb6d"
    }
  }
}
