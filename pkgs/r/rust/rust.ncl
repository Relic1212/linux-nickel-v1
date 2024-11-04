{
  lib,
  drvs,
  rust | lib.AutotoolsPackage
    = {
      singleSource = {
        uri = "https://github.com/rust-lang/rust/archive/refs/tags/1.82.0.tar.gz",
        sha256sum = "d7c7a32ed212213cbdf174ca3b5c4f49f22c8cf815430da33cb0151bdda8dc07",
      },
      separateBuildDir = false,
      buildPhase = [
        "./x.py build && ./x.py install"
      ],
      biDrvs = [
        drvs.pythonFull,
      ],
      configureFlags = [],
    },

  mrust | lib.MakePackage
    = {
      sourceInputs = [
        {
          src = {
            uri = "https://github.com/thepowersgang/mrustc/archive/18275649d86d35aa9e9a40bf73610dfc2279e575.zip",
            sha256sum = "b702b796ec182f8b0436e966a090892fc13171d2118c452624cc88cf9a33ae13",
          }
        },
        # {
        #     src={
        #         uri="https://github.com/rust-lang/rust/archive/refs/tags/1.29.0.tar.gz",
        #         sha256sum="7689c95c0bab42e32eb82c1892785fe53faa8ae89a5c48bdfafb13a43ac8ec7e"
        #     },
        #     unpack=false,
        # },
        {
          src = {
            uri = "https://static.rust-lang.org/dist/rustc-1.29.0-src.tar.gz",
            sha256sum = "a4eb34ffd47f76afe2abd813f398512d5a19ef00989d37306217c9c9ec2f61e9",
          },
          unpack = false,
        }
      ],
      preConfigurePhase = [
        m%"sed -i 's@$(RUSTC_SRC_DL): $(RUSTC_SRC_TARBALL)@$(RUSTC_SRC_DL):@g' minicargo.mk"%,
        m%"
            for f in $(find /tmp/workdir/packed -name "rustc-1.29.0-src.tar.gz"); do
                cp ${f} rustc-1.29.0-src.tar.gz
            done
            "%
      ],
      buildPhase = [
        "export CC=\"static-clang\"",
        "export CXX=\"static-clang++\"",
        "export LD=\"static-lld\"",
        "echo \"building top level\"",
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
      installPhase = [],
      biDrvs = [
        drvs.pythonFull,
        drvs.cmake,
        drvs.samurai,
        drvs.bash,
        drvs.zlibNg,
        drvs.git,
        drvs.clangStatic,
      ]
    },
  clangStatic | lib.Package
    = {
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
