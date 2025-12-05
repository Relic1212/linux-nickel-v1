{
  lib,
  drvs,
  vboot | lib.MakePackage = {
    singleSource = {
      # commit 3f94e2c7ed58c4e67d6e7dc6052ec615dbbb9bb4
      # uri = "https://github.com/coreboot/vboot/archive/refs/heads/release-R133-16151.B.tar.gz",
      # sha256sum = "248d280b5b4e1891c1025cee9250c961c5004e0272e8cafce6b21475c54b1fea",

      uri = "https://chromium.googlesource.com/chromiumos/platform/vboot_reference.git",
      sha256sum = "5d6a647a1f294eda096d3b4d4e65baf2f8e76dfd",
      fetchMethod = "git",
    },
    buildEnv = {
      EXTRA_LDFLAGS = [
        "$(pkg-config --static --libs musl-fts)",
        "$(pkg-config --static --libs libudev)",
      ],
    },
    # preConfigurePhase = [
    #   m%"sed -i 's@-Wno-format-security@-Wno-format-security -Wno-uninitialized-const-pointer@g' ${SRC}/Makefile"%,
    # ],
    patches = [
      {
        sha256sum = "0fba023235fb616ad55c137ee658b5cad871f99f0bbe0a7117c9427dfd9d3684",
        file = "vboot.patch"
      },
    ],
    makeTargets = [
      "fwlib",
      "futil",
      "utillib",
      "hostlib",
      "cgpt",
      "tlcl",
      "util_files",
    ],
    # makeInstallTargets = [
    #   "cgpt_install",
    #   "signing_install",
    #   "futil_install",
    #   # "pc_files_install",
    # ],
    biDrvs = [
      drvs.linuxHeaders,
      drvs.pkgconfMeson,
      drvs.perl,
      drvs.openssl,
      drvs.muslFts,
      drvs.eudev,
      drvs.glib,
      drvs.gperf,
      drvs.jansson,
      drvs.kmod,
      drvs.libffi,
      drvs.libusb,
      drvs.pciutils,
      drvs.pcre2,
      drvs.utilLinux,
      drvs.xz,
      drvs.zlibNg,
      drvs.zstd,
      drvs.flashrom,
      drvs.bash,
      drvs.coreutils & { priority = 1 },
    ]
  }
}
