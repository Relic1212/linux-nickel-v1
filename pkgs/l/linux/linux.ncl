let kconfigFiles = {
  fedora = {
    file = "kernel-x86_64-fedora.config",

    sha256sum = "c6c4db5b937a8f37538d82c05c55502d0c7f2ac0189647603e65cbbd1d82c310"
  },
  fedora610 = {
    file = "kernel-6.10-x86_64-fedora.config",
    sha256sum = "9483b9ef26420d6cc045dcf403d55285a7960660d1498815ed3eb2f296e73f80",
  },
  base = {
    file = "base.config",
    sha256sum = "f7bf3b7788114605b646ad05e1e0c8d337dc7aa325af7773e3e63de37c4ff2b3"
  },
  voidlinux = {
    file = "void-linux-x86_64-dotconfig",
    sha256sum = "df510058c1cafcb7c5adc118bf6087806fc018a0e0f227b12a7ba50ff8b4816c",
  }
}
in

{
  lib,
  pkgs,
  drvs,
  libModulesDirectory | lib.Package = {
    name = "lib-modules-directory",
    installPhase = [
      "install -d -m0755 ${DEST}/lib/modules/6.10.0-standard"
    ],
  },
  linux | lib.MakePackage =
    # let baseConfig = kconfigFiles.fedora
    let baseConfig = kconfigFiles.fedora610

    # let baseConfig = kconfigFiles.base
    # let baseConfig = kconfigFiles.voidlinux
    in
    {
      name = "linux",
      sourceInputs = pkgs.linuxHeaders.sourceInputs,
      buildDir = "/tmp/workdir/src",
      separateBuildDir = true,
      buildEnv,
      makeArgs,
      extraFiles = [
        baseConfig
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

      #       CONFIG_LZ4_COMPRESS=y
      # CONFIG_LZ4HC_COMPRESS=y
      # CONFIG_MODULE_COMPRESS_ZSTD=y
      preBuildPhase = [
        "cp /tmp/workdir/files/%{baseConfig.file} .config",

        # https://lists.freedesktop.org/archives/amd-gfx/2024-May/109223.html
        m%"sed -i 's@__counted_by(ucNumEntries)@@g' ./drivers/gpu/drm/radeon/pptable.h"%,

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

        CONFIG_BLK_DEV=y
        CONFIG_BLK_DEV_DM=y
        CONFIG_BLK_DEV_LOOP=y
        CONFIG_BLK_DEV_MD=y
        CONFIG_BLK_DEV_NVME=y
        CONFIG_DM_INIT=y
        CONFIG_DM_VERITY=y
        CONFIG_DM_VERITY_FEC=y
        CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG=y
        CONFIG_EFIVAR_FS=y
        CONFIG_EFI_STUB=y
        CONFIG_EROFS_FS=y
        CONFIG_EROFS_FS_POSIX_ACL=y
        CONFIG_EROFS_FS_SECURITY=y
        CONFIG_EROFS_FS_XATTR=y
        CONFIG_EROFS_FS_ZIP=y
        CONFIG_EROFS_FS_ZIP_DEFLATE=y
        CONFIG_EROFS_FS_ZIP_LZMA=y
        CONFIG_FAT_DEFAULT_UTF8=y
        CONFIG_FAT_FS=y
        CONFIG_FS_VERITY=y
        CONFIG_FS_VERITY_BUILTIN_SIGNATURES=y
        CONFIG_FUSE_FS=y
        CONFIG_MD=y
        CONFIG_MMC=y
        CONFIG_NLS=y
        CONFIG_NLS_CODEPAGE_437=y
        CONFIG_NVME_CORE=y
        CONFIG_OVERLAY_FS=y
        CONFIG_USB_STORAGE=y
        CONFIG_VFAT_FS=y
        CONFIG_LOCALVERSION=\"-standard\"

        CONFIG_IKHEADERS=n
        CONFIG_DEBUG_INFO_BTF=n

        CONFIG_KEY_DH_OPERATIONS=y
        CONFIG_CRYPTO_USER_API_SKCIPHER=y
        CONFIG_CRYPTO_USER_API_HASH=y
        CONFIG_CRYPTO_HMAC=y
        CONFIG_CRYPTO_CMAC=y
        CONFIG_CRYPTO_MD4=y
        CONFIG_CRYPTO_MD5=y
        CONFIG_CRYPTO_SHA256=y
        CONFIG_CRYPTO_SHA512=y
        CONFIG_CRYPTO_AES=y
        CONFIG_CRYPTO_ECB=y
        CONFIG_CRYPTO_DES=y
        CONFIG_CRYPTO_CBC=y

        CONFIG_EXT4_FS=y

        CONFIG_SCSI_COMMON=y
        CONFIG_SCSI_DMA=y
        CONFIG_SCSI_MOD=y
        CONFIG_SCSI_PROC_FS=y
        CONFIG_VIRTIO_BLK=y
        CONFIG_VIRTIO_PCI=y

        CONFIG_MODPROBE_PATH=\"/usr/bin/modprobe\"

        CONFIG_FB_DEVICE=y
        CONFIG_INPUT_UINPUT=y

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
        drvs.pythonFull,
        (drvs.findutils & { priority = 1 }),
        (drvs.mawk & { priority = 1 }),
        drvs.basefiles,

        #, libModulesDirectory,
        #, drvs.libarchive,
      ],
    },
  linuxAarch64 =
    linux
    & {
      makeArgs,
      extraFiles | priority 1 = [
        {
          file = "kernel-aarch64-fedora.config",
          sha256sum = "4900e8c622364d7a4d5277114b96c3109328e2d4fd445b7202d291d291caa7da"
        },
        {
          file = "aarch64.diffconfig",
          sha256sum = "37aa93710a130d538512088a4a0336b57409590db8b28d05bdc11555b7b0cc09"
        }
      ],
      extraMakeArgs | priority 1 = [
        "ARCH=arm64",
        "LLVM=1",
      ],
      buildEnv.TARGET = "aarch64-unknown-linux-musl",
      buildEnv.READELF = "readelf",

      buildEnv.EXTRA_LDFLAGS = ["--verbose", " -nostdlib"],
      extraMakeInstallArgs | priority 1 = [
        "INSTALL_MOD_STRIP=1",
        "LLVM=1",
        "INSTALL_MOD_PATH=${DEST}",
        "ARCH=arm64",
        # "DEPMOD=\"/usr/bin/kmod depmod\"",
        "DEPMOD=true",

        # "DEPMOD=\"/usr/bin/depmod -b /tmp/workdir/out/destdir\"",
        "MODLIB=${DEST}/usr/lib/modules/6.10.0",
      ],
      preBuildPhase | priority 1 = [

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
      postInstallPhase | priority 1 = [
        # "KVER=\"$(ls /tmp/workdir/out/destdir/lib/modules/)\"",
        # "depmod -b /tmp/workdir/out/destdir  ${KVER}",
        # "install -d -m0755 ${DEST}/",
        "cp -r arch/arm64/boot/ ${DEST}/boot",
      ],
      extraEnv | force = {
        KBUILD_BUILD_TIMESTAMP = "''",
        HOSTLDFLAGS = "%{ lib.functions.varToExportvar (buildEnv.STATIC_LDFLAGS @ ["-lz"] )}",
        HOSTCFLAGS = "%{ lib.functions.varToExportvar  buildEnv.STATIC_CFLAGS}",
      },

      utilsProviders = [],
      baseBuildinputPackages = [],
      biDrvs | force =
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
      extraFiles | priority 2 = [
        {
          file = "virt.aarch64.config",
          sha256sum = "0ab7f1c60987bac0a7f957d10f34f2d58f26ce5f3de1e8c4baf1fc4ccb920305"
        }
      ],
      preBuildPhase | priority 2 = [
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
