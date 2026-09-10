{
  lib,
  drvs,
  busybox,
  busyboxSelinux | lib.MakePackage =
    busybox
    & {
      makeArgs,
      buildEnv.CC = ["clang", "--verbose", "--static", ],
      buildEnv.EXTRA_LDFLAGS = [
        "$(pkg-config --libs --static libpcre2-8)",
      ],
      extraFiles | priority 1 = [],
      preConfigurePhase = [
        m%"sed -i 's|main|int main|g' ${SRC}/scripts/kconfig/lxdialog/check-lxdialog.sh"%,
      ],
      buildDir,
      configurePhase | priority 2001 = [
        "cd %{buildDir}",
        "unset CPPFLAGS",
        lib.functions.writeFile ".config" (import "selinux.busybox.config" as 'Text),
        "sed -i 's@-falign-jumps=1@@g' Makefile.flags",
        "sed -i 's@-falign-labels=1@@g' Makefile.flags",
        "sed -i 's@-finline-limit=0@@g' Makefile.flags",
        "make " ++ (std.string.join " " (makeArgs)) ++ " oldconfig"
      ],
      #   buildPhase = [
      #     "make %{std.string.join "" makeArgs} V=1 menuconfig",
      #   ],
      biDrvs | priority 1 =
        busybox.biDrvs
        @ [
          #   drvs.ncurses,
          drvs.pkgconfMeson,
          #   drvs.selinux,
        ],
      pDrvs = [
        drvs.selinux,
      ],
    },

  busyboxSelinuxProgs | lib.Package = {
    utilsProviders = [
      drvs.busyboxSelinux,
    ],

    buildPhase = [
      lib.functions.writeFile "busybox_cmd.c" (import "busybox_cmd.c" as 'Text),
      "mkdir out",
      "for p in $(busybox --list); do",
      m%"${CC} ${CFLAGS} --verbose -Werror -DAPPLET="\"$p\"" busybox_cmd.c -o  out/"$p""%,
      # m%"printf "#!/usr/bin/busybox sh\nset -e\nexec /usr/bin/busybox $p  \"\$@\"\n" > out/"$p""%,
      m%"chmod +x out/"$p""%,
      "done",
    ],

    installPhase = [
      "install -dm0755 ${DEST}/usr/bin",
      "install -m0755 out/* ${DEST}/usr/bin",
    ],

    biDrvs = [
      drvs.musl,
      drvs.llvm,
    ]
  }
}
