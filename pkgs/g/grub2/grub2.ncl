{
  lib,
  drvs,
  grub2 | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://ftp.gnu.org/gnu/grub/grub-2.12.tar.xz",
      sha256sum = "f3c97391f7c4eaa677a78e090c7e97e6dc47b16f655f04683ebd37bef7fe0faa"
    },
    biDrvs = [
      drvs.m4,
      drvs.flex,
      drvs.bison,
      drvs.pythonFull,
      drvs.linuxHeaders,
      (drvs.gawk & { priority = 1 })
    ],
    extraEnv = {
      "BUILD_CC" = ["clang", "-static", "--static"]
    },

    preConfigurePhase = [
      # https://gitweb.gentoo.org/repo/gentoo.git/commit/?id=76418694270557b6feb75381912a39569ee28d45
      m%"echo "depends bli part_gpt" > ${SRC}/grub-core/extra_deps.lst"%
    ]
  }
}
& {
  lib,
  drvs,
  gawk | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://ftp.gnu.org/gnu/gawk/gawk-5.3.1.tar.xz",
      sha256sum = "694db764812a6236423d4ff40ceb7b6c4c441301b72ad502bb5c27e00cd56f78"
    }
  }
}
& {
  lib,
  drvs,
  libburn | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://files.libburnia-project.org/releases/libburn-1.5.6.tar.gz",
      sha256sum = "7295491b4be5eeac5e7a3fb2067e236e2955ffdc6bbd45f546466edee321644b"
    },
    biDrvs = [
      drvs.linuxHeaders,
    ]
  }
}
& {
  lib,
  drvs,

  libisofs | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://files.libburnia-project.org/releases/libisofs-1.5.6.tar.gz",
      sha256sum = "0152d66a9d340b659fe9c880eb9190f3570fb477ac07cf52e8bcd134a1d30d70"
    }
  }
}
& {
  lib,
  drvs,
  libisoburn | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://files.libburnia-project.org/releases/libisoburn-1.5.6.tar.gz",
      sha256sum = "2b80a6f73dd633a5d243facbe97a15e5c9a07644a5e1a242c219b9375a45f71b"
    },
    biDrvs = [
      drvs.libburn,
      drvs.libisofs,
      drvs.linuxHeaders,
    ]
  }
}
