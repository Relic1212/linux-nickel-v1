{
  lib,
  drvs,
  androidUdevRules | lib.Package = {
    singleSource = {
      uri = "https://github.com/M0Rf30/android-udev-rules/archive/refs/tags/20250525.tar.gz",
      sha256sum = "582bf8daa23f318047e77ece4c101c8696fd9151c459f695dca56cf4a40a72a2"
    },

    separateBuildDir = false,

    enableCcache = false,
    installPhase = [
      "install -d -m0755 ${DEST}/usr/lib/udev/rules.d/",
      "install -m0755 51-android.rules ${DEST}/usr/lib/udev/rules.d/",
      "sed -i 's@adbusers@plugdev@g' ${DEST}/usr/lib/udev/rules.d/51-android.rules",
    ]
  }
}
