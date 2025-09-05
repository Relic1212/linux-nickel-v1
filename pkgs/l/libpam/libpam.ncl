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
        sha256sum = "40a7c82ef046e98f46208102e783b7112f8b26f464c80e2f044480b76c049e6c",
        file = "libpam.patch",
      }
    ],
    extraMesonArgs = [
      "-Dexamples=false"
    ],
    baseMesonArgs = (std.array.filter (fun flag => (flag != "--includedir=include")) lib.constants.mesonArgsDebug) @ lib.constants.mesonArgsStatic,

    postInstallPhase = [
      "cd ${DEST}/usr/lib/security",
      "llvm-objcopy --redefine-sym pam_sm_authenticate=pam_unix__pam_sm_authenticate pam_unix.a",
      "llvm-objcopy --redefine-sym pam_sm_setcred=pam_unix__pam_sm_setcred pam_unix.a",
      "llvm-objcopy --redefine-sym pam_sm_acct_mgmt=pam_unix__pam_sm_acct_mgmt pam_unix.a",
      "llvm-objcopy --redefine-sym pam_sm_open_session=pam_unix__pam_sm_open_session pam_unix.a",
      "llvm-objcopy --redefine-sym pam_sm_close_session=pam_unix__pam_sm_close_session pam_unix.a",
      "llvm-objcopy --redefine-sym pam_sm_chauthtok=pam_unix__pam_sm_chauthtok pam_unix.a",
      "llvm-objcopy -W _pam_line_buffer_clear pam_unix.a",
      "llvm-objcopy -W _pam_line_buffer_init pam_unix.a",
      "llvm-objcopy -W _pam_line_assemble pam_unix.a",
      # "cp pam_unix.so ../libpam_unix.a",
      # "cd ../pkgconfig",
      "mkdir -p /tmp/workdir/build/libpam-stage-2/pam_unix",
      "mkdir -p /tmp/workdir/build/libpam-stage-2/libpam",
      "cd /tmp/workdir/build/libpam-stage-2",
      "${CC} -r -o libpam.o -Wl,--whole-archive  ${DEST}/usr/lib/security/pam_unix.a ${DEST}/usr/lib/libpam.a",
      "${AR} rcs libpam.a libpam.o",
      # "llvm-ar x ${DEST}/usr/lib/security/pam_unix.a && mv *.o pam_unix",
      # "llvm-ar x ${DEST}/usr/lib/libpam.a && mv *.o libpam",
      # "llvm-ar rcs libpam.a pam_unix/*.o libpam/*.o",
      "mv ${DEST}/usr/lib/libpam.a ${DEST}/usr/lib/libpam_orig.a" ,
      "install -m0755 libpam.a ${DEST}/usr/lib"

      # "sed -i 's|-lpam|-lpam -lpam_unix|g' pam.pc",
    ],

    biDrvs = [
      drvs.linuxHeaders,
    ],
  }
}
