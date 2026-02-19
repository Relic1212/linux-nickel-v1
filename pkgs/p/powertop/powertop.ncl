{
  lib,
  drvs,
  powertop | lib.AutomakePackage = {
    singleSource = {
      # uri = "https://github.com/fenrus75/powertop/releases/download/v2.15/powertop.tar.gz",
      # sha256sum = "e9590b82dee773b468b2eff4321a766c8bb04c45ccfa02b3127ee5af3359726b"

      uri = "https://github.com/fenrus75/powertop/archive/49045c0c8ca7d3f47b8e289a9436d5ab2f4e93d9.tar.gz",
      sha256sum = "ebace3bcb36cf1583db2f2c24a36ddddc8b6437eee2dd1748e802097c00a3a8c"
    },

    biDrvs = [
      drvs.ncurses,
      drvs.gettext,
      drvs.libnl,
      drvs.linuxHeaders,
      drvs.autoconfArchive,
      drvs.libtraceevent,
      drvs.libtracefs,
      drvs.pciutils,
    ],
    configureScript,
    configureFlags,
    configurePhase = [
      # "(cd ${SRC}; NOCONFIGURE=1 ./autogen.sh)",
      "(cd ${SRC} && autoupdate)",
      "(cd ${SRC} && autoreconf -fiv)",
      "(cd ${SRC} && ./autogen.sh)",
      configureScript ++ " " ++ (std.string.join lib.constants.buildFlagSep configureFlags),
    ],
  }
}
& {
  lib,
  drvs,
  autoconfArchive | lib.AutotoolsPackage = {
    singleSource = {
      # uri = "https://github.com/autoconf-archive/autoconf-archive/archive/refs/tags/v2023.02.20.tar.gz",
      # sha256sum = "9143c2b02e16efd20093e6e947a7bdaeac71302638214d516a0c2ca383b6bca7",

      uri = "https://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2024.10.16.tar.xz",
      sha256sum = "7bcd5d001916f3a50ed7436f4f700e3d2b1bade3ed803219c592d62502a57363"
    },
  }
}
& {
  lib,
  drvs,
  libtraceevent | lib.MesonPackage = {
    singleSource = {
      uri = "https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/snapshot/libtraceevent-1.8.4.tar.gz",
      sha256sum = "dc456d4d2bf4b4cd4d0c737d3374a8093f9e5ca18c1d7fc2279a4bf41e613121"
    },
    extraMesonArgs = [
      "-Ddoc=false"
    ],
    biDrvs = [
      drvs.linuxHeaders
    ]
  }
}
& {
  lib,
  drvs,
  libtracefs | lib.MesonPackage = {
    singleSource = {
      uri = "https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/snapshot/libtracefs-1.8.2.tar.gz",
      sha256sum = "255980e1da5648fbbc32777ed8457b485b2b96f3449674610b46d9c437271209"
    },
    extraMesonArgs = [
      "-Ddoc=false"
    ],
    preConfigurePhase =
      let patchShebangs = (fun s =>
        m%"sed -i 's@\/bin\/bash@\/usr\/bin\/bash@g' ${SRC}/%{s}"%
      )
      in
      std.array.map
        patchShebangs
        [
          "samples/extract-example.sh",
          "Documentation/install-docs.sh.in",
          "check-manpages.sh",
        ],
    biDrvs = [
      drvs.linuxHeaders,
      drvs.libtraceevent,
      drvs.flex,
      drvs.bison,
      drvs.m4,
      drvs.bash,
    ]
  }
}
