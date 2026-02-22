{
  lib,
  drvs,
  krb5 | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://kerberos.org/dist/krb5/1.22/krb5-1.22.2.tar.gz",
      sha256sum = "3243ffbc8ea4d4ac22ddc7dd2a1dc54c57874c40648b60ff97009763554eaf13",
    },
    configureScript = "${SRC}/src/configure",
    preConfigurePhase = [
      "sed -i 's|krb5_keyblock master_keyblock|extern krb5_keyblock master_keyblock|g' ${SRC}/src/kadmin/dbutil/kdb5_util.c",
      # "sed -i 's@		tests @@g' ${SRC}/src/Makefile.in",
      # "rm -rf ${SRC}/src/tests"
    ],
    preBuildPhase = [
      "rm -rf ${BUILDDIR}/tests",
    ],
    biDrvs = [
      drvs.perl,
      drvs.bison,
      drvs.flex,
      drvs.m4,
    ],
  }
}
