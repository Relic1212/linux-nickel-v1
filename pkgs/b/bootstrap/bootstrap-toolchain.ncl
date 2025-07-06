{
  lib,
  busyboxBootstrapStage0,

  musl,
  linux,
  bootstrapStage0 | lib.Package =
    let B = "/tmp/workdir/build"
    in
    let MAKE = "make -j$(nproc) MULTILIB_OSDIRNAMES= INFO_DEPS= infodir= ac_cv_prog_lex_root=lex.yy MAKEINFO=true"
    in
    let TARGET = "x86_64-linux-musl"
    in

    {
      sourceInputs =
        let _muslSrc = std.array.at 0 musl.sourceInputs in
        let muslSrc = std.record.update "dest" "src_musl" _muslSrc in

        let _linuxSrc = std.array.at 0 linux.sourceInputs in
        let linuxSrc = std.record.update "dest" "src_kernel_headers" _linuxSrc in

        [
          {
            src = {
              uri = "https://ftp.gnu.org/gnu/gcc/gcc-9.4.0/gcc-9.4.0.tar.xz",

              sha256sum = "c95da32f440378d7751dd95533186f7fc05ceb4fb65eb5b85234e6299eb9838e",
            },
            dest = "src_gcc",
          },
          muslSrc,
          # {
          #   src = {
          #     uri = "http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=3d5db9ebe860",
          #     sha256sum = "75d5d255a2a273b6e651f82eecfabf6cbcd8eaeae70e86b417384c8f4a58d8d3",
          #   },
          #   dest = "src_config.stub",
          # },
          {
            src = {
              uri = "https://ftp.gnu.org/gnu/binutils/binutils-2.33.1.tar.xz",
              sha256sum = "ab66fc2d1c3ec0359b8e08843c9f33b63e8707efdff5e4cc5c200eae24722cbf",
            },
            dest = "src_binutils",
          },
          # {
          #   src = {
          #     uri = "https://musl.libc.org/releases/musl-1.2.4.tar.gz",
          #     sha256sum = "7a35eae33d5372a7c0da1188de798726f68825513b7ae3ebe97aaaa52114f039",
          #   },
          #   dest = "src_musl",
          # },
          {
            src = {
              uri = "https://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.bz2",
              sha256sum = "5275bb04f4863a13516b2f39392ac5e272f5e1bb8057b18aec1c9b79d73d8fb2",
            },
            dest = "src_gcc/gmp",
          },
          {
            src = {
              uri = "https://ftp.gnu.org/gnu/mpc/mpc-1.1.0.tar.gz",
              sha256sum = "6985c538143c1208dcb1ac42cedad6ff52e267b47e5f970183a3e75125b43c2e",
            },
            dest = "src_gcc/mpc",
          },
          {
            src = {
              uri = "https://ftp.gnu.org/gnu/mpfr/mpfr-4.0.2.tar.bz2",
              sha256sum = "c05e3f02d09e0e9019384cdd58e0f19c64e6db1fd6f5ecf77b4b1c61ca253acc",
            },
            dest = "src_gcc/mpfr",
          },
          linuxSrc,
          # {
          #   src = {
          #     uri = "http://ftp.barfooze.de/pub/sabotage/tarballs//linux-headers-4.19.88-1.tar.xz",
          #     sha256sum = "995bc76ccf0c40d752b5ea67c022232a17eef6c9ec80ea74ea742e3c19992813",
          #   },
          #   dest = "src_kernel_headers",
          # }
        ],
      stage = 0,
      # makeArgs=[
      #     "TARGET=x86_64-linux-musl",
      #     "-j$(nproc)",
      # ],
      # extraMakeInstallArgs =  [
      #      "TARGET=x86_64-linux-musl",
      #     "OUTPUT=/",
      # ],
      isLlvm | force = false,
      isStatic | force = false,
      buildEnv._isStatic | force = false,
      buildEnv._isLlvm | force = false,
      # separateBuildDir=false,

      preConfigurePhase = [
        "mkdir -p obj_binutils obj_kernel_headers/staged obj_sysroot/include obj_gcc obj_musl",
        "(cd obj_sysroot && ln -sf . usr)",
      ],
      buildPhase = [
        # "export B=/tmp/workdir/build/",
        # "mv ${SRC}/src_config.stub/\"?p=config.git;a=blob_plain;f=config.sub;hb=3d5db9ebe860\" config.sub",
        # "chmod +x config.sub",
        "HOST=\"$(../src/src_gcc/config.guess)\"",

        # binutils
        "cd obj_binutils",
        m%"../../src/src_binutils/configure \
         --disable-separate-code \
         LDFLAGS="-static --static" \
         --disable-nls \
         --enable-static \
         --disable-shared \
         --disable-werror \
         --target=%{TARGET} \
         --prefix= --libdir=/lib \
         --disable-multilib \
         --with-sysroot=/%{TARGET} \
         --enable-deterministic-archives \
         --build=${HOST} \
         --host=${HOST}
         "%,

        # kernel headers
        "cd ${SRC}/src_kernel_headers",
        "%{MAKE} ARCH=x86 O=/tmp/workdir/build/obj_kernel_headers INSTALL_HDR_PATH=/tmp/workdir/build/obj_kernel_headers/staged headers_install",
        "cd %{B}",
        "find obj_kernel_headers/staged/include '(' -name .install -o -name ..install.cmd ')' -exec rm {} +",
        "cd obj_binutils",
        "echo 'BOOTSTRAP LOG: building binutils'",
        m%"%{MAKE} -j$(nproc) MAKE="%{MAKE}" all"%,
        "cd %{B}/obj_gcc",
        "echo 'BOOTSTRAP LOG: configuring gcc'",

        # 4807
        m%"
        ../../src/src_gcc/configure \
          --enable-languages=c,c++  \
          LDFLAGS="-static --static" \
          --disable-nls \
          --enable-static \
          --disable-shared \
          --disable-libquadmath \
          --disable-decimal-float \
          --disable-libitm \
          --disable-fixed-point \
          --disable-lto \
          --disable-libada \
          --disable-libgm2 \
          --disable-libsanitizer \
          --disable-analyzer \
          --disable-gcov \
          --disable-libatomic \
          --disable-libgomp \
          --disable-libvtv  \
          --disable-bootstrap \
          --disable-assembly \
          --disable-werror \
          --target=%{TARGET} \
          --prefix= \
          --libdir=/lib \
          --disable-multilib \
          --with-sysroot=/%{TARGET} \
          --enable-tls \
          --disable-libmudflap \
          --disable-libsanitizer \
          --disable-gnu-indirect-function \
          --disable-libmpx \
          --enable-initfini-array \
          --enable-libstdcxx-time=rt \
          --with-build-sysroot=%{B}/obj_sysroot \
          AR_FOR_TARGET=%{B}/obj_binutils/binutils/ar \
          AS_FOR_TARGET=%{B}/obj_binutils/gas/as-new \
          LD_FOR_TARGET=%{B}/obj_binutils/ld/ld-new \
          NM_FOR_TARGET=%{B}/obj_binutils/binutils/nm-new \
          OBJCOPY_FOR_TARGET=%{B}/obj_binutils/binutils/objcopy \
          OBJDUMP_FOR_TARGET=%{B}/obj_binutils/binutils/objdump \
          RANLIB_FOR_TARGET=%{B}/obj_binutils/binutils/ranlib \
          READELF_FOR_TARGET=%{B}/obj_binutils/binutils/readelf \
          STRIP_FOR_TARGET=%{B}/obj_binutils/binutils/strip-new \
          --build=${HOST} \
          --host=${HOST}
          "%,
        "echo 'BOOTSTRAP LOG: building gcc'",

        # 4941
        m%"%{MAKE} MAKE="%{MAKE}" all-gcc"%,

        # logline 16114
        "cd %{B}/obj_musl",
        m%"../../src/src_musl/configure \
          --prefix= \
          --host=%{TARGET} \
          CC="../obj_gcc/gcc/xgcc -B ../obj_gcc/gcc" \
          LIBCC="../obj_gcc/%{TARGET}/libgcc/libgcc.a"
        "%,
        "%{MAKE} DESTDIR=%{B}/obj_sysroot install-headers",
        "cd %{B}/obj_gcc",
        "%{MAKE} MAKE=\"%{MAKE} enable_shared=no\" all-target-libgcc",
        "cd %{B}/obj_musl",
        "%{MAKE} AR=../obj_binutils/binutils/ar RANLIB=../obj_binutils/binutils/ranlib DESTDIR=%{B}/obj_sysroot install",
        "cd %{B}/obj_gcc",
        "%{MAKE} MAKE=\"%{MAKE}\"",
      ],

      preInstallPhase = [
        m%"
            if [ ! $(command -v cmp) ]; then
                install -d -m0755 /tmp/workdir/build/bin

                echo "#!/bin/sh" > /tmp/workdir/build/bin/cmp
                echo "true" >> /tmp/workdir/build/bin/cmp

                chmod +x /tmp/workdir/build/bin/cmp
                export PATH="${PATH}:/tmp/workdir/build/bin"
            fi

            "%
      ],
      installPhase = [
        "echo 'installing musl'",
        "export DEST=/tmp/workdir/out/destdir/usr",
        "install -d -m0755 /tmp/workdir/out/destdir/usr",
        "cd %{B}/obj_musl",
        "%{MAKE} AR=../obj_binutils/binutils/ar RANLIB=../obj_binutils/binutils/ranlib DESTDIR=${DEST}/%{TARGET} install",
        "echo 'installing binutils'",
        "cd %{B}/obj_binutils",
        "%{MAKE} DESTDIR=${DEST} install",
        "echo 'installing gcc'",
        "cd %{B}/obj_gcc",
        # 21712
        "%{MAKE} DESTDIR=${DEST} install",
      ],
    },
  bootstrapSymlinks | lib.Package = {
    stage = 1,
    installPhase =
      [
        "install -d -m 0755 ${DEST}/usr/bin",
        "cd ${DEST}/usr/bin"
      ]
      @ (
        std.array.map
          (fun v => "ln -s x86_64-linux-musl-%{v} %{v}"
          )
          [
            "addr2line",
            "ar",
            "as",
            "c++",
            "c++filt",
            "cpp",
            "elfedit",
            "g++",
            "gcc",
            "gcc-9.4.0",
            "gcc-ar",
            "gcc-nm",
            "gcc-ranlib",
            "gprof",
            "ld",
            "ld.bfd",
            "nm",
            "objcopy",
            "objdump",
            "ranlib",
            "readelf",
            "size",
            "strings",
            "strip",
            # "x86_64-linux-musl-c++",
            # "x86_64-linux-musl-g++",
            # "x86_64-linux-musl-gcc",
            # "x86_64-linux-musl-gcc-ar",
            # "x86_64-linux-musl-gcc-nm",
            # "x86_64-linux-musl-gcc-ranlib",
          ]
      ),

    biDrvs =
      lib.biMap [
        busyboxBootstrapStage0,
      ]
  }
}
