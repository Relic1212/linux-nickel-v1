{
  lib,
  drvs,
  lua,
  libuv,
  #   luajitGit,
  luv | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/luvit/luv/archive/refs/tags/1.51.0-2.tar.gz",

      sha256sum = "d70cf20b16ab05ceaa3bb448f3e1b3ef63a5949e34184255c52a3e92efcd39b4",
    },
    sourceInputs = [
      {
        src = singleSource,
      },
      {
        src = {
          #   uri = "https://github.com/lua/lua/archive/a5522f06d2679b8f18534fd6a9968f7eb539dc31.tar.gz",
          #   sha256sum = "b85ede9dbc4a4292addcfefebe15168acc7f1d42c674cc297d74f0e8ff2f2dd8",

          uri = "https://github.com/lua/lua/archive/refs/tags/v5.4.8.tar.gz",
          sha256sum = "d85b70a65f43c5d2254944d58d625e822c8e2e10d9c6a3bd9b5b657e46376a19",
        },
        dest = "deps/lua",
      },
      {
        src = libuv.singleSource,

        dest = "deps/libuv",
      },
      #   {
      #     src = luajitGit.singleSource,
      #     dest = "deps/luajit",
      #   },
      {
        src = {
          uri = "https://github.com/lunarmodules/lua-compat-5.3/archive/64ed183ab243cdc737203e835892b4e6cb446e46.tar.gz",
          sha256sum = "a646a752cb4639ea17823870b30a49a4072f980b9bc96e3d1f0b4c2e3d2be230"
        },
        dest = "deps/lua-compat",
      },
    ],
    cmakeExtraArgsRecord = {
      # "-DLUA_BUILD_TYPE" = "system",
      "-DWITH_LUA_ENGINE" = "Lua",
      # "-DWITH_SHARED_LIBUV" = true,
      "-DWITH_SHARED_LIBUV" = false,
      "-DBUILD_MODULE" = false,
      "-DLUA_LIBFILE" = "/usr/lib/liblua.a",
      "-DLUA_LIBDIR" = "/usr/lib",
      "-DWITH_SHARED_LUA" = false,
      # "-DLUA_INCDIR" = "/usr/include",
    },
    biDrvs = [
      drvs.libuv,
      drvs.lua,
      drvs.luajit,
    ],
  }
}
