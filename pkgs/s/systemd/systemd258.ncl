{
  lib,
  drvs,
  systemd258 | lib.MesonPackage = {
    singleSource = {
      # uri = "https://github.com/systemd/systemd/archive/refs/tags/v257.8.tar.gz",
      # sha256sum = "f280278161446fe3838bedb970c7b3998043ad107f7627735a81483218c6f6f9",
      # uri = "https://github.com/systemd/systemd/archive/refs/tags/v258-rc3.tar.gz",
      # sha256sum = "302ea319d7264cd1f26e1eb10d29d5d1d1a5ab98cde63f719922bfd150b63ac1",

      uri = "https://github.com/systemd/systemd/archive/refs/tags/v258.1.tar.gz",
      sha256sum = "8eb34eaf2f78330217280bd7a923578f37e28d3f3ac5168e336ebc9cad84a34d"
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

    patches = [
      {
        sha256sum = "d52024f1c44c97e197dd51b864d115fd636a47a63d32a92b888368b9049612a3",
        file = "systemd-link-kmod-2.patch"
      },
      {
        sha256sum = "cc680fbfa14a0dc9ef7d654946331f9776332d0fdf44aa65e2c76ae3de439d39",
        file = "systemd-nss.patch"
      }
    ],
    patchPhase = [],
    preConfigurePhase = [
      "(cd ${SRC} && patch -p1 < 37788.patch)",
      "(cd ${SRC} && patch -p1 < /tmp/workdir/patches/systemd-link-kmod-2.patch)",
      "(cd ${SRC} && patch -p1 < /tmp/workdir/patches/systemd-nss.patch)",
      m%"sed -i "s|libshared = shared_library(|libshared = shared_library( 'shared' +|g" ${SRC}/src/shared/meson.build"%,
      m%"sed -i "s|libcore = shared_library(|libcore = shared_library( 'shared' +|g" ${SRC}/src/core/meson.build"%,
      m%"sed -i "s|libudev = shared_library(|libudev = shared_library( 'shared' + |g" ${SRC}/meson.build"%,

      # m%"sed -i "s|runtest_env = custom_target(|libudev = install_libudev_static\nruntest_env = custom_target(|g" ${SRC}/meson.build"%,
      "for f in $(find ${SRC} -name meson.build); do sed -i 's|shared_library|library|g' ${f};done",
      m%"sed -i 's|"/run/systemd/system/"|"/run/"|g' ${SRC}/src/libsystemd/sd-daemon/sd-daemon.c"%,

      # m%"sed -i 's|manager_varlink_init(m, TAKE_FD(varlink_fd))|0|g' ${SRC}/src/login/logind.c"%,
      m%"sed -i 's|leader.fd < 0|0==1|g' ${SRC}/src/login/logind-dbus.c"%,
    ],
    debug = true,
    extraMesonArgs =
      [
        "-Dlibc=musl",
        # "-Dblkid=disabled",
        # "-Drepart=disabled",
        "-Dtests=false",
        "-Dsplit-bin=false",
        # "-Dmode=release",
        "-Dstandalone-binaries=true",
        # "-Dstatic-libsystemd=true",
        "-Dstatic-libudev=no-pic",
        "-Dkmod-path=/usr/bin/kmod",
        "-Dkmod=enabled",
        # "-Dlibarchive=disabled",
        "-Dzstd=disabled",
        "-Dxz=disabled",
        "-Dlz4=disabled",
        "-Dzlib=disabled",
        "-Duserdb=true",
        "-Danalyze=false",
        "-Dfirstboot=false",
        "-Dinitrd=false",
        "-Dutmp=false",
        "-Dhibernate=false",
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

    # buildPhase = [
    #   "ninja systemd-logind",
    #   "ninja udev",
    # ],

    # installPhase =[
    #   "ninja install-systemd-logind",

    #   "ninja install-udev",
    # ],

    postInstallPhase = [
      "(cd ${DEST}/usr/bin && ln -s ../lib/systemd/systemd-udevd udevd)",
      "install -d -m0755 ${DEST}/usr/libexec",
      "(cd ${DEST}/usr/libexec && ln -s ../lib/systemd/systemd-logind elogind)",
    ],

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
      drvs.openssl,
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
      drvs.utilLinux,
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
