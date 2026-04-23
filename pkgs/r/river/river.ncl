{
  lib,
  drvs,
  river | lib.Package = {
    singleSource = {
      uri = "https://codeberg.org/river/river/releases/download/v0.4.2/river-0.4.2.tar.gz",
      sha256sum = "f1878c2468ed607163d0b362f7d1056271f1729c38a8178c58f904c2c73ce2d3",
    },
    sourceInputs = [
      {
        src = singleSource
      },
      {
        src = {
          uri = "https://codeberg.org/ifreund/zig-pixman/archive/v0.3.0.tar.gz",
          sha256sum = "cd7fe3415d4d58685a94fdedd308e9994a37f012828940cfb603461de7f2c6ad"
        },
        dest = "home/.cache/zig/p/pixman-0.3.0-LClMnz2VAAAs7QSCGwLimV5VUYx0JFnX5xWU6HwtMuDX"
      },
      {
        src = {
          uri = "https://codeberg.org/ifreund/zig-wayland/archive/v0.5.0.tar.gz",
          sha256sum = "fa9705e83613b5555d7117ce5c602f10591d6598e69a73fba2e6039200db4f4b"
        },
        dest = "home/.cache/zig/p/wayland-0.5.0-lQa1knz8AQCh08NA8BeQrwJB9U3CfqcVAdHZYGRKIGuu"
      },
      {
        src = {
          uri = "https://codeberg.org/ifreund/zig-wlroots/archive/v0.20.0.tar.gz",
          sha256sum = "75af3510386c639582693d01788579abde4dca9ce1ae6703c1e877ec8123d106",
        },
        dest = "home/.cache/zig/p/wlroots-0.20.0-jmOlcmtCBADS6eoJ6mkeiSNZkibrhD-c5Qwn-LiM86r1"
      },
      {
        src = {
          uri = "https://codeberg.org/ifreund/zig-xkbcommon/archive/v0.4.0.tar.gz",
          sha256sum = "e6df77d511cf9402f6ac08455c8d1fb727b6c3d66191e246671f62e5db083c49"
        },
        dest = "home/.cache/zig/p/xkbcommon-0.4.0-VDqIe0i2AgDRsok2GpMFYJ8SVhQS10_PI2M_CnHXsJJZ"
      },
    ],
    separateBuildDir = false,

    buildEnv = {
      EXTRA_CPPFLAGS = [
        "-I/usr/include/wlroots-0.20"
      ],
      EXTRA_LDFLAGS = [
        "$(pkg-config --libs --static wlroots-0.20)",
      ],
    },

    buildPhase =
      let repl = "river.root_module.omit_frame_pointer = omit_frame_pointer;" in
      [
        # m%"sed -i "s@%{repl}@%{repl}\nriver.root_module.addArgs\(\&.\{\"-Wl,--allow-mutiple-definitions\"\}\);@g" ${SRC}/build.zig"%,
        # m%"sed -i "s@%{repl}@%{repl}\nriver.root_module.addFlag\(\&.\{\"-Wl,--allow-mutiple-definitions\"\}\);@g" ${SRC}/build.zig"%,

        # m%"sed -i 's|"-O2"|"-O2", "-Wl,--allow-mutiple-definitions"|g' ${SRC}/build.zig"%,
        # m%"sed -i "s@.strip = strip,@.strip = strip,\n.flags = \&.{ \"-Wl,--allow-mutiple-definitions\" }@g" ${SRC}/build.zig"%,
        (
          let
            old = m%"river.root_module.linkSystemLibrary(\"libevdev\", .{});"%,
            new = std.string.join m%"\\n"% (std.array.map (fun s => m%"river.root_module.linkSystemLibrary(\"%{s}\", .{});"%) ["libdrm", "libcap", "c++"])
          in
          m%"sed -i "s@%{old}@%{new}\n%{old}@g" ${SRC}/build.zig"%
        ),
        # "mkdir home",
        "export HOME=$(pwd)/home",
        "zig build -h",
        # m%"DESTDIR="${DEST}" zig build --prefix /usr install"%
        (
          let args =
            std.string.join
              " "
              [
                # "-Dtarget=x86_64-linux-musl",
                # "--sysroot /",
                # "--search-prefix /",
                "--verbose",
                # "--verbose-cc",
                "--verbose-link",
                "--prefix /usr"
              ]
          in
          m%"DESTDIR="${DEST}" zig build %{args} install"%
        ),
      ],

    biDrvs =
      [
        drvs.zig,
        # drvs.llvmAllTargets,
        drvs.llvmFull,
        drvs.musl,
        # drvs.linuxHeaders,
        drvs.ccacheBin,
        drvs.pkgconfMeson,
      ]
      @ [
        drvs.expat,
        drvs.jsonC,
        drvs.pcre2,
        drvs.mesa2River,
        drvs.spirvTools,
        drvs.wayland,
        drvs.waylandProtocols,
        drvs.libelf,
        drvs.libpciaccess,
        drvs.libdrm,
        drvs.libxkbcommon,
        drvs.pixman,
        drvs.eudevRiver & { priority = 1 },
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
        drvs.gdkPixbufFull,
        drvs.libjpegTurbo,
        drvs.basu,
        drvs.lcms,
        drvs.scdoc,
        drvs.openssl,
        drvs.xcbUtilWm,
        drvs.wlroots20,
      ],

    propagatedBuildInputs = [
      drvs.seatd,
    ],
  },
  mesa2,
  mesa2River | lib.MesonPackage =
    mesa2
    & {
      postInstallPhase | priority 2 =
        (
          std.array.map
            (fun s => "objcopy --redefine-sym=%{s}=%{s}_egl ${DEST}/usr/lib/libEGL.a"
            )
            [
              "call_once",
              "cnd_broadcast",
              "cnd_destroy",
              "cnd_init",
              "cnd_signal",
              "cnd_timedwait",
              "cnd_wait",
              "mtx_destroy",
              "mtx_init",
              "mtx_lock",
              "mtx_timedlock",
              "mtx_unlock",
              "thrd_create",
              "thrd_join",
            ]
        )
        @ [
          "sed -i 's| -lm| -lm -lc++|g' ${DEST}/usr/lib/pkgconfig/egl.pc",
        ]
    },
  eudev,
  eudevRiver | lib.AutotoolsPackage =
    eudev
    & {
      postInstallPhase =
        (
          std.array.map
            (fun s => "objcopy --redefine-sym=%{s}=%{s}_udev ${DEST}/usr/lib/libudev.a"
            )
            [
              "uint64_hash_ops",
              "hashmap_put",
              "set_put",
              "hashmap_replace",
              "hashmap_update",
              "hashmap_get2",
              "hashmap_remove2",
              "set_merge",
              "set_consume",
              "mempool_alloc_tile",
              "mempool_alloc0_tile",
              "mempool_free_tile",
              "siphash24",
            ]
        )
        @ [
          #"sed -i 's|-ludev|-Wl,--allow-mutiple-definitions -ludev|g' ${DEST}/usr/lib/pkgconfig/libudev.pc",
        ]
    }
}
