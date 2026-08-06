{
  lib,
  drvs,
  p11Kit | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/p11-glue/p11-kit/releases/download/0.25.5/p11-kit-0.25.5.tar.xz",
      sha256sum = "04d0a86450cdb1be018f26af6699857171a188ac6d5b8c90786a60854e1198e5"
    },

    extraMesonArgs = [
      "-Dtrust_module=enabled",
      "-Dtrust_paths=\"/etc/ssl/cert.pem:/etc/ssl/certs/ca-certificates.crt\"",
    ],

    preConfigurePhase = [
      m%"sed -i "s@shared_library@library@g" ${SRC}/p11-kit/meson.build"%,
    ],

    postInstallPhase = [
      "llvm-objcopy --redefine-sym=memdup=p11kit_memdup ${DEST}/usr/lib/libp11-kit.a",
    ],

    biDrvs = [
      drvs.linuxHeaders,
      drvs.libxslt,
    ],
    pDrvs = [
      # drvs.libgcrypt,
      drvs.openssl,
      drvs.glib,
      drvs.gpgme,
      drvs.gnupg2,
      drvs.libtasn1,
    ],
  }
}
