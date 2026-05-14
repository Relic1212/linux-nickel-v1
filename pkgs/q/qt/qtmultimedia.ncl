{
  lib,
  drvs,
  qtmultimedia | lib.QtPackage = {
    generator = "Ninja",

    buildEnv = {
      EXTRA_LDFLAGS = [
        "$(pkg-config --libs --static gbm glesv2 egl dri wayland-client glib-2.0 gmodule-2.0 expat)",
      ]
    },
    patches = [
      {
        sha256sum = "50a6a59f65477ee1c883333a4a47907cdb137f12534663865db1c9477cd5dace",
        file = "qtmultimedia.patch",
      },
    ],
    postInstallPhase =
      std.array.map
        (fun s => "llvm-objcopy --redefine-sym %{s}=qt6multimedia_private__%{s} ${DEST}/usr/lib/libQt6Multimedia.a")
        [
          "pw_check_library_version",
          "pw_context_connect_fd",
          "pw_context_connect",
          "pw_context_destroy",
          "pw_context_new",
          "pw_core_disconnect",
          "pw_deinit",
          "pw_get_library_version",
          "pw_init",
          "pw_properties_free",
          "pw_properties_new_dict",
          "pw_proxy_destroy",
          "pw_stream_add_listener",
          "pw_stream_connect",
          "pw_stream_dequeue_buffer",
          "pw_stream_destroy",
          "pw_stream_disconnect",
          "pw_stream_get_time_n",
          "pw_stream_new_simple",
          "pw_stream_new",
          "pw_stream_queue_buffer",
          "pw_stream_set_active",
          "pw_thread_loop_destroy",
          "pw_thread_loop_get_loop",
          "pw_thread_loop_in_thread",
          "pw_thread_loop_lock",
          "pw_thread_loop_new",
          "pw_thread_loop_signal",
          "pw_thread_loop_start",
          "pw_thread_loop_stop",
          "pw_thread_loop_timed_wait",
          "pw_thread_loop_unlock",
        ],
    # cmakeExtraArgsRecord = {
    #   "-DQT_DEBUG_FIND_PACKAGE" = "ON",
    #   # "-DCMAKE_MODULE_LINKER_FLAGS:STRING" = "\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -ldrm $(pkg-config --libs --static dri glesv2 gbm egl)\""
    #   "-DCMAKE_MODULE_LINKER_FLAGS:STRING" | priority 1 = "\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -ldrm $(pkg-config --libs --static dri glesv2 gbm egl wayland-client glib-2.0 gmodule-2.0 expat)\"",
    # },

    llvmProvider = drvs.llvmFull,

    pDrvs = [
      drvs.pipewire,
      # drvs.ffmpeg,
      drvs.qtwayland,

      # drvs.dbus,
      # drvs.alsaLibs,
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
      # drvs.glib,
      drvs.hwdata,
      # drvs.eudev,
      # drvs.kmod,
      # drvs.xz,
      # drvs.openssl,
      drvs.zstdCmake,
      # drvs.utilLinux,
      # drvs.libevdev,
      # drvs.libsndfile,
      # drvs.libopus,
      # drvs.lua,
      # drvs.bluez,
      # drvs.sbc,
      # drvs.libusb,
      # drvs.ffmpeg,
      # drvs.jansson,
      # drvs.fdkAac,
      # drvs.ldacbt,
      # # 
      # drvs.libyaml,
      # drvs.libxext, # needs X11/extensions/XShm.h
      drvs.libxrandr, # needs X11/extensions/Xrandr.h
    ],
  }
}
