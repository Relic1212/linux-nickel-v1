{
  lib,

  tinycc | lib.AutotoolsPackage = {
    singleSource = {
      # uri = "https://repo.or.cz/tinycc.git/snapshot/a21b5f1fd7eda4f8b23ed5c5cc3f6ead748401db.tar.gz",
      # sha256sum = "fa56d5809be8063b5ee750bf402d3cd24e0337e37237797e610276486abc922f",

      # uri = "https://repo.or.cz/tinycc.git/snapshot/5527ca6dcb56423cdc0ed28358307b87d7c87e6c.tar.gz",
      # sha256sum = "d23bcbec31821cff83d4d1a32316a0e57cd3800c7fc8371f8563e5398fdfa697",

      uri = "https://download.savannah.gnu.org/releases/tinycc/tcc-0.9.27.tar.bz2",
      sha256sum = "de23af78fca90ce32dff2dd45b3432b2334740bb9bb7b05bf60fdbfc396ceb9c",
    },
    options = {
      targetOs = "Linux"
    },

    preConfigurePhase = [
      "export CC=\"${CC} -static\""
    ],
    extraConfigureFlags = [
      "--config-musl",
      "--enable-cross",
      "--target-os=%{options.targetOs}",
    ],
    extraMakeArgs = [
      "CC=\"${CC}\""
    ]
  },
  _binutils,
  binutilsExp | lib.AutotoolsPackage =
    _binutils
    & {
      extraConfigureFlags = [
        "--target=i686-elf",
        "--with-sysroot",
      ],
    }
}
& {
  lib,

  gcc,
  mpc,
  gmp,
  mpfr,
  m4,
  flex,
  bison,
  clangCc,
  binutils,
  binutilsExp,
  muslShared,

  gccExp | lib.AutotoolsPackage =
    gcc
    & {

      biDrvs | priority 1 =
        lib.biMap [
          m4,
          flex,
          bison,
          #   mpc,
          #   gmp,
          #   mpfr,
          clangCc,
          (binutils & { priority = 1 }),
          binutilsExp,
          muslShared,
        ],

      sourceInputs = [
        { src = gcc.singleSource },
        { src = mpc.singleSource, dest = "mpc" },
        { src = mpfr.singleSource, dest = "mpfr" },
        { src = gmp.singleSource, dest = "gmp" },
      ],

      # configureFlags|priority 1= lib.functions.replaceArrayElem "--disable-multilib" "--enable-multilib" (gcc.configureFlags @ [
      #     "--target=i686-elf",
      #     "--without-headers",
      #     " --disable-hosted-libstdcxx",
      # ]),

      configureFlags | priority 1 =
        lib.constants.configureFlags
        @ [
          "--enable-shared",
          "--enable-static",
          "--enable-languages=c,c++",
          "--enable-multilib",
          # "--disable-host-shared",
          #"--with-static-standard-libraries",
          "--disable-werror",
          "--disable-nls",
          # "--enable-checking=release",
          "--enable-multiarch",
          "--disable-lto",
          #"--build=x86_64-unknown-linux-musl",
          #"--host=x86_64-unknown-linux-musl",
          #"--target=x86_64-unknown-linux-musl",
          "--disable-libsanitizer",
          # "--disable-bootstrap",
          "--enable-install-libiberty",
          " --enable-libstdcxx-time=rt",
          " --disable-libstdcxx",
          "--target=i686-elf",
          "--without-headers",
          "--disable-hosted-libstdcxx",
          "--disable-libssp",
          "--disable-libquadmath",
        ]
    }
}
