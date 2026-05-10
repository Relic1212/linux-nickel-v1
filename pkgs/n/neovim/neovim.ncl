{
  lib,
  drvs,
  neovim | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/neovim/neovim/archive/refs/tags/v0.11.6.tar.gz",
      sha256sum = "d1c8e3f484ed1e231fd5f48f53b7345b628e52263d5eef489bb8b73ca8d90fca",
    },
    cmakeExtraArgsRecord = {
      "-DLPEG_LIBRARY" = "/usr/lib/lpeg.a",
      "-DPREFER_LUA" = false,
      "-DUSE_BUNDLED" = false,
    },
    biDrvs = [
      drvs.gnumake,
      drvs.lua51,
      drvs.luv,
      drvs.libuv,
      drvs.lpeg,
      drvs.treeSitter,
      drvs.unibilium,
      drvs.utf8proc,
      drvs.luajit,
    ],
  }
}
