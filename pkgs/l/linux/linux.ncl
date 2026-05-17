let
  getExtra = fun compress =>
    ([
      m%"
        echo "
        # CONFIG_PM_DEBUG is not set
        # CONFIG_PM_SLEEP_DEBUG is not set
        # CONFIG_AF_RXRPC_DEBUG is not set
        # CONFIG_FW_LOADER_DEBUG is not set
        # CONFIG_SCSI_DEBUG is not set
        # CONFIG_DM_DEBUG is not set
        # CONFIG_MLX4_DEBUG is not set
        # CONFIG_ATH5K_DEBUG is not set
        # CONFIG_ATH9K_COMMON_DEBUG is not set
        # CONFIG_ATH6KL_DEBUG is not set
        # CONFIG_IWLEGACY_DEBUG is not set
        # CONFIG_IWLWIFI_DEBUG is not set
        # CONFIG_NOUVEAU_DEBUG is not set
        # CONFIG_USB_SERIAL_DEBUG is not set
        # CONFIG_INFINIBAND_MTHCA_DEBUG is not set
        # CONFIG_INFINIBAND_IPOIB_DEBUG is not set
        # CONFIG_JFFS2_FS_DEBUG is not set
        # CONFIG_NFS_DEBUG is not set
        # CONFIG_SUNRPC_DEBUG is not set
        # CONFIG_CIFS_DEBUG is not set
        # CONFIG_AFS_DEBUG is not set
        # CONFIG_DLM_DEBUG is not set
        # CONFIG_DYNAMIC_DEBUG is not set
        # CONFIG_ARCH_HAS_EARLY_DEBUG is not set
        # CONFIG_SLUB_DEBUG is not set
        
        # CONFIG_UAPI_HEADER_TEST is not set
        # CONFIG_TIME_KUNIT_TEST is not set
        # CONFIG_NET_HANDSHAKE_KUNIT_TEST is not set
        # CONFIG_MPTCP_KUNIT_TEST is not set
        # CONFIG_PRP_DUP_DISCARD_KUNIT_TEST is not set
        # CONFIG_CFG80211_KUNIT_TEST is not set
        # CONFIG_MAC80211_KUNIT_TEST is not set
        # CONFIG_NETDEV_ADDR_LIST_TEST is not set
        # CONFIG_NET_TEST is not set
        # CONFIG_DRIVER_PE_KUNIT_TEST is not set
        # CONFIG_FW_CS_DSP_KUNIT_TEST is not set
        # CONFIG_EFI_TEST is not set
        # CONFIG_SCSI_LIB_KUNIT_TEST is not set
        # CONFIG_SCSI_PROTO_TEST is not set
        # CONFIG_FIREWIRE_KUNIT_UAPI_TEST is not set
        # CONFIG_FIREWIRE_KUNIT_PACKET_SERDES_TEST is not set
        # CONFIG_FIREWIRE_KUNIT_SELF_ID_SEQUENCE_HELPER_TEST is not set
        # CONFIG_FIREWIRE_KUNIT_OHCI_SERDES_TEST is not set
        # CONFIG_INPUT_KUNIT_TEST is not set
        # CONFIG_DRM_KUNIT_TEST is not set
        # CONFIG_SND_CORE_TEST is not set
        # CONFIG_SND_HDA_CIRRUS_SCODEC_KUNIT_TEST is not set
        # CONFIG_SND_SOC_TOPOLOGY_KUNIT_TEST is not set
        # CONFIG_SND_SOC_CARD_KUNIT_TEST is not set
        # CONFIG_SND_SOC_UTILS_KUNIT_TEST is not set
        # CONFIG_SND_SOC_OPS_KUNIT_TEST is not set
        # CONFIG_SND_SOC_INTEL_AVS_MACH_I2S_TEST is not set
        # CONFIG_SND_SOC_CS_AMP_LIB_TEST is not set
        # CONFIG_HID_KUNIT_TEST is not set
        # CONFIG_RTC_LIB_KUNIT_TEST is not set
        # CONFIG_CROS_KUNIT_EC_PROTO_TEST is not set
        # CONFIG_CLK_KUNIT_TEST is not set
        # CONFIG_CLK_FIXED_RATE_KUNIT_TEST is not set
        # CONFIG_CLK_GATE_KUNIT_TEST is not set
        # CONFIG_CLK_FD_KUNIT_TEST is not set
        # CONFIG_IIO_GTS_KUNIT_TEST is not set
        # CONFIG_IIO_RESCALE_KUNIT_TEST is not set
        # CONFIG_IIO_FORMAT_KUNIT_TEST is not set
        # CONFIG_MEAN_AND_VARIANCE_UNIT_TEST is not set
        # CONFIG_FAT_KUNIT_TEST is not set
        # CONFIG_RPCSEC_GSS_KRB5_KUNIT_TEST is not set
        # CONFIG_UNICODE_NORMALIZATION_KUNIT_TEST is not set
        # CONFIG_CRYPTO_TEST is not set
        # CONFIG_PACKING_KUNIT_TEST is not set
        # CONFIG_KFENCE_KUNIT_TEST is not set
        # CONFIG_LOCK_TORTURE_TEST is not set
        # CONFIG_TORTURE_TEST is not set
        # CONFIG_RCU_TORTURE_TEST is not set
        # CONFIG_KUNIT_TEST is not set
        # CONFIG_KUNIT_EXAMPLE_TEST is not set
        # CONFIG_CPUMASK_KUNIT_TEST is not set
        # CONFIG_KPROBES_SANITY_TEST is not set
        # CONFIG_ASYNC_RAID6_TEST is not set
        # CONFIG_PRINTF_KUNIT_TEST is not set
        # CONFIG_SCANF_KUNIT_TEST is not set
        # CONFIG_STRING_KUNIT_TEST is not set
        # CONFIG_STRING_HELPERS_KUNIT_TEST is not set
        # CONFIG_HASH_KUNIT_TEST is not set
        # CONFIG_RESOURCE_KUNIT_TEST is not set
        # CONFIG_SYSCTL_KUNIT_TEST is not set
        # CONFIG_KFIFO_KUNIT_TEST is not set
        # CONFIG_LIST_KUNIT_TEST is not set
        # CONFIG_HASHTABLE_KUNIT_TEST is not set
        # CONFIG_LINEAR_RANGES_TEST is not set
        # CONFIG_CMDLINE_KUNIT_TEST is not set
        # CONFIG_BITS_TEST is not set
        # CONFIG_SLUB_KUNIT_TEST is not set
        # CONFIG_RATIONAL_KUNIT_TEST is not set
        # CONFIG_MEMCPY_KUNIT_TEST is not set
        # CONFIG_IS_SIGNED_TYPE_KUNIT_TEST is not set
        # CONFIG_OVERFLOW_KUNIT_TEST is not set
        # CONFIG_STACKINIT_KUNIT_TEST is not set
        # CONFIG_FORTIFY_KUNIT_TEST is not set
        # CONFIG_LONGEST_SYM_KUNIT_TEST is not set
        # CONFIG_CRC_KUNIT_TEST is not set
        # CONFIG_SIPHASH_KUNIT_TEST is not set
        # CONFIG_USERCOPY_KUNIT_TEST is not set
        # CONFIG_BLACKHOLE_DEV_KUNIT_TEST is not set
        # CONFIG_INT_POW_KUNIT_TEST is not set
        # CONFIG_INT_SQRT_KUNIT_TEST is not set
        # CONFIG_INT_LOG_KUNIT_TEST is not set
        # CONFIG_GCD_KUNIT_TEST is not set
        # CONFIG_PRIME_NUMBERS_KUNIT_TEST is not set
        " > /tmp/workdir/build/no-test-no-debug.diffconfig
        "%,
      "./scripts/kconfig/merge_config.sh -m -r .config /tmp/workdir/build/no-test-no-debug.diffconfig",
      m%"
        echo "
        # CONFIG_JFS_FS is not set
        # CONFIG_XFS_FS is not set
        # CONFIG_GFS2_FS is not set
        # CONFIG_OCFS2_FS is not set
        # CONFIG_NILFS2_FS is not set
        # CONFIG_ORANGEFS_FS is not set
        # CONFIG_HFS_FS is not set
        # CONFIG_HFSPLUS_FS is not set
        # CONFIG_JFFS2_FS is not set
        # CONFIG_UBIFS_FS is not set
        # CONFIG_UFS_FS is not set
        # CONFIG_CEPH_FS is not set
        " > /tmp/workdir/build/fewer-fs.diffconfig
        "%,
      "./scripts/kconfig/merge_config.sh -m -r .config /tmp/workdir/build/fewer-fs.diffconfig",
      m%"
        echo "
        # CONFIG_KERNEL_BZIP2 is not set
        # CONFIG_KERNEL_GZIP is not set
        # CONFIG_KERNEL_LZ4 is not set
        # CONFIG_KERNEL_LZMA is not set
        # CONFIG_KERNEL_LZO is not set
        %{if compress then "# CONFIG_KERNEL_UNCOMPRESSED is not set" else "CONFIG_HAVE_KERNEL_UNCOMPRESSED=y\nCONFIG_KERNEL_UNCOMPRESSED=y" }
        # CONFIG_KERNEL_XZ is not set
        %{if compress then "CONFIG_KERNEL_ZSTD=y" else "# CONFIG_KERNEL_ZSTD is not set\n# CONFIG_KERNEL_BZIP2 is not set" }
        CONFIG_MODULE_COMPRESS=y
        # CONFIG_MODULE_COMPRESS_GZIP is not set
        # CONFIG_MODULE_COMPRESS_NONE is not set
        # CONFIG_MODULE_COMPRESS_XZ is not set
        CONFIG_MODULE_COMPRESS_ZSTD=y
        " > /tmp/workdir/build/compression.diffconfig
        "%,
      "./scripts/kconfig/merge_config.sh -m -r .config /tmp/workdir/build/compression.diffconfig",
      m%"
        echo "
        # CONFIG_INFINIBAND is not set
        # CONFIG_XEN is not set
        # CONFIG_INTEL_TDX_GUEST is not set
        # CONFIG_NUMA is not set
        # CONFIG_EFI_MIXED is not set
        # CONFIG_LEGACY_VSYSCALL_NONE is not set
        # CONFIG_UEVENT_HELPER is not set
        # CONFIG_VMWARE_BALLOON is not set
        # CONFIG_VMWARE_VMCI is not set
        # CONFIG_VMWARE_BALLOON is not set
        # CONFIG_VMWARE_VMCI_VSOCKETS is not set
        # CONFIG_VMWARE_PVSCSI is not set
        # CONFIG_XEN_SCSI_FRONTEND is not set
        # CONFIG_HYPERV is not set
        # CONFIG_XEN_VIRTIO is not set
        # CONFIG_VBOXGUEST is not setxorr
        # CONFIG_VBOXSF_FS is not set
        # CONFIG_DRM_VBOXVIDEO is not set
        # CONFIG_DRM_BOCHS is not set
        # CONFIG_DRM_CIRRUS_QEMU is not set
        # CONFIG_DRM_VMWGFX is not set
        # CONFIG_DRM_HYPERV is not set
        # CONFIG_DRM_LEGACY is not set
        CONFIG_NTSYNC=y
        # CONFIG_X86_DECODER_SELFTEST is not set
        " > /tmp/workdir/build/misc.diffconfig
        "%,
      "./scripts/kconfig/merge_config.sh -m -r .config /tmp/workdir/build/misc.diffconfig",
    ]
    ),
  kconfigFiles = {
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
    },
    alpine = {
      sha256sum = "8792ae332a0ff10bcef9a48b34cb4e653aa9f9699d434819f41ed8b4658e3f6c",
      file = "alpine-stable.x86_64.config",
    }
  }
