{
  lib,
  drvs,
  minizipNg | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/zlib-ng/minizip-ng/archive/refs/tags/4.2.2.tar.gz",
      sha256sum = "71af7b9799856d8b03619df3949e9c1be9703f8de0795af71399ba283cb27aac",
    },
    cmakeExtraArgsRecord = {
      "-DMZ_PPMD" = false,
    },
  }
}
