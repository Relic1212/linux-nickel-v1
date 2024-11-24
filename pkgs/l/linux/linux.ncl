{
  lib,
  pkgs,
  drvs,
  libModulesDirectory | lib.Package
    = {
      name = "lib-modules-directory",
      installPhase = [
        "install -d -m0755 ${DEST}/lib/modules/6.10.0-standard"
      ],
    },
  linux | lib.MakePackage
    = {
      name = "linux",
      sourceInputs = pkgs.linuxHeaders.sourceInputs,
      buildDir = "/tmp/workdir/src",
      separateBuildDir = true,
      buildEnv,
      makeArgs,
      extraFiles = [
        {
          file = "base.config",
          sha256sum = "f7bf3b7788114605b646ad05e1e0c8d337dc7aa325af7773e3e63de37c4ff2b3"
        },
      ],

      extraEnv = {
        KBUILD_BUILD_TIMESTAMP = "''",
        HOSTLDFLAGS = "%{ lib.functions.varToExportvar (buildEnv.LDFLAGS @ ["-lz"] )}",
        HOSTCFLAGS = "%{ lib.functions.varToExportvar  buildEnv.CFLAGS}",
      },
      extraMakeArgs = [
        "LLVM=1",

        #    "HOSTLDFLAGS=%{ lib.functions.varToExportvar buildEnv.LDFLAGS} \\\n",
        #  "HOSTCFLAGS=%{ lib.functions.varToExportvar  buildEnv.CFLAGS} \\\n",
      ],
      extraMakeInstallArgs = [
        "-j$(nproc)",
        "INSTALL_MOD_STRIP=1",
        "LLVM=1",
        "INSTALL_MOD_PATH=/tmp/workdir/out/destdir",
        #"DEPMOD=true",
        "MODLIB=${DEST}/usr/lib/modules/6.10.0-standard",
      ],
      makeInstallTargets = ["modules_install"],
      preBuildPhase = [
        "cp /tmp/workdir/files/base.config .config",
        # https://github.com/umlaeute/v4l2loopback/discussions/604
        m%"
        echo "
        CONFIG_V4L2_FWNODE=m
        CONFIG_V4L_MEM2MEM_DRIVERS=y
        CONFIG_V4L_PLATFORM_DRIVERS=y
        CONFIG_V4L_TEST_DRIVERS=y
        CONFIG_VIDEO=y
        CONFIG_VIDEOBUF2_CORE=m
        CONFIG_VIDEOBUF2_MEMOPS=m
        CONFIG_VIDEOBUF2_V4L2=m
        CONFIG_VIDEOBUF2_VMALLOC=m
        CONFIG_VIDEO_DEV=m
        " > /tmp/workdir/build/v4l2loopback.diffconfig
        "%,
        "./scripts/kconfig/merge_config.sh -m -r -y .config /tmp/workdir/build/v4l2loopback.diffconfig",
        "make "
        ++ (std.string.join " " makeArgs)
        ++ " HOSTLDFLAGS=%{ lib.functions.varToExportvar buildEnv.LDFLAGS} "
        ++ " HOSTCFLAGS=%{ lib.functions.varToExportvar  buildEnv.CFLAGS}"
        ++ " olddefconfig",

        # "mkdir /tmp/workdir/build/bin",
        # "cp /usr/bin/bsdtar /tmp/workdir/build/bin/tar",
        # "export PATH=/tmp/workdir/build/bin:${PATH}"
      ],
      postInstallPhase = [
        # "KVER=\"$(ls /tmp/workdir/out/destdir/lib/modules/)\"",
        # "depmod -b /tmp/workdir/out/destdir  ${KVER}",
        "install -d -m0755 ${DEST}/boot",
        "install -m0755 arch/x86/boot/bzImage  ${DEST}/boot",
      ],
      biDrvs = [
        drvs.perl,
        drvs.m4,
        drvs.libtool,
        drvs.openssl,
        drvs.zlibNg,
        drvs.xz,
        drvs.flex,
        drvs.bison,
        drvs.linuxHeaders,
        drvs.libelf,
        (drvs.diffutils & { priority = 1 }),
        drvs.zstd,
        drvs.lz4,
        (drvs.kmod & { priority = 1 }),
        #, libModulesDirectory,
        #, drvs.libarchive,
      ],
    },
  linuxAarch64 =
    linux
    & {
      makeArgs,
      extraFiles | priority 1
        = [
          {
            file = "kernel-aarch64-fedora.config",
            sha256sum = "4900e8c622364d7a4d5277114b96c3109328e2d4fd445b7202d291d291caa7da"
          },
          {
            file = "aarch64.diffconfig",
            sha256sum = "37aa93710a130d538512088a4a0336b57409590db8b28d05bdc11555b7b0cc09"
          }
        ],
      extraMakeArgs | priority 1
        = [
          "ARCH=arm64",
          "LLVM=1",
        ],
      buildEnv.TARGET = "aarch64-unknown-linux-musl",
      buildEnv.READELF = "readelf",

      buildEnv.EXTRA_LDFLAGS = ["--verbose", " -nostdlib"],
      extraMakeInstallArgs | priority 1
        = [
          "INSTALL_MOD_STRIP=1",
          "LLVM=1",
          "INSTALL_MOD_PATH=${DEST}",
          "ARCH=arm64",
          # "DEPMOD=\"/usr/bin/kmod depmod\"",
          "DEPMOD=true",

          # "DEPMOD=\"/usr/bin/depmod -b /tmp/workdir/out/destdir\"",
          "MODLIB=${DEST}/usr/lib/modules/6.10.0",
        ],
      preBuildPhase | priority 1
        = [

          # https://lists.freedesktop.org/archives/amd-gfx/2024-May/109223.html
          m%"sed -i 's@__counted_by(ucNumEntries)@@g' ./drivers/gpu/drm/radeon/pptable.h"%,
          m%"sed -i 's@llvm-readelf@readelf@g' Makefile"%,

          # "cp /tmp/workdir/files/kernel-aarch64-fedora.config .config",
          "make "
          ++ (std.string.join " " makeArgs)
          ++ " HOSTLDFLAGS=%{ lib.functions.varToExportvar buildEnv.STATIC_LDFLAGS} "
          ++ " HOSTCFLAGS=%{ lib.functions.varToExportvar  buildEnv.STATIC_CFLAGS}"
          ++ " defconfig",
          "./scripts/kconfig/merge_config.sh -m -r -y .config /tmp/workdir/files/aarch64.diffconfig ",

          # https://wiki.gentoo.org/wiki/Hardkernel_ODROID-N2
          # "perl -pi -e 's/CONFIG_ARCH_[^_]*=y|.*(DEBUG|NOUVEAU).*//g' .config",
          "make "
          ++ (std.string.join " " makeArgs)
          ++ " HOSTLDFLAGS=%{ lib.functions.varToExportvar buildEnv.STATIC_LDFLAGS} "
          ++ " HOSTCFLAGS=%{ lib.functions.varToExportvar  buildEnv.STATIC_CFLAGS}"
          ++ " olddefconfig",

          # "mkdir /tmp/workdir/build/bin",
          # "cp /usr/bin/bsdtar /tmp/workdir/build/bin/tar",
          # "export PATH=/tmp/workdir/build/bin:${PATH}"
        ],
      postInstallPhase | priority 1
        = [
          # "KVER=\"$(ls /tmp/workdir/out/destdir/lib/modules/)\"",
          # "depmod -b /tmp/workdir/out/destdir  ${KVER}",
          # "install -d -m0755 ${DEST}/",
          "cp -r arch/arm64/boot/ ${DEST}/boot",
        ],
      extraEnv | force
        = {
          KBUILD_BUILD_TIMESTAMP = "''",
          HOSTLDFLAGS = "%{ lib.functions.varToExportvar (buildEnv.STATIC_LDFLAGS @ ["-lz"] )}",
          HOSTCFLAGS = "%{ lib.functions.varToExportvar  buildEnv.STATIC_CFLAGS}",
        },

      utilsProviders = [],
      baseBuildinputPackages = [],
      biDrvs | force
        =
          lib.biMap [
            pkgs.busybox,
            pkgs.gnumake,
            pkgs.ccacheBin,
            pkgs.llvm,
            pkgs.muslAarch64,
            pkgs.musl,
            pkgs.libcxxAarch64,
            pkgs.linuxHeadersAarch64,
            pkgs.linuxHeaders,
            pkgs.perl,
            pkgs.m4,
            pkgs.libtool,
            pkgs.openssl, # tgt?
            pkgs.zlibNg, # tgt?
            pkgs.xz,
            pkgs.flex,
            pkgs.bison,
            pkgs.libelf,
            pkgs.diffutils,
            pkgs.zstd,
            pkgs.lz4,
            pkgs.kmod, #, libModulesDirectory,
            #, pkgs.libarchive,
            pkgs.pythonFull,
          ],
    },
  linuxAarch64Virt =
    linuxAarch64
    & {
      makeArgs,
      buildEnv,
      extraFiles | priority 2
        = [
          {
            file = "virt.aarch64.config",
            sha256sum = "0ab7f1c60987bac0a7f957d10f34f2d58f26ce5f3de1e8c4baf1fc4ccb920305"
          }
        ],
      preBuildPhase | priority 2
        = [
          # "cp /tmp/workdir/files/virt.aarch64.config .config",

          # https://lists.freedesktop.org/archives/amd-gfx/2024-May/109223.html
          m%"sed -i 's@__counted_by(ucNumEntries)@@g' ./drivers/gpu/drm/radeon/pptable.h"%,
          "make "
          ++ (std.string.join " " makeArgs)
          ++ " HOSTLDFLAGS=%{ lib.functions.varToExportvar buildEnv.STATIC_LDFLAGS} "
          ++ " HOSTCFLAGS=%{ lib.functions.varToExportvar  buildEnv.STATIC_CFLAGS}"
          ++ " defconfig",

          # "mkdir /tmp/workdir/build/bin",
          # "cp /usr/bin/bsdtar /tmp/workdir/build/bin/tar",
          # "export PATH=/tmp/workdir/build/bin:${PATH}"
        ],
    }
}
