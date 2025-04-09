{
  lib,
  drvs,
  cproc | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/michaelforney/cproc/archive/a2ddee1be68e76a1ac7f83b55732be8e54fe08c4.tar.gz",
      sha256sum = "3f30c418c1bc3bafb42b3a9d54f96db322b90ec5d0ae10fd459930af86e3847a"
    },
    extraMakeInstallArgs = [
      "PREFIX=/usr"
    ]
  }
}
& {
  lib,
  drvs,
  cproc,
  cprocBaltos | lib.MakePackage =
    cproc
    & {

      preConfigurePhase = [
        m%"
cat >config.h <<EOF
static const char target[]               = "i686-myos-elf";
static const char *const startfiles[]    = {"-l", ":crt1.o", "-l", ":crti.o"};
static const char *const endfiles[]      = {"-l", "c", "-l", ":crtn.o"};
static const char *const preprocesscmd[] = {
        "cpp",

        /* clear preprocessor GNU C version */
        "-U", "__GNUC__",
        "-U", "__GNUC_MINOR__",

        /* we don't yet support these optional features */
        "-D", "__STDC_NO_ATOMICS__",
        "-D", "__STDC_NO_COMPLEX__",
        "-U", "__SIZEOF_INT128__",

        /* we don't generate position-independent code */
        "-U", "__PIC__",

        /* ignore extension markers */
        "-D", "__extension__=",
};
static const char *const codegencmd[]    = {"qbe"};
static const char *const assemblecmd[]   = {"i686-myos-elf-as"};
static const char *const linkcmd[]       = {"ld",  "--dynamic-linker", "/lib/ld-libk.so"};

EOF
"%
      ],

      baseBuildinputPackages | priority 1 = [
        drvs.binutils,
        drvs.cproc,
        drvs.busybox,
        drvs.gnumake,
        drvs.mcpp,
        drvs.qbe,
        drvs.musl,
      ],
      isLlvm = false,
      buildEnv = {
        _isLlvm = false,
        CC = ["cproc"],
        STATIC_CFLAGS | priority 1 = ["-static"],
        STATIC_LDFLAGS | priority 1 = ["-static"],
      }
    }
}
& {
  lib,
  drvs,
  cprocCpp | lib.Package = {
    installPhase = [
      "install -d -m0755 ${DEST}/usr/bin",
      m%"printf "#!/bin/sh\nexec cproc -E \$@\n" > ${DEST}/usr/bin/cpp"%,
      m%"chmod +x ${DEST}/usr/bin/cpp"%,
      # "cd ${DEST}/usr/bin",
      # "ln -s cproc-qbe qbe"
    ]
  }
}
& {
  lib,
  drvs,
  mcpp | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://github.com/museoa/mcpp/archive/7c1872d70b00df8e4d06d68e6f4911cbc81b9073.tar.gz",
      sha256sum = "0e840eada89b4bdc663130fef0975a1046c11b05ae3cfbd0e83e5af21bc8d811"
    },

    postInstallPhase = [
      "cd ${DEST}/usr/bin",
      "ln -s mcpp cpp"
    ]
  }
}
