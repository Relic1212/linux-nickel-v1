{
  lib,
  drvs,
  gpgme | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://gnupg.org/ftp/gcrypt/gpgme/gpgme-1.24.0.tar.bz2",
      sha256sum = "61e3a6ad89323fecfaff176bc1728fb8c3312f2faa83424d9d5077ba20f5f7da"
    },
    biDrvs = [
      drvs.libassuan,
      drvs.libgpgError,
    ],
    preConfigurePhase = [
      "sed -i 's@off64_t@off_t@g' ${SRC}/src/posix-io.c",
      "sed -i 's@ino64_t@ino_t@g' ${SRC}/src/posix-io.c",
    ],
    extraEnv = {
      LDFLAGS_FOR_BUILD = [
        "-static",
        "--static"
      ],
      CC_FOR_BUILD = ["clang", "-static", "--static"]
    },
    extraConfigureFlags = [
      "--disable-glibtest",
      "--disable-gpgconf-test",
      "--disable-gpg-test",
      "--disable-gpgsm-test",
      "--disable-g13-test",
    ]
  },
  gpgmeForCmake =
    gpgme
    & {
      postInstallPhase = [
        "sed -i 's@libgpgme.so@libgpgme.a@g' ${DEST}/usr/lib/cmake/Gpgmepp/GpgmeppConfig.cmake",
        "sed -i 's@libgpgmepp.so@libgpgmepp.a@g' ${DEST}/usr/lib/cmake/Gpgmepp/GpgmeppConfig.cmake",
      ]
    }
}