in

{
  lib,
  drvs,
  _linuxSources = {
    "6.17.6" = {
      uri = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.17.6.tar.xz",
      sha256sum = "8ecfbc6b693448abb46144a8d04d1e1631639c7661c1088425a2e5406f13c69c",
    },
    "6.18.0" = {
      uri = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.18.tar.xz",
      sha256sum = "9106a4605da9e31ff17659d958782b815f9591ab308d03b0ee21aad6c7dced4b",
    },
    "6.18.8" = {
      uri = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.18.8.tar.xz",
      sha256sum = "37f0c5d5c242c1d604e87d48f08795e861a5a85f725b4ca11d0a538f12ff8cff",
    },
    "6.19.0" = {
      uri = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.19.tar.xz",
      sha256sum = "303079a8250b8f381f82b03f90463d12ac98d4f6b149b761ea75af1323521357",
    },
    "7.0.8" = {
      uri = "https://cdn.kernel.org/pub/linux/kernel/v7.x/linux-7.0.8.tar.xz",
      sha256sum = "1945afb22c9f4f7c78d971210f3bbb7deb09f5d8c41a38bfac772de25f6dcb22",
    },
  },
  linuxHeaders,
  libModulesDirectory | lib.Package = {
    name = "lib-modules-directory",
    installPhase = [
      "install -d -m0755 ${DEST}/lib/modules/6.10.0-standard"
    ],
  },
  linuxFedora =
    linux
    & {
      options.configFile = kconfigFiles.fedora610,
    },
  linuxFedoraUncompressed =
    linux
    & {
      options.configFile = kconfigFiles.fedora610,

      options.compress = false
    },
  linux | lib.MakePackage =
    # let baseConfig = kconfigFiles.fedora
    # let baseConfig = kconfigFiles.fedora610

    # let baseConfig = kconfigFiles.base
    # let baseConfig = kconfigFiles.voidlinux
    let baseConfig = kconfigFiles.alpine
    in
    {
      singleSource = _linuxSources."%{options.version}",
      unpackPhase = [
        "tar xf /tmp/workdir/packed/%{singleSource.sha256sum}/%{std.string.split "/" singleSource.uri |>std.array.last } -C /tmp/workdir/src --strip-components=1",
      ],

      options = {
        # version = linuxHeaders.options.version ,
        # version = "6.17.6",
        # version = "6.18.0",
        # version = "6.18.8",
        # version = "6.19.0",
        version = "7.0.8",
        compress | default = true,
      },
      buildDir = "/tmp/workdir/src",
      # enableParallel = false,
      separateBuildDir = true,
      buildEnv,
      makeArgs,
      options = {
        configFile | default = baseConfig,
      },
      extraFiles = [
        options.configFile,
      ],
      # buildEnv = {
      #   EXTRA_CFLAGS = ["-Wno-unused-but-set-parameter"],
      # },

      extraEnv = {
        KBUILD_BUILD_TIMESTAMP = "''",
        HOSTLDFLAGS = "%{ lib.functions.varToExportvar (buildEnv.LDFLAGS @ ["-lz","-leu"] )}",
        # HOSTCFLAGS = "%{ lib.functions.varToExportvar  ( [ "-nostdinc"] @ buildEnv.CFLAGS)}",
        # HOSTCFLAGS=m%""-I./usr/include""%,
        HOSTCFLAGS = m%""-I./arch/x86/include""%,
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
        "MODLIB=${DEST}/usr/lib/modules/%{options.version}-standard",
      ],
      makeInstallTargets = ["modules_install"],

      # CONFIG_LZ4_COMPRESS=y
      # CONFIG_LZ4HC_COMPRESS=y
      # CONFIG_MODULE_COMPRESS_ZSTD=y

      # CONFIG_HYPERVISOR_GUEST is not set

      preBuildPhase =
        [
          "cp /tmp/workdir/files/%{options.configFile.file} .config",

          # https://lists.freedesktop.org/archives/amd-gfx/2024-May/109223.html
          # m%"sed -i 's@__counted_by(ucNumEntries)@@g' ./drivers/gpu/drm/radeon/pptable.h"%,

          # https://github.com/umlaeute/v4l2loopback/discussions/604 

          # TODO: CONFIG_CMDLINE_OVERRIDE=y

          # add a command line with 1000 characters that can be replaces using sed
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

        CONFIG_IKCONFIG_PROC=y
        CONFIG_IKCONFIG=y
        CONFIG_DRM_WERROR=n

        CONFIG_CMDLINE_BOOL=y
        CONFIG_CMDLINE=\"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\"

        " > /tmp/workdir/build/v4l2loopback.diffconfig
        "%,
        ]
        @ (getExtra options.compress)
        @ [
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
        "install -m0755 arch/x86/boot/vmlinux.bin  ${DEST}/boot",
        "install -m0755 arch/x86/boot/setup.bin  ${DEST}/boot",
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

        #libModulesDirectory,
        #drvs.libarchive,
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
      options,
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
        "MODLIB=${DEST}/usr/lib/modules/%{options.version}",
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
      biDrvs | force = [
        drvs.busybox,
        drvs.gnumake,
        drvs.ccacheBin,
        drvs.llvm,
        drvs.muslAarch64,
        drvs.musl,
        drvs.libcxxAarch64,
        drvs.linuxHeadersAarch64,
        drvs.linuxHeaders,
        drvs.perl,
        drvs.m4,
        drvs.libtool,
        drvs.openssl, # tgt?
        drvs.zlibNg, # tgt?
        drvs.xz,
        drvs.flex,
        drvs.bison,
        drvs.libelf,
        drvs.diffutils,
        drvs.zstd,
        drvs.lz4,
        drvs.kmod, #, libModulesDirectory,
        #, drvs.libarchive,
        drvs.pythonFull,
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
