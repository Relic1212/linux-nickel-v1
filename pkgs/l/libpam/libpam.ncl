{
  lib,
  drvs,
  libpam161 | lib.AutotoolsPackage = {
    name = "libpam",
    singleSource = {
      uri = "https://github.com/linux-pam/linux-pam/releases/download/v1.6.1/Linux-PAM-1.6.1.tar.xz",
      sha256sum = "f8923c740159052d719dbfc2a2f81942d68dd34fcaf61c706a02c9b80feeef8e",
    },
    biDrvs = [
      drvs.linuxHeaders,
    ],
    configureFlags = std.array.filter (fun flag => (flag != "--includedir=/usr/include")) lib.AutotoolsPackage.configureFlags,
  }
}
& {
  lib,
  drvs,
  libpam | lib.MesonPackage = {
    debug = true,
    singleSource = {
      uri = "https://github.com/linux-pam/linux-pam/releases/download/v1.7.1/Linux-PAM-1.7.1.tar.xz",
      sha256sum = "21dbcec6e01dd578f14789eac9024a18941e6f2702a05cf91b28c232eeb26ab0",
    },
    patches = [
      {
        sha256sum = "00d178863587895e52c1a0839ebe0ba9b7b9798c422afe0a36c23c9a770f5ff9",
        file = "libpam.patch",
      }
    ],
    extraMesonArgs = [
      "-Dexamples=false"
    ],
    baseMesonArgs = (std.array.filter (fun flag => (flag != "--includedir=include")) lib.constants.mesonArgsDebug) @ lib.constants.mesonArgsStatic,

    postInstallPhase = [
      "cd ${DEST}/usr/lib/security",
      "llvm-objcopy --redefine-sym pam_sm_authenticate=pam_unix__pam_sm_authenticate pam_unix.so",
      "llvm-objcopy --redefine-sym pam_sm_setcred=pam_unix__pam_sm_setcred pam_unix.so",
      "llvm-objcopy --redefine-sym pam_sm_acct_mgmt=pam_unix__pam_sm_acct_mgmt pam_unix.so",
      "llvm-objcopy --redefine-sym pam_sm_open_session=pam_unix__pam_sm_open_session pam_unix.so",
      "llvm-objcopy --redefine-sym pam_sm_close_session=pam_unix__pam_sm_close_session pam_unix.so",
      "llvm-objcopy --redefine-sym pam_sm_chauthtok=pam_unix__pam_sm_chauthtok pam_unix.so",
      "cp pam_unix.so ../libpam_unix.a",
      "cd ../pkgconfig",
      "sed -i 's|-lpam|-lpam -lpam_unix|g' pam.pc",
    ],

    biDrvs = [
      drvs.linuxHeaders,
    ],
  }
}
