{
  lib,
  drvs,
  distro,
  aquamarine | lib.CmakePackage =
    let _p | lib.CmakePackage = {
      generator = "Ninja",
      singleSource = {
        #uri = "https://github.com/hyprwm/aquamarine/archive/refs/tags/v0.5.0.tar.gz",
        #sha256sum = "30ced616ce5c2f1b83a0c4807637589157af5ba98e7956f0e6168d5724f5b62c",

        #uri = "https://github.com/hyprwm/aquamarine/archive/refs/tags/v0.7.2.tar.gz",
        #sha256sum = "822ce38345bc4c1b95966c79ee72ff18d753aa923c83e9aa64e9d82eebf55a38"

        # uri = "https://github.com/hyprwm/aquamarine/archive/refs/tags/v0.9.2.tar.gz",
        # sha256sum = "ffcaa394ad12920ee50e4a7872e4e27d35426b03fadd21de92578d7ff4908f46",

        uri = "https://github.com/hyprwm/aquamarine/archive/refs/tags/v0.9.5.tar.gz",
        sha256sum = "657e4752542872549a556d9facb8a525276b4edd5ca197818835904768aaad40",
      },
      llvmProvider = drvs.llvmFull,
      options = {
        glx = false,
      },

      biDrvs =
        [
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
          drvs.hyprUtils,
          drvs.libzip,
          drvs.spirvTools,
        ]
        @ (
          if options.glx then
            [
              drvs.mesaGlx,
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
              drvs.xcbUtilErrors,
              drvs.libxext,
              drvs.libxf86vm,
              drvs.libxrandr,
            ]
          else
            [
              drvs.mesa2
            ]
        ),

      propagatedBuildInputs = [
        drvs.seatd,
      ],
      preConfigurePhase = [
        m%"
          sed -i \
            's@OpenGL::OpenGL@OpenGL::GLES2@g' \
            ${SRC}/CMakeLists.txt

          "%,
        m%"
        sed -i \
          's@aquamarine SHARED@aquamarine STATIC@g' \
          ${SRC}/CMakeLists.txt
        "%,
      ],
      postInstallPhase = [
        # fix duplicate symbols wit hyprland
        # https://unix.stackexchange.com/questions/181363/deleting-a-file-object-from-a-library
        #"ar dv ${DEST}/usr/lib/libaquamarine.a wayland.cpp.o",
        #"ar dv ${DEST}/usr/lib/libaquamarine.a Wayland.cpp.o",

        #"ar dv ${DEST}/usr/lib/libaquamarine.a linux-dmabuf-v1.cpp.o",
        #"ar dv ${DEST}/usr/lib/libaquamarine.a xdg-shell.cpp.o",

        #  "cp -r ${SRC}/protocols ${DEST}/usr/include/aquamarine/protocols"
        "objcopy -W wl_callback_interface ${DEST}/usr/lib/libaquamarine.a",
        "objcopy -W wl_registry_interface ${DEST}/usr/lib/libaquamarine.a",
        "objcopy -W wl_buffer_interface ${DEST}/usr/lib/libaquamarine.a",
        "objcopy -W wl_compositor_interface ${DEST}/usr/lib/libaquamarine.a",
        "objcopy -W wl_data_device_interface ${DEST}/usr/lib/libaquamarine.a",
        "objcopy -W wl_data_device_manager_interface ${DEST}/usr/lib/libaquamarine.a",
        "objcopy -W wl_data_offer_interface ${DEST}/usr/lib/libaquamarine.a",
        "objcopy -W wl_data_source_interface ${DEST}/usr/lib/libaquamarine.a",
        "objcopy -W wl_display_interface ${DEST}/usr/lib/libaquamarine.a",
        "objcopy -W wl_keyboard_interface ${DEST}/usr/lib/libaquamarine.a",
        "objcopy -W wl_pointer_interface ${DEST}/usr/lib/libaquamarine.a",
        "objcopy -W wl_region_interface ${DEST}/usr/lib/libaquamarine.a",
        "objcopy -W wl_seat_interface ${DEST}/usr/lib/libaquamarine.a",
        "objcopy -W wl_shell_interface ${DEST}/usr/lib/libaquamarine.a",
        "objcopy -W wl_shell_surface_interface ${DEST}/usr/lib/libaquamarine.a",
        "objcopy -W wl_shm_pool_interface ${DEST}/usr/lib/libaquamarine.a",
        "objcopy -W wl_subsurface_interface ${DEST}/usr/lib/libaquamarine.a",
        "objcopy -W wl_surface_interface ${DEST}/usr/lib/libaquamarine.a",
        "objcopy -W wl_touch_interface ${DEST}/usr/lib/libaquamarine.a",
        "objcopy -W wl_output_interface ${DEST}/usr/lib/libaquamarine.a",
        "objcopy -W wl_shm_interface ${DEST}/usr/lib/libaquamarine.a",
        "objcopy -W wl_subcompositor_interface ${DEST}/usr/lib/libaquamarine.a",
        "objcopy -W xdg_popup_interface ${DEST}/usr/lib/libaquamarine.a",
        "objcopy -W xdg_positioner_interface ${DEST}/usr/lib/libaquamarine.a",
        "objcopy -W xdg_surface_interface ${DEST}/usr/lib/libaquamarine.a",
        "objcopy -W xdg_toplevel_interface ${DEST}/usr/lib/libaquamarine.a",
        "objcopy -W xdg_wm_base_interface ${DEST}/usr/lib/libaquamarine.a",
        "objcopy -W zwp_linux_buffer_params_v1_interface ${DEST}/usr/lib/libaquamarine.a",
        "objcopy -W zwp_linux_dmabuf_feedback_v1_interface ${DEST}/usr/lib/libaquamarine.a",
        "objcopy -W zwp_linux_dmabuf_v1_interface ${DEST}/usr/lib/libaquamarine.a",
        "objcopy -W wl_fixes_interface ${DEST}/usr/lib/libaquamarine.a",
      ],
      buildEnv =
        if options.glx then
          {
            EXTRA_LDFLAGS = ["$(pkg-config --libs --static gbm glesv2 egl dri wayland-client)"],
          }
        else
          {
            EXTRA_LDFLAGS = (if distro.pam then ["-lcap"] else []),
            #EXTRA_CXXFLAGS = [ "-I/usr/include/aquamarine/protocols"],
            #EXTRA_CPPFLAGS = [ "-I/usr/include/aquamarine/protocols"],
            #EXTRA_CPPFLAGS=["-DXDG_POSITIONER_INTERFACE","-DXDG_SURFACE_INTERFACE","-DHYPRWAYLAND_SCANNER_NO_INTERFACES"],
            #EXTRA_CXXFLAGS=EXTRA_CPPFLAGS,
          },
      cmakeExtraArgsRecord =
        if options.glx then
          {
            "-DBUILD_TESTING" = false,
          }
        else
          {},
    }
    in
    _p
    & {
      options,
      buildPhase =
        if options.glx then
          [
            "ninja libaquamarine.a",
          ]
        else
          _p.buildPhase
    },
  aquamarineGlx | lib.CmakePackage = aquamarine & { options = { glx | priority 1 = true } }
}
