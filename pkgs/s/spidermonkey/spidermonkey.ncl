{
  lib,
  drvs,
  spidermonkey | lib.Package = {
    singleSource = {
      uri = "https://archive.mozilla.org/pub/firefox/releases/140.10.1esr/source/firefox-140.10.1esr.source.tar.xz",
      sha256sum = "4e75c0c3e2c5530de9364de388272bf81b2b32209d98fa4a7eb50d268a17a5bb",
    },
    unpackPhase = [
      "tar xf /tmp/workdir/packed/%{singleSource.sha256sum}/firefox-*.source.tar.xz -C /tmp/workdir/src --strip-components=1",
    ],
    buildEnv = {
      PKG_CONFIG = null,
    },
    separateBuildDir = false,
    buildPhase =
      let mozconfig =
        std.string.join
          "\n"
          (
            [
              "ac_add_options --disable-bootstrap",
              "ac_add_options --disable-jemalloc",
              "ac_add_options --host=x86_64-unknown-linux-musl",
              "ac_add_options --target=x86_64-unknown-linux-musl",
            ]
            @ (
              std.array.map
                (fun s => "ac_add_options %{s}")
                [
                  # "--enable-project=js",
                  "--enable-application=js",
                  "--with-system-zlib",
                  # "--with-system-ffi",
                  "--with-system-icu",
                  "--disable-tests",
                  "--disable-shared-js",
                  "--disable-debug",
                  "--disable-debug-symbols",
                  "--enable-linker=lld",
                  "--prefix=/usr",
                  # "--disable-crashreporter",
                  "--without-intl-api",
                ]
            )
          )
      in
      [
        lib.functions.writeFile "mozconfig" mozconfig,
        "sed -i 's|when=link_libstdcxx_statically|when=target_is_windows|g' ${SRC}/build/moz.configure/flags.configure",
        "sed -i 's|PTHREAD_MUTEX_ADAPTIVE_NP|PTHREAD_MUTEX_NORMAL|g' ${SRC}/memory/build/Mutex.h",
        "sed -i 's|PTHREAD_ADAPTIVE_MUTEX_INITIALIZER_NP|PTHREAD_MUTEX_INITIALIZER|g' ${SRC}/memory/build/Mutex.h",
        "sed -i 's|checks.append(check_textrel)|# checks.append(check_textrel)|g' python/mozbuild/mozbuild/action/check_binary.py",
        "echo > config/gcc_hidden.h",
        m%"RUSTFLAGS="-C target-feature=+crt-static -C link-self-contained=yes -C link-arg=-static -C link-arg=--static""%,
        "export RUSTFLAGS",
        "export SCCACHE_DIR=/tmp/sccache",
        "export SCCACHE_CACHE_SIZE=100G",
        "export SCCACHE_SERVER_UDS=/tmp/sccache.sock",
        "export RUSTC_WRAPPER=/usr/bin/sccache",
        "export MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE=\"system\"",
        "mkdir home",
        "export HOME=$(pwd)/home",
        # "cd firefox-*",
        "./mach build",
      ],

    installPhase = [
      # "install -dm0755 ${DEST}/usr/lib/pkgconfig",
      # "install -dm0755 ${DEST}/usr/bin",
      # "install -m0755 obj-x86_64-unknown-linux-musl/js/src/build/js-config ${DEST}/usr/bin",
      # "install -m0755 obj-x86_64-unknown-linux-musl/js/src/build/js.pc ${DEST}/usr/lib/pkgconfig",
      # "install -m0755 obj-x86_64-unknown-linux-musl/js/src/build/libjs_static.pc ${DEST}/usr/lib",
      "make DESTDIR=${DEST} -C obj-x86_64-unknown-linux-musl install",
      "install -dm0755 ${DEST}/usr/lib/moz-obj",
      "for f in $(find obj-x86_64-unknown-linux-musl -name '*.o'|grep -v conftest);do install -m0755 ${f} ${DEST}/usr/lib/moz-obj;done",
      "install -dm0755 ${DEST}/usr/lib/moz-libs",
      "for f in $(find obj-x86_64-unknown-linux-musl -name '*.a');do install -m0755 ${f} ${DEST}/usr/lib/moz-libs;done",
    ],

    biDrvs = [
      drvs.pythonDynamicCurses,
      drvs.muslShared,
      drvs.llvmFull,
      drvs.musl,
      drvs.pyyaml,
      drvs.pkgconfMeson,
      drvs.rust,
      drvs.cbindgen,
      drvs.gnumake,
      drvs.sccache,
      drvs.linuxHeaders,
    ],
    pDrvs = [
      drvs.zstd,
      drvs.alsaLibs,
      drvs.zlibNg,
      drvs.libffi,
      drvs.libicu,
    ],
  },
  spidermonkeySymlinks | lib.Package = {
    installPhase = [
      "install -dm0755 ${DEST}/usr/lib",
      "cd ${DEST}/usr/lib",
      "ln -s libjs_static.ajs libmozjs-140.a",
    ]
  },
  libmozjs | lib.Package = {
    biDrvs = [
      drvs.llvm,
      drvs.spidermonkey,
    ],
    # find build/tmp/spidermonkey/src/obj-x86_64-unknown-linux-musl/ -name '*.o' |grep -v conftest | rev | cut -d '/' -f1 | rev |sort | xargs printf "\"%s\",\n"
    buildPhase =
      let objs = (import "objs.ncl")
      in
      [
        "ar x /usr/lib/moz-libs/libjsrust.a",
        "ar rcs libmozjs-140.a %{ std.string.join " " (std.array.map (fun s=> "/usr/lib/moz-obj/%{s}") objs) } *.o",
        "ranlib libmozjs-140.a",
        "install -dm0755 ${DEST}/usr/lib",
        "install -m0755 libmozjs-140.a ${DEST}/usr/lib",
      ]
  }
}
