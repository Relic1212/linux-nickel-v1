{
  lib,
  drvs,
  # mrust = _mrust,
  _mrust | lib.MakePackage =
    let rustver =
      # "1.29.0"
      "1.54.0"
    in
    let hr = {
      "1.29.0" = "a4eb34ffd47f76afe2abd813f398512d5a19ef00989d37306217c9c9ec2f61e9",

      "1.54.0" = "ac8511633e9b5a65ad030a1a2e5bdaa841fdfe3132f2baaa52cc04e71c6c6976"
    }
    in
    {
      sourceInputs = [
        {
          src = {
            uri = "https://github.com/thepowersgang/mrustc/archive/18275649d86d35aa9e9a40bf73610dfc2279e575.zip",
            sha256sum = "b702b796ec182f8b0436e966a090892fc13171d2118c452624cc88cf9a33ae13",
          }
        },
        # {
        #     src={
        #         uri="https://github.com/rust-lang/rust/archive/refs/tags/%{rustver}.tar.gz",
        #         sha256sum="7689c95c0bab42e32eb82c1892785fe53faa8ae89a5c48bdfafb13a43ac8ec7e"
        #     },
        #     unpack=false,
        # },
        {
          src = {
            uri = "https://static.rust-lang.org/dist/rustc-%{rustver}-src.tar.gz",
            sha256sum = hr."%{rustver}" #"a4eb34ffd47f76afe2abd813f398512d5a19ef00989d37306217c9c9ec2f61e9",
          },
          unpack = false,
        }
      ],
      preConfigurePhase = [
        m%"sed -i 's@$(RUSTC_SRC_DL): $(RUSTC_SRC_TARBALL)@$(RUSTC_SRC_DL):@g' minicargo.mk"%,
        m%"
            for f in $(find /tmp/workdir/packed -name "rustc-%{rustver}-src.tar.gz"); do
                cp ${f} rustc-%{rustver}-src.tar.gz
            done
            "%
      ],
      buildPhase = [
        "export CC=\"static-clang\"",
        "export CXX=\"static-clang++\"",
        "export LD=\"static-lld\"",
        "echo \"building top level\"",
        "export RUSTC_VERSION=%{rustver}",
        "export MRUSTC_TARGET_VER=1.54",
        "export RUSTC_TARGET=x86_64-unknown-linux-musl",
        "export OUTDIR_SUF=-1.54.0",
        m%"make CC="${CC}" CXX="${CXX}" LD="${LD}""%,
        "echo COPYING",
        "cp -r bin tools",
        "echo \"building minicargo LIBS\"",
        m%"make CC="${CC}" CXX="${CXX}" LD="${LD}" -f minicargo.mk LIBS"%,
        "echo \"building minicargo\"",
        m%"make CC="${CC}" CXX="${CXX}" LD="${LD}" -f minicargo.mk"%,
        "echo \"building run_rustc\"",
        m%"make CC="${CC}" CXX="${CXX}" LD="${LD}" -C run_rustc"%,
      ],
      # buildPhase=[

      #     m%"make LDFLAGS="${LDFLAGS}" -f minicargo.mk"%,
      #     m%"make LDFLAGS="${LDFLAGS}" -C run_rustc"%,

      # ],
      baseBuildinputPackages = [
        drvs.gnumake,
        drvs.musl123,
        drvs.llvm,
        drvs.ccacheBin,
        drvs.busybox,
      ],
      installPhase = [],
      biDrvs = [
        drvs.pythonFull,
        drvs.cmake,
        drvs.samurai,
        drvs.bash,
        drvs.zlibNg,
        drvs.git,
        drvs.clangStatic,
        drvs.libempty,
        drvs.libemptyGcc,
      ]
    },

  clangStatic | lib.Package = {
    installPhase = [
      m%"
            install -d -m0755 ${DEST}/usr/bin

            cd ${DEST}/usr/bin

            printf "#!/bin/sh
            exec /usr/bin/clang -static --static \"\${@}\"
            " > static-clang

            printf "#!/bin/sh
            exec /usr/bin/clang++ -static --static \"\${@}\"
            " > "static-clang++"

            printf "#!/bin/sh
            exec /usr/bin/lld -static --static \"\${@}\"
            " > static-lld

            for f in $(ls); do
                chmod +x $f
            done
            "%
    ]
  }
}
& {

  lib,
  clangCc | lib.Package = {
    installPhase = [
      m%"
            install -d -m0755 ${DEST}/usr/bin

            cd ${DEST}/usr/bin

            printf "#!/bin/sh
            exec /usr/bin/clang \"\${@}\"
            " > cc

            printf "#!/bin/sh
            exec /usr/bin/clang++ \"\${@}\"
            " > "c++"
            "%,
      # m%"
      # printf "#!/bin/sh
      # exec /usr/bin/lld -static --static \"\${@}\"
      # " > static-lld
      # "%,
      m%"
            for f in $(ls); do
                chmod +x $f
            done
            "%,
    ]
  }
}
& {
  lib,
  drvs,
  libempty | lib.Package = {
    buildPhase = [
      ": > a.c",
      "${CC} -c -o libempty.o -x c a.c",
      "${AR} q libempty.a libempty.o",
    ],
    installPhase = [
      "install -d -m0755 ${DEST}/usr/lib",
      "install -m0755 libempty.a ${DEST}/usr/lib",
    ],
    biDrvs = [
      drvs.llvm,
    ],
    enableCcache = false,
  },

  libemptyGcc | lib.Package = {
    installPhase = [
      "install -d -m0755 ${DEST}/usr/lib",
      "cd ${DEST}/usr/lib",
      "ln -s libempty.a libgcc.a",
      "ln -s libempty.a libgcc_s.a",
      "ln -s libempty.a libgcc_eh.a",
      "ln -s libempty.a libatomic.a",
    ]
  },
  libgccSymlinks | lib.Package = {
    installPhase = [
      "install -d -m0755 ${DEST}/usr/lib",
      "cd ${DEST}/usr/lib",
      "ln -s /usr/lib/gcc/x86_64-pc-linux-musl/14.2.0/libgcc.a libgcc_s.a",
      "ln -s /usr/lib/gcc/x86_64-pc-linux-musl/14.2.0/libgcc_eh.a libgcc_eh.a",
      "ln -s /usr/lib/gcc/x86_64-pc-linux-musl/14.2.0/libgcc.a libgcc.a",
    ]
  },
}
& {
  drvs,
  lib,
  musl123 | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://musl.libc.org/releases/musl-1.2.3.tar.gz",
      sha256sum = "7d5b0b6062521e4627e099e4c9dc8248d32a30285e959b7eecaa780cf8cfd4a4",
    },
    buildEnv._isStatic | force = false,
    isStatic | force = false,

    configureFlags = [
      "--prefix=/usr"
    ]
  }
}
