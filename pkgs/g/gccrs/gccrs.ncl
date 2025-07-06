{
  lib,
  m4,
  flex,
  bison,
  mpc,
  gmp,
  mpfr,
  llvm,

  gccrs | lib.AutotoolsPackage = {
    isLlvm = false,
    buildEnv = {
      _isLlvm = false,
      CC = ["clang"],
      CXX = ["clang++"],
      STATIC_CFLAGS = ["-static"],
    },
    singleSource = {
      uri = "https://github.com/Rust-GCC/gccrs/archive/b0d6abb923915451c6a90f1b328d8efbfdf22441.zip",
      sha256sum = "4f0141cda3362089c04ba194d8a443f7f33aaea82f0203267ebf298311dc89c5",
    },
    biDrvs =
      lib.biMap [
        m4,
        flex,
        bison,
        mpc,
        gmp,
        mpfr,
        llvm,
      ],
    extraConfigureFlags = [
      "--disable-nls",
      "--disable-libquadmath",
      "--disable-decimal-float",
      "--disable-libitm",
      "--disable-fixed-point",
      "--disable-lto",
      "--disable-libada",
      "--disable-libgm2",
      "--disable-libsanitizer",
      "--disable-analyzer",
      "--disable-gcov",
      "--disable-libatomic",
      "--disable-libgomp",
      "--disable-libvtv",
      "--disable-bootstrap",
      "--disable-assembly",
      "--disable-werror",
      "--target=x86_64-linux-musl",
      "--prefix=",
      "--libdir=/lib",
      "--disable-multilib",
      "--with-sysroot=/x86_64-linux-musl",
      "--enable-tls",
      "--disable-libmudflap",
      "--disable-libsanitizer",
      "--disable-gnu-indirect-function",
      "--disable-libmpx",
      "--enable-initfini-array",
      "--enable-libstdcxx-time=rt"
    ]
  }
}
& {
  m4,

  lib,
  gmp | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.xz",
      sha256sum = "a3c2b80201b89e68616f4ad30bc66aee4927c3ce50e33929ca819d5c43538898",
    },
    biDrvs =
      lib.biMap [
        m4,
      ]
  }
}
& {
  m4,
  gmp,

  lib,
  mpfr | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.0.tar.xz",
      sha256sum = "06a378df13501248c1b2db5aa977a2c8126ae849a9d9b7be2546fb4a9c26d993",
    },
    biDrvs =
      lib.biMap [
        m4,
        gmp,
      ]
  }
}
& {
  m4,
  gmp,
  mpfr,

  lib,
  mpc | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz",
      sha256sum = "ab642492f5cf882b74aa0cb730cd410a81edcdbec895183ce930e706c1c759b8",
    },
    biDrvs =
      lib.biMap [
        m4,
        gmp,
        mpfr,
      ]
  }
}
& {
  lib,
  m4,
  flex,
  bison,
  mpc,
  gmp,
  mpfr,
  clangStatic,
  linuxHeaders,
  binutils,

  gcc0 | lib.AutotoolsPackage = {

    buildEnv = {
      LD = null,
      CFLAGS = ["--static", "-static"],
      LDFLAGS = ["--static", "-static"],
      CXXFLAGS = ["--static", "-static", "-std=c++11"],
      CPPFLAGS = null,
      CC = ["clang"],
      CXX = ["clang++"],
      CPP = null,

      AS = null,
      AR = null,
      NM = null,

      OBJCOPY = null,

      OBJDUMP = null,

      RANLIB = null,

      READELF = null,
    },

    singleSource = {
      uri = "https://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.gz",
      sha256sum = "7d376d445f93126dc545e2c0086d0f647c3094aae081cdb78f42ce2bc25e7293",
    },
    biDrvs =
      lib.biMap [
        m4,
        flex,
        bison,
        mpc,
        gmp,
        mpfr,
        clangStatic,
        (binutils & { priority = 1 }),
        linuxHeaders,
      ],
    extraConfigureFlags = [
      "--enable-languages=c,c++",
      "--disable-multilib",
      "--disable-host-shared",
      "--with-static-standard-libraries",
      "--disable-werror",
      "--disable-nls",
      "--enable-checking=release",
      "--disable-multiarch",
      "--disable-lto",
      # "--build=x86_64-unknown-linux-musl",
      # "--host=x86_64-unknown-linux-musl",
      # "--target=x86_64-unknown-linux-musl",
      "--disable-libsanitizer",
      "--disable-bootstrap",
      "--enable-install-libiberty",
      " --enable-libstdcxx-time=rt",
      "--disable-libstdcxx",
      "--without-headers",
      "--with-newlib",
      # "--disable-wchar_t",
    ]
  }
}
& {
  lib,
  m4,
  flex,
  bison,
  mpc,
  gmp,
  mpfr,
  clangCc,
  muslShared,
  llvmPic,
  binutils,

  gcc | lib.AutotoolsPackage = {
    #configureScript="${SRC}/libstdc++-v3/configure",
    buildEnv = {
      LD = null,
      #CFLAGS =  ["--static","-static"],
      #LDFLAGS = ["--static","-static"],
      #CXXFLAGS =  ["--static","-static" ],
      #CFLAGS =  null,
      LDFLAGS = ["-fPIC"],

      CXXFLAGS = ["--verbose", "-fPIC"],
      CFLAGS = ["--verbose", "-fPIC"],

      CPPFLAGS = null,
      #CC = ["gcc"],
      #CXX = ["g++"],
      #CC = ["clang"],
      #CXX = ["clang++"],
      CC = null,
      CXX = null,
      CPP = null,

      AS = null,
      AR = null,
      NM = null,

      OBJCOPY = null,

      OBJDUMP = null,

      RANLIB = null,

      READELF = null,
    },
    patches = [
      {
        file = "0022-x86_64-disable-multilib-support.patch",
        sha256sum = "3a24fc520091e713f7427a2bc141a3240fd9d37ed61fdb7489860894a146eb54",
      }
    ],
    singleSource = {
      uri = "https://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.gz",
      sha256sum = "7d376d445f93126dc545e2c0086d0f647c3094aae081cdb78f42ce2bc25e7293",
    },
    llvmProvider = lib.singleBiMap llvmPic,
    biDrvs =
      lib.biMap [
        m4,
        flex,
        bison,
        mpc,
        gmp,
        mpfr,
        clangCc,
        #clangStatic,
        (binutils & { priority = 1 }),
        #(gcc0 & {priority = 1}),
        muslShared,
      ],
    configureFlags =
      lib.constants.configureFlags
      @ [
        "--enable-shared",
        "--enable-static",
        "--enable-languages=c,c++",
        "--disable-multilib",
        # "--disable-host-shared",
        #"--with-static-standard-libraries",
        "--disable-werror",
        "--disable-nls",
        "--enable-checking=release",
        "--disable-multiarch",
        "--disable-lto",
        #"--build=x86_64-unknown-linux-musl",
        #"--host=x86_64-unknown-linux-musl",
        #"--target=x86_64-unknown-linux-musl",
        "--disable-libsanitizer",
        "--disable-bootstrap",
        "--enable-install-libiberty",
        " --enable-libstdcxx-time=rt",
        " --disable-libstdcxx",
      ]
  }
}
& {
  lib,
  llvm,
  musl,
  muslShared,
  ccacheBin,
  m4,
  gnumake,
  libtool,
  rsync,

  binutils | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://ftp.gnu.org/gnu/binutils/binutils-2.43.tar.xz",
      sha256sum = "b53606f443ac8f01d1d5fc9c39497f2af322d99e14cea5c0b4b124d630379365"
    },
    extraMakeArgs = [
      "MAKEINFO=true"
    ],
    extraMakeInstallArgs = extraMakeArgs,
    extraConfigureFlags = [
      "--disable-gdb",
      "--disable-gprofng",
      "--disable-multilib",
      "--disable-nls",
      "--disable-werror",
      "--enable-host-shared=no",
      "--disable-host-shared",
      "--with-static-standard-libraries",
    ]
  }
}
& {
  lib,

  bootstrapStage0,
  llvm,
  musl,
  muslShared,
  ccacheBin,
  m4,
  gnumake,
  libtool,
  rsync,

  gcc9 =
    bootstrapStage0
    & {
      stage | force = -1,
      buildEnv = {
        _stage | force = -1,
        CC = ["clang"],
        CXX = ["clang++"],

        # https://github.com/FastLED/FastLED/issues/1457
        EXTRA_CXXFLAGS = [
          "-Wno-register",
          "-Wno-misleading-indentation",
          "-std=gnu++11"
        ],
        EXTRA_CFLAGS = [
          "-Wno-register",
          "-Wno-misleading-indentation",
        ]
      },

      extraEnv = {
        HOSTCC = ["clang"],
      },
      buildInChroot | force = true,

      biDrvs =
        lib.biMap [
          llvm,
          musl,
          muslShared,
          ccacheBin,
          m4,
          gnumake,
          libtool,
          rsync,
        ],

      buildPhase | force =
        let B = "/tmp/workdir/build"
        in
        let MAKE = "make -j$(nproc) MULTILIB_OSDIRNAMES= INFO_DEPS= infodir= ac_cv_prog_lex_root=lex.yy MAKEINFO=true"
        in
        let TARGET = "x86_64-linux-musl"
        in
        [
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
         --prefix=/usr --libdir=/usr/lib \
         --disable-multilib \
         --with-sysroot=/ \
         --enable-deterministic-archives \
         --build=${HOST} \
         --host=${HOST}
         "%,

          # kernel headers
          "cd ${SRC}/src_kernel_headers",
          "%{MAKE} HOSTCC=\"${HOSTCC}\" ARCH=x86 O=/tmp/workdir/build/obj_kernel_headers INSTALL_HDR_PATH=/tmp/workdir/build/obj_kernel_headers/staged headers_install",
          "cd %{B}",
          "find obj_kernel_headers/staged/include '(' -name .install -o -name ..install.cmd ')' -exec rm {} +",
          "cd obj_binutils",
          "echo 'BOOTSTRAP LOG: building binutils'",
          m%"%{MAKE} -j$(nproc) MAKE="%{MAKE}" HOSTCC="${HOSTCC}" all"%,
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
          --prefix=/usr \
          --libdir=/usr/lib \
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
          m%"%{MAKE} MAKE="%{MAKE}" HOSTCC="${HOSTCC}" all-gcc"%,

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
    }
}
& {

  llvm,

  llvmPic =
    llvm
    & {
      cmakeArgsRecord = {
        "-DLLVM_ENABLE_PIC" | force = "ON",
      },
      buildEnv = {
        EXTRA_CFLAGS = ["-fPIC"],
        EXTRA_CXXFLAGS = ["-fPIC"],
        EXTRA_LDFLAGS = ["-fPIC"],
      }
    }
}
& {
  lib,

  llvmFull,

  llvmPic,

  llvmFullPic =
    llvmFull
    & {
      cmakeArgsRecord = {
        "-DLLVM_ENABLE_PIC" | force = "ON",
        "-DLLVM_TOOL_LLVM_DRIVER_BUILD" | force = false,
        "-DLLVM_TARGETS_TO_BUILD" | priority 10000 = "'X86'"
      },
      llvmProvider = lib.singleBiMap llvmPic,
      buildEnv = {
        EXTRA_CFLAGS = ["-fPIC"],
        EXTRA_CXXFLAGS = ["-fPIC"],
        EXTRA_LDFLAGS = ["-fPIC"],
      }
    }
}
