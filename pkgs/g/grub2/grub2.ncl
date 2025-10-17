{
  lib,
  drvs,
  unifont,
  grub2 | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://ftp.gnu.org/gnu/grub/grub-2.12.tar.xz",
      sha256sum = "f3c97391f7c4eaa677a78e090c7e97e6dc47b16f655f04683ebd37bef7fe0faa"
    },
    sourceInputs = [
      {
        src = singleSource
      },
      {
        src = unifont.singleSource
      }
    ],
    biDrvs = [
      drvs.m4,
      drvs.flex,
      drvs.bison,
      drvs.pythonFull,
      drvs.linuxHeaders,
      drvs.zlibNg,
      drvs.freetype,
      drvs.pkgconf,
      (drvs.gawk & { priority = 1 })
    ],
    extraEnv = {
      "BUILD_CC" = ["clang", "-static", "--static"]
    },

    preConfigurePhase =
      [
        # https://gitweb.gentoo.org/repo/gentoo.git/commit/?id=76418694270557b6feb75381912a39569ee28d45
        m%"echo "depends bli part_gpt" > ${SRC}/grub-core/extra_deps.lst"%,
        "(cd ${SRC} && gunzip unifont-17.0.01.pcf.gz)",
      ]
      @ (
        std.array.map
          (fun v => "export TARGET_%{v}=\"${%{v}}\"")
          [
            "CC",
            "CXX",
            "LD",
            "CFLAGS",
            "CPPFLAGS",
            "LDFLAGS",
            "CXXFLAGS",
          ]
      ),
    extraConfigureFlags = [
      "--with-platform=efi",
      "--target=x86_64",
      "--disable-cross-guesses",
      "--disable-werror",
      "--enable-grub-mkfont",
      "--with-unifont=\"${SRC}/unifont-17.0.01.pcf\"",
    ],
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
& {
  lib,
  drvs,
  unifont | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://mirror.ibcp.fr/pub/gnu/unifont/unifont-17.0.01/unifont-17.0.01.pcf.gz",
      sha256sum = "8240c381398a21f4eef993d16f0976d6a627e61054f0add275d195408f24efa9"
    },
    preConfigurePhase = [
      "(cd )"
    ]
  }
}
