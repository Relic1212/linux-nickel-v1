{
  lib,
  drvs,
  libarchive | lib.CmakePackage = {
    name = "libarchive",
    singleSource = {
      # uri = "https://github.com/libarchive/libarchive/releases/download/v3.7.7/libarchive-3.7.7.tar.gz",
      # sha256sum = "4cc540a3e9a1eebdefa1045d2e4184831100667e6d7d5b315bb1cbc951f8ddff",
      uri = "https://github.com/libarchive/libarchive/archive/refs/tags/v3.8.2.tar.gz",
      sha256sum = "97548897f06ed7f5cd847fc62a67420809dbbd9b45ec13a25d3290fafba046c8",
    },
    generator = "Ninja",
    postInstallPhase = [
      "cd ${DEST}/usr/bin",
      "ln -s bsdcpio cpio",
      "ln -s bsdtar tar",
      "ln -s bsdunzip unzip",
    ],
    pDrvs = [
      drvs.zlibNg,
      drvs.zstd,
      drvs.lz4,
    ],
    # extraCmakeArgs = [
    #   "-DENABLE_ZLIB:BOOL=ON",
    #   "-DENABLE_ZSTD:BOOL=ON",
    #   "-DENABLE_LZ4:BOOL=ON",
    # ],
    cmakeExtraArgsRecord = {
      ENABLE_ZLIB = true,
      ENABLE_ZSTD = true,
      #        ENABLE_LZ4=true,

      "ENABLE_LZ4:BOOL" = "ON",

      SOMETHING = null,
    }
  }
}
