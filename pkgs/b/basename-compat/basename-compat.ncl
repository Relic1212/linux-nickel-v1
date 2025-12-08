{
  lib,
  drvs,
  basenameCompat | lib.Package = {
    extraFiles = [
      {
        file = "basename.h",
        sha256sum = "343a9fa26dde6a84d1af839e558fba500accdb51c8f18075b3a6c090ce5d70b0",
      },
    ],
    installPhase = [
      "install -dm0755 ${DEST}/usr/include",
      "install -m0755 ../files/basename.h ${DEST}/usr/include",
    ]
  }
}
