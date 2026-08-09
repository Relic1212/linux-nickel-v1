{
  lib,
  drvs,
  nss | lib.MakePackage = {
    singleSource = {
      # uri = "https://ftp.mozilla.org/pub/security/nss/releases/NSS_3_126_RTM/src/nss-3.126.tar.gz",
      # sha256sum = "7aa07c758be1453d82d739240b249ffb7aef0041be488067e1c0f348e1f9e337",

      uri = "https://ftp.mozilla.org/pub/security/nss/releases/NSS_3_125_RTM/src/nss-3.125.tar.gz",
      sha256sum = "1ad541f10da7c58dec01f540ecc44d28cbbc033f741a57473de5a0893d91606d",
    },
    isStatic = false,
    buildEnv = {
      _isStatic = false,
      EXTRA_CPPFLAGS = [
        "-DCMAC_Init=libnss_freebl__CMAC_Init",
        "-DCMAC_Update=libnss_freebl__CMAC_Update",
        "-DHMAC_Update=libnss_freebl__HMAC_Update",
        "-DHMAC_Init=libnss_freebl__HMAC_Init",
        "-DSHA1_Update=libnss_freebl__SHA1_Update",
        "-DSHA224_Update=libnss_freebl__SHA224_Update",
        "-DSHA256_Update=libnss_freebl__SHA256_Update",
        "-DSHA384_Update=libnss_freebl__SHA384_Update",
        "-DSHA512_Update=libnss_freebl__SHA512_Update",
        "-DMD5_Update=libnss_freebl__MD5_Update",
      ],
      EXTRA_CFLAGS = EXTRA_CPPFLAGS,
    },
    cdBuildPhase | priority 1 = ["cd ${SRC}/nss"],
    buildPhase = [
      "./build.sh --help || true",
      "echo help-done",
      "./build.sh --opt --clang --static --system-nspr --disable-tests -v",
      # "echo builddone"
    ],
    installPhase = [
      # "bas_e",
      # "ninja "
      "install -dm0755 ${DEST}/usr/lib/pkgconfig",
      "install -dm0755 ${DEST}/usr/include/nss",
      "cp -r ../dist/public/nss/* ${DEST}/usr/include/nss/",
      "cp ../dist/Release/lib/*.a ${DEST}/usr/lib/",
      # "cp ../dist/Release/lib/*.a ${DEST}/usr/lib/pkgconfig/",
      "sed -e 's@%prefix%@/usr@g' -e 's@%exec_prefix%@/usr/bin@g' -e 's@%libdir%@/lib@g' -e 's@%includedir%@/usr/include/nss@g' -e 's@%NSS_VERSION%@3.125@g' -e 's@%NSPR_VERSION%@1@g' $SRC/nss/pkg/pkg-config/nss.pc.in > ${DEST}/usr/lib/pkgconfig/nss.pc",
      "cd ${DEST}/usr/lib/",
      "mv libnssutil.a libnssutil3.a",
      "mv libnss_static.a libnss3.a",
      "mv libsmime.a libsmime3.a",
      "mv libssl.a libssl3.a",
    ],
    biDrvs = [
      drvs.bash,
      drvs.pythonFull,
      drvs.bashBinBash,
      drvs.samurai,
      drvs.pythonGyp,
      drvs.pythonSix,
      drvs.perl,
      drvs.linuxHeaders,
      drvs.muslShared,
    ],
    pDrvs = [
      drvs.nspr,
      drvs.zlibNg,
    ]
  }
}
