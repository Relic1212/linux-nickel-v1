{
  lib,
  drvs,
  river | lib.ZigPackage = {
    singleSource = {
      uri = "https://codeberg.org/river/river/archive/v0.4.4.tar.gz",
      sha256sum = "2229ab9096e667ac859c63960f3e51a0713bb314555f92401c8ee7b88c79a1f7",
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
          uri = "https://codeberg.org/ifreund/zig-wayland/archive/4a150a04f76f7329e80280661355c04328369d1f.tar.gz",
          sha256sum = "5419193ec683344776120a32233fd732116cf4165685af89628a1644c480d1a8"
        },
        dest = "home/.cache/zig/p/wayland-0.6.0-dev-lQa1krD8AQBlMqwuhAMJjPQKXvpRByZBxxqMVAZ7yzbG"
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
      {
        src = {
          uri = "https://codeberg.org/ifreund/translate-c/archive/fdf30e6298cd1184ae6da5602aff0cb5d4cde4cb.tar.gz",
          sha256sum = "94d6227f4ac3834e384a35a6d38462de1ce353ea681c04145bd7c5b2112d6998"
        },
        dest = "home/.cache/zig/p/translate_c-0.0.0-Q_BUWrT0BgDOFSyiz0UVBIpBe3-CiEqx9ej2EecgKcBD"
      },
      {
        src = {
          uri = "https://github.com/Vexu/arocc/archive/5f5a050569a95ecc40a426f0c3666ae7ef987ede.tar.gz",
          sha256sum = "e20b49a13049e8ef5aa1d798a70d8fc02b691fe44c7c78928aae3d363a1deb7e"
        },
        dest = "zig-pkg/aro-0.0.0-JSD1Qi7QNgDnfcrdEJf82v3o6MhZySjYVrtdfEf3E4Se",
      }
    ],

    buildEnv = {
      EXTRA_CPPFLAGS = [
        "-I/usr/include/wlroots-0.20"
      ],
      EXTRA_LDFLAGS = [
        "$(pkg-config --libs --static wlroots-0.20)",
      ],
    },
    zigArgs = [
      # "-Dtarget=x86_64-linux-musl",
      "-Dtarget=native-native-musl",
      "--libc libc.txt",
      # "--sysroot /",
      # "--search-prefix /",
      "--verbose",
      "--debug-log",
      "--debug-pkg-config",
      "--verbose-cc",
      "--verbose-link",
      # "--prefix /usr"
      # "--system /tmp/workdir/src/deps/p",
    ],
    unpackPhase =
      [
        "export SRC=/tmp/workdir/src",
        "(cd ${SRC} && tar xf /tmp/workdir/packed/%{(std.array.at 0 sourceInputs).src.sha256sum}/*.tar.gz --strip-components=1)",
        "mkdir -p ${SRC}/deps/p",
        "mkdir -p ${SRC}/home/.cache/zig/p",
      ]
      @ (
        std.array.map
          (fun src =>
            let
              fn = let l = (std.string.split "/" src.dest) in "%{(std.array.last  l)}.tar.gz",
              sha = src.src.sha256sum
            in
            "cp $(find /tmp/workdir/packed/%{sha}/ -type f) ${SRC}/home/.cache/zig/p/%{fn}"
          )
          (std.array.drop_first sourceInputs)
      ),

    preConfigurePhase =
      # let repl = "river.root_module.omit_frame_pointer = omit_frame_pointer;" in
      [
        # m%"sed -i "s@%{repl}@%{repl}\nriver.root_module.addArgs\(\&.\{\"-Wl,--allow-mutiple-definitions\"\}\);@g" ${SRC}/build.zig"%,
        # m%"sed -i "s@%{repl}@%{repl}\nriver.root_module.addFlag\(\&.\{\"-Wl,--allow-mutiple-definitions\"\}\);@g" ${SRC}/build.zig"%,

        # m%"sed -i 's|"-O2"|"-O2", "-Wl,--allow-mutiple-definitions"|g' ${SRC}/build.zig"%,
        # m%"sed -i "s@.strip = strip,@.strip = strip,\n.flags = \&.{ \"-Wl,--allow-mutiple-definitions\" }@g" ${SRC}/build.zig"%,
        (
          let
            old = m%"river.root_module.linkSystemLibrary(\"libevdev\", .{});"%,
            new = std.string.join m%"\\n"% (std.array.map (fun s => m%"river.root_module.linkSystemLibrary(\"%{s}\", .{});"%) ["libdrm", "libcap", "c++", "tls"])
          in
          m%"sed -i "s@%{old}@%{new}\n%{old}@g" ${SRC}/build.zig"%
        ),
        # m%"sed -i 's@@@g' river/c.h"%
        "zig libc > libc.txt",
        "sed -i 's@/usr/include@/usr/river/include@' libc.txt",
        # "mkdir home",
        # "export HOME=$(pwd)/home",
        # "echo HOME=$HOME",
        "zig build -h",
        # "zig build --system /tmp/workdir/src/deps/p -h",
        # m%"DESTDIR="${DEST}" zig build --prefix /usr install"%
        # (
        #   let args =
        #     std.string.join
        #       " "
        #       [
        #         # "-Dtarget=x86_64-linux-musl",
        #         # "--sysroot /",
        #         # "--search-prefix /",
        #         "--verbose",
        #         # "--verbose-cc",
        #         "--verbose-link",
        #         "--prefix /usr"
        #       ]
        #   in
        #   m%"DESTDIR="${DEST}" zig build %{args} install"%
        # ),
      ],
    llvmProvider = drvs.llvmFull,
    biDrvs =
      [
        # drvs.zig,
        # # drvs.llvmAllTargets,
        # drvs.llvmFull,
        # drvs.musl,
        # # drvs.linuxHeaders,
        # drvs.ccacheBin,
        # drvs.pkgconfMeson,
      ]
      @ [
        drvs.includeSymlink,
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
        drvs.libtlsModuleBase,
      ],

    propagatedBuildInputs = [
      drvs.seatd,
    ],
  },
  libtlsModuleBase | lib.Package = {
    enableCcache = false,
    buildPhase = [
      "echo 'int _TLS_MODULE_BASE_ = 0;' > tls.c",
      "${CC} ${CFLAGS} -c tls.c -o tls.o",
      "ar rcs libtls.a tls.o",
      "ranlib libtls.a",
    ],
    installPhase = [
      "install -dm0755 ${DEST}/usr/lib",
      "install -m0755 libtls.a ${DEST}/usr/lib",
    ],
    biDrvs = [
      drvs.llvm,
    ]
  },
  includeSymlink | lib.Package = {
    installPhase = [
      "install -dm0755 ${DEST}/usr/river",
      "cd ${DEST}/usr/river",
      "ln -s ../include include",
    ]
  },
  mesa2,
  mesa2River | lib.MesonPackage =
    mesa2
    & {
      postInstallPhase | priority 2 =
        (
          std.array.map
          # (fun s => "objcopy --redefine-sym=%{s}=%{s}_egl ${DEST}/usr/lib/libEGL.a" )
            (fun s => "objcopy -W %{s} ${DEST}/usr/lib/libEGL.a")
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
