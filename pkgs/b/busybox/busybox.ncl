(import "busybox-base.ncl")
& {
  lib,
  drvs,
  _busyboxBaseTarget,

  busyboxStage1 =
    _busyboxBaseTarget
    & {
      stage = 1,
      biDrvs = [
        drvs.busyboxBootstrapStage0,
        drvs.llvmStage1,
        drvs.muslStage1,
        drvs.linuxHeadersStage1,
        drvs.ccacheBin,
        drvs.gnumakeStage1
      ]
    },

  busyboxStage2 =
    _busyboxBaseTarget
    & {
      stage = 2,
      biDrvs = [
        drvs.busyboxStage1,
        drvs.llvmStage2,
        drvs.muslStage2,
        drvs.linuxHeadersStage2,
        drvs.ccacheBin,
        drvs.gnumakeStage2
      ]
    },

  #3

  busyboxStage3 =
    _busyboxBaseTarget
    & {
      stage = -1,

      utilsProviders = [],
      baseBuildinputPackages = [],
      biDrvs = [
        drvs.busyboxStage2,
        drvs.llvmStage3,
        drvs.muslStage3,
        drvs.linuxHeadersStage3,
        drvs.ccacheBin,
        drvs.gnumakeStage4
      ]
    },
  busybox =
    _busyboxBaseTarget
    & {
      stage = -1,

      utilsProviders = [],
      baseBuildinputPackages = [],
      biDrvs = [
        drvs.busyboxStage3,
        drvs.llvm,
        drvs.musl,
        drvs.linuxHeaders,
        drvs.ccacheBin,
        drvs.gnumake
      ]
    },
  busyboxAarch64 =
    _busyboxBaseTarget
    & {
      stage = -1,
      makeArgs,
      buildDir,

      utilsProviders = [],
      baseBuildinputPackages = [],
      buildInputs = [
        drvs.busybox,
        drvs.clangCross,
        drvs.muslAarch64,
        drvs.musl,
        drvs.libcxxAarch64,
        drvs.linuxHeadersAarch64,
        drvs.linuxHeaders,
        drvs.ccacheBin,
        drvs.gnumake,
        # drvs.ncurses,
        drvs.readline,
      ],
      # buildEnv.EXTRA_CFLAGS = ["-nostdlib"],
      # buildEnv.EXTRA_LDFLAGS = ["-nostdlib", "-l:libc.a" ],

      buildEnv.TARGET = "aarch64-unknown-linux-musl",
      configurePhase | force = [
        "cd %{buildDir}",
        "unset CPPFLAGS",
        "cp /tmp/workdir/files/busybox.config .config",
        "sed -i 's@-falign-jumps=1@@g' Makefile.flags",
        "sed -i 's@-falign-labels=1@@g' Makefile.flags",
        "sed -i 's@-finline-limit=0@@g' Makefile.flags",
        "make " ++ (std.string.join " " (makeArgs)) ++ " oldconfig"
      ],
      extraFiles | priority 1 = [
        {
          file = "busybox.config",
          sha256sum = "72bb9329fb690e6c76ee7d5f6f54c1b291bfe616784d6a61fd1668f05eddcd4d",
        }
      ],

      makeArgs | force = [
        "PREFIX=/usr",
        "-j$(nproc)",
        "CC=%{lib.functions.varToExportvar buildEnv.CC}",
        "LD=\"clang --verbose --target=aarch64-unknown-linux-musl --sysroot=/aarch64-unknown-linux-musl\"",
        "HOSTLD=clang",
        "CXX=clang++",
        "CPP=\"clang --target=aarch64-unknown-linux-musl --sysroot=/%{buildEnv.TARGET} -E\"",
        "HOSTCC=clang",
        "HOSTCXX=clang++",
        "LDFLAGS=\"-L/aarch64-unknown-linux-musl/usr/lib -L/aarch64-unknown-linux-musl/usr/lib/aarch64-unknown-linux-musl -static --static -fuse-ld=lld  --rtlib=compiler-rt \"",
        "EXTRA_CPPFLAGS=\"\"",
        "CXXFLAGS=\"-static --static -O2 -pipe\"",
        "CFLAGS=\" --verbose  -static --static -O2 -pipe\"",
        "HOSTLDFLAGS=\"-static --static -fuse-ld=lld \"",
        "HOSTCPPFLAGS=\"\"",
        "HOSTCXXFLAGS=\" -static --static -O2 -pipe\"",
        "HOSTCFLAGS=\" --verbose -static --static -O2 -pipe\" ",
        "EXTRA_LDFLAGS=\"-target aarch64-unknown-linux-musl --sysroot=/aarch64-unknown-linux-musl -L/aarch64-unknown-linux-musl/usr/lib -static --static -fuse-ld=lld --rtlib=compiler-rt\"",
        # "EXTRA_CXXFLAGS=\"-target aarch64-unknown-linux-musl --sysroot=/aarch64-unknown-linux-musl -static --static -O2 -pipe\"",
        "EXTRA_CFLAGS=\"-DBB_GLOBAL_CONST=''\"",
        # "SYSROOT=\"/aarch64-unknown-linux-musl\" ",
        "LIBDIR=\"/aarch64-unknown-linux-musl/usr/lib\"",
        "ARCH=arm64",
      ],

      buildPhase | priority 1000 = [
        "make " ++ (std.string.join " " (makeArgs)),
      ],
      installPhase | priority 1000 = [
        "make DESTDIR=${DEST}" ++ (std.string.join " " (makeArgs)) ++ " install",
        m%"

                  install -d -m0755 ${DEST}/usr/bin
                  install -m0755 ${SRC}/busybox ${DEST}/usr/bin
                  cd ${DEST}/usr/bin
                  for link in $(cat ${SRC}/busybox.links |cut -d "/" -f4); do
                                echo "symlinking ${link}"
                                ln -s /usr/bin/busybox ${link}
                            done
                  install -d -m0755 ${DEST}/bin
                  cd  ${DEST}/
                  cp usr/bin/busybox bin/sh


          "%
      ]
    }
}
