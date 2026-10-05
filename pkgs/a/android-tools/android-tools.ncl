{
  lib,
  drvs,
  androidTools | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      # uri = "https://github.com/nmeum/android-tools/archive/refs/tags/35.0.2.tar.gz",
      # sha256sum = "048bd42b75166fa4b66989b25ba1abb2b773aa7b7d012d52d84010b127db8801",

      # uri = "https://github.com/nmeum/android-tools/releases/download/35.0.2/android-tools-35.0.2.tar.xz",
      # sha256sum = "d2c3222280315f36d8bfa5c02d7632b47e365bfe2e77e99a3564fb6576f04097",

      uri = "https://github.com/nmeum/android-tools/releases/download/37.0.0/android-tools-37.0.0.tar.xz",
      sha256sum = "2725d09f892a3a38e534429f47a321f58ecf6a3169caa42c915fb2cb7d46be0e",
    },
    sourceInputs = [
      { src = singleSource },
      {
        src = {
          uri = "https://raw.githubusercontent.com/munix9/android-tools/72350f42896873d01060e22090e8ec51bf2fac6f/patches/adb/0029-protobuf-36-absl-log-macros.patch",
          sha256sum = "a62c10ebff856d0cf290f40995fb763ff91c898e49bf711ab0dcb85ffdf916af",
        },
      },
    ],
    buildEnv = {
      EXTRA_LDFLAGS = ["-ludev"],
      EXTRA_CPPFLAGS = [
        "-DABSL_NO_LOG_MACROS",
      ],
      EXTRA_CFLAGS = EXTRA_CPPFLAGS,
      EXTRA_CXXFLAGS = EXTRA_CPPFLAGS,
    },

    preConfigurePhase = [
      m%"sed -i 's@#include <variant>@#include <variant>\n#include <vector>@g' ${SRC}/vendor/adb/fdevent/fdevent.h"%,
      m%"sed -i 's@#include <functional>@#include <functional>\n#include <vector>@g' ${SRC}/vendor/core/fastboot/fastboot.h"%,
      m%"sed -i 's@libbase/test_utils.cpp@@g' ${SRC}/vendor/CMakeLists.libbase.txt"%,
      "(cd ${SRC}/vendor/adb && patch -p1 < ${SRC}/0029-protobuf-36-absl-log-macros.patch)",
    ],
    biDrvs = [
      drvs.googletest,
      drvs.libusb,
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.glib,
      drvs.jansson,
      drvs.gperf,
      drvs.kmod,
      drvs.xz,
      drvs.openssl,
      drvs.zstd,
      drvs.utilLinux,
      drvs.eudevForAndroidTools,
      drvs.lz4,
      drvs.protobuf,
      drvs.abseilCpp,
      drvs.brotli,
      drvs.fmt,
      drvs.linuxHeaders,
    ]
  }
}
& {
  eudev,
  lib,
  eudevForAndroidTools =
    eudev
    & {
      postInstallPhase | priority 1 =
        eudev.postInstallPhase
        @ [
          "llvm-objcopy --redefine-sym utf16_to_utf8=eudev__utf16_to_utf8 ${DEST}/usr/lib/libudev.a",
        ]
    }
}
