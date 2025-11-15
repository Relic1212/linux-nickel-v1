{
  lib,
  drvs,
  xdgDesktopPortal | lib.MesonPackage = {
    options = {
      elogind | default = true
    },

    singleSource = {
      uri = "https://github.com/flatpak/xdg-desktop-portal/archive/refs/tags/1.20.3.tar.gz",
      sha256sum = "01d2a8ceaab06fa1d0638abe541dbb415a0a19be271d9669a93ec1640f87ea4a"
    },
    patches = [
      {
        file = "no-gst.patch",
        sha256sum = "4b2461cdc0310a097996021d4ef70d995aa345f3d8a27e3c613dd5c7af978a81"
      }
    ],

    extraMesonArgs = [
      "-Dtests=disabled",
      "-Dflatpak-interfaces=enabled",
      "-Dgudev=enabled",
      "-Dman-pages=enabled",
    ],

    # libcamera needs this
    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lc++"
      ],
    },

    preConfigurePhase =
      let syms = [
        "gvdb_table_free",
        "gvdb_table_get_names",
        "gvdb_table_get_raw_value",
        "gvdb_table_get_table",
        "gvdb_table_get_value",
        "gvdb_table_has_value",
        "gvdb_table_is_valid",
        "gvdb_table_list",
        "gvdb_table_new",
        "gvdb_table_new_from_bytes",
      ],
      in
      (
        std.array.map
          (fun s =>
            (
              m%"sed -i 's|%{s}|__xdg_document_portal__%{s}|g' ${SRC}/document-portal/gvdb/gvdb-reader.c"%
              ++ "\n"
              ++ m%"sed -i 's|%{s}|__xdg_document_portal__%{s}|g' ${SRC}/document-portal/gvdb/gvdb-reader.h"%
              ++ "\n"
              ++ m%"sed -i 's|%{s}|__xdg_document_portal__%{s}|g' ${SRC}/document-portal/permission-db.c"%
            )
          )
          syms
      ),

    biDrvs =
      [
        drvs.alsaLibs,
        drvs.appstream,
        drvs.atSpi2Core,
        drvs.bison,
        drvs.bubblewrap,
        drvs.cairo,
        drvs.curl,
        drvs.dbus,
        drvs.eudev,
        drvs.expat,
        drvs.fontconfig,
        drvs.freetype,
        drvs.fribidi,
        drvs.fuse,
        drvs.gdkPixbufFull,
        drvs.glib,
        drvs.gperf,
        drvs.gpgme,
        drvs.harfbuzz,
        drvs.hwdata,
        drvs.jsonGlib,
        drvs.kmod,
        drvs.libarchive,
        drvs.libassuan,
        drvs.libcap,
        drvs.libdrm,
        drvs.libelf,
        drvs.libepoxy,
        drvs.libevdev,
        drvs.libffi,
        drvs.libgpgError,
        drvs.libjpegTurbo,
        drvs.libopus,
        drvs.libpciaccess,
        drvs.libpng,
        drvs.libpsl,
        drvs.libsndfile,
        drvs.libxkbcommon,
        drvs.libxml2,
        drvs.libxmlb,
        drvs.libyaml,
        drvs.linuxHeaders,
        drvs.llvmConfigStatic,
        drvs.lua,
        drvs.lz4,
        drvs.m4,
        drvs.mesa2,
        drvs.ncurses,
        drvs.openssl,
        drvs.ostree,
        drvs.pango,
        drvs.pcre2,
        drvs.pipewire,
        drvs.pixman,
        drvs.readline,
        drvs.spirvLlvmTranslator,
        drvs.spirvTools,
        drvs.utilLinux,
        drvs.wayland,
        drvs.waylandProtocols,
        drvs.xdgDbusProxy,
        drvs.xz,
        drvs.zlibNg,
        drvs.zstd,
        drvs.gudev,
        drvs.libxslt,
        drvs.docutils,
        drvs.bluez,
        drvs.sbc,
        drvs.libusb,
        drvs.ffmpeg,
        drvs.jansson,
        drvs.libfreeaptx,
        drvs.fdkAac,
        drvs.ldacbt,
        drvs.flatpak,
      ]
      @ (
        if options.elogind then
          [
            drvs.elogindWithPolkit,
            drvs.polkit,
          ]
        else
          [
            drvs.basuUdevCompatible,
          ]
      ),
  }
}
