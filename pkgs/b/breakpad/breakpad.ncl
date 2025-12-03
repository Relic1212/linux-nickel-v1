{
  lib,
  drvs,
  breakpad | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://github.com/google/breakpad/archive/refs/tags/v2024.02.16.tar.gz",
      sha256sum = "b1940cd9231822f1d332d1776456afa8d452e59799cbeef70641885c39547b28",
    },
    sourceInputs = [
      {
        src = singleSource
      },
      {
        src = {
          #   uri = "https://chromium.googlesource.com/linux-syscall-support/+archive/refs/tags/v2024.02.01.tar.gz",
          #   sha256sum = "290e224d52b0b75cd5493c25dfdac6d2d7d8117ffb602d71562e82a7f6200e3f",
          # uri = "git://chromium.googlesource.com/linux-syscall-support.git",
          # sha256sum = "1a52e141b1383dbb00819c34d64ebd18f2c78739",
          # uri = "https://chromium.googlesource.com/linux-syscall-support/+/refs/tags/v2024.02.01/linux_syscall_support.h",
          # sha256sum = "3696970cb016e8a7f5a9a7940fbd0dc53bcba0c24b209ef9f41f09287ef82493",

          uri = "https://github.com/Ahusm/linux-syscall-support/archive/ed31caa60f20a4f6569883b2d752ef7522de51e0.tar.gz",
          sha256sum = "284eabb782eddf0bcbae33522ff971c1ea51614956a80e74d24e2877aa3da000",
        },
        dest = "src/third_party/lss/"
      },
      {
        src = {
          uri = "https://github.com/protocolbuffers/protobuf/archive/refs/tags/v33.1.tar.gz",
          sha256sum = "0c98bb704ceb4e68c92f93907951ca3c36130bc73f87264e8c0771a80362ac97",
        },
        dest = "src/third_party/protobuf/protobuf",
      }
    ],
    extraConfigureFlags = [
      "--disable-tools",
    ],
    # buildEnv = {
    #   EXTRA_CFLAGS = [
    #     "-Wno-sign-compare",
    #   ],
    # },
    preConfigurePhase = [
      m%"sed -i 's@as_fn_append WARN_CXXFLAGS " -Werror"@as_fn_append WARN_CXXFLAGS " "@g' ${SRC}/configure"%,
    ],
    biDrvs = [
      drvs.pkgconfMeson,
      drvs.linuxHeaders,
      drvs.zlibNg,
    ]
  }
}
