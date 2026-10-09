{
  lib,
  drvs,
  abseilCpp | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      # uri = "https://github.com/abseil/abseil-cpp/releases/download/20240722.0/abseil-cpp-20240722.0.tar.gz",
      # sha256sum = "f50e5ac311a81382da7fa75b97310e4b9006474f9560ac46f54a9967f07d4ae3",

      uri = "https://github.com/abseil/abseil-cpp/archive/refs/tags/20260817.0.tar.gz",
      sha256sum = "f7e05179df39c45434cad433f5783840bb3788ef322976f9138bc6b72b3a107d",
    },
    biDrvs = [
      drvs.linuxHeaders,
    ]
  }
}
# & {
#   lib,
#   drvs,
#   abseilCppChromium | lib.CmakePackage = {
#     generator = "Ninja",
#     singleSource = {
#       uri = "https://github.com/abseil/abseil-cpp/archive/de672d07fefc25c4e431052012b68a12c75494aa.tar.gz",
#       sha256sum = "4a266cad90ea95ed1c31e2f69a0defad5159d3a001b1ca6aeb779b095c64e39c",
#     },
#     biDrvs = [
#       drvs.linuxHeaders,
#     ]
#   }
# }
