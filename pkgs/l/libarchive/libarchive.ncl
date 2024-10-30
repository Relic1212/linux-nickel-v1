{
  lib,
  pkgs,
  libarchive | lib.CmakePackage
    = {
      name = "libarchive",
      singleSource = {
        uri = "https://github.com/libarchive/libarchive/releases/download/v3.7.7/libarchive-3.7.7.tar.gz",
        sha256sum = "4cc540a3e9a1eebdefa1045d2e4184831100667e6d7d5b315bb1cbc951f8ddff",
      },
      generator = "Ninja",
      postInstallPhase = [
        "cd ${DEST}/usr/bin",
        "ln -s bsdcpio cpio",
        "ln -s bsdtar tar",
        "ln -s bsdunzip unzip",
      ],
      biDrvs =
        lib.biMap [
          pkgs.zlibNg,
          pkgs.zstd,
          pkgs.lz4,
        ],
      # extraCmakeArgs = [
      #   "-DENABLE_ZLIB:BOOL=ON",
      #   "-DENABLE_ZSTD:BOOL=ON",
      #   "-DENABLE_LZ4:BOOL=ON",
      # ],
      cmakeExtraArgsRecord={
        ENABLE_ZLIB=true,
        ENABLE_ZSTD=true,
#        ENABLE_LZ4=true,

        "ENABLE_LZ4:BOOL"="ON",

        SOMETHING=null,

      }
    }
}
