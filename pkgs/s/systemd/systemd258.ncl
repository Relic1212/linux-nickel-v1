{
  lib,
  drvs,
  systemd258 | lib.MesonPackage = {
    singleSource = {
      # uri = "https://github.com/systemd/systemd/archive/refs/tags/v257.8.tar.gz",
      # sha256sum = "f280278161446fe3838bedb970c7b3998043ad107f7627735a81483218c6f6f9",
      uri = "https://github.com/systemd/systemd/archive/refs/tags/v258-rc3.tar.gz",
      sha256sum = "302ea319d7264cd1f26e1eb10d29d5d1d1a5ab98cde63f719922bfd150b63ac1"
    },
    sourceInputs = [
      { src = singleSource },
      {
        src = {
          uri = "https://patch-diff.githubusercontent.com/raw/systemd/systemd/pull/37788.patch",
          sha256sum = "112d78c71347cdc13cf3ad2e26dcc18a6beb169d154a21da8d4126ef9cef9709"
        }
      }
    ],
    preConfigurePhase = [
      "(cd ${SRC} && patch -p1 < 37788.patch)",
      m%"sed -i "s|libshared = shared_library(|libshared = shared_library( 'shared' +|g" ${SRC}/src/shared/meson.build"%,
      m%"sed -i "s|libcore = shared_library(|libcore = shared_library( 'shared' +|g" ${SRC}/src/core/meson.build"%,
      "for f in $(find ${SRC} -name meson.build); do sed -i 's|shared_library|library|g' ${f};done",
    ],
    extraMesonArgs =
      [
        "-Dlibc=musl",
        # "-Dblkid=disabled",
        # "-Drepart=disabled",
        "-Dtests=false",
        "-Dsplit-bin=false",
        "-Dmode=release",
        "-Dstandalone-binaries=true",
        # "-Dstatic-libsystemd=true",
        # "-Dstatic-libudev=true",
      ]
      @ (
        std.array.map
          (fun l => "-Dlink-%{l}-shared=false")
          [
            "udev",
            "executor",
            "systemctl",
            "networkd",
            "timesyncd",
            "journalctl",
            "boot",
            "portabled"
          ]
      ),

    biDrvs = [
      drvs.acl,
      drvs.dbus,
      drvs.zlibNg,
      drvs.zstd,
      drvs.xz,
      drvs.gettext,
      drvs.basefiles,
      drvs.gnugrep,
      drvs.kmod,
      drvs.libcap,
      drvs.pythonDynamic,
      drvs.pythonJinja2,
      # drvs.bash,
      # drvs.coreutils,
      drvs.muslShared,
      drvs.pythonFlitCore,
      drvs.pythonMarkupsafe,
      drvs.linuxHeaders,
      drvs.gperf,
      drvs.pythonElftools,
      drvs.muslGetent,
      drvs.utilLinux241,
      drvs.libarchive,
      drvs.busyboxMiscUtils,
      #   drvs.diffutils,
    ],
    # pulls in static python otherwise
    baseBuildinputPackages = [
      drvs.bash,
      drvs.coreutils,
      drvs.bashSh,
      drvs.meson,
      drvs.samurai,
      drvs.pkgconf,
      drvs.musl,
      drvs.llvm,
      drvs.ccacheBin,
    ],
  },

  systemd258Pam =
    systemd258
    & {
      biDrvs | priority 1 = systemd258.biDrvs @ [drvs.libpam131]
    }
}
