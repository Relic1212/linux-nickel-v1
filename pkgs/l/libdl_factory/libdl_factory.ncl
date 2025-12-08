{
  lib,
  drvs,
  libdlFactory | lib.MakePackage = {
    singleSource = {
      uri = "/home/user/Projects/dl-tables",
      fetchMethod = "git",
      sha256sum = "bf588c4ffca602ff95d4ab4ebd37889e4c13e9d9"
    },
    options = {
      stable | default = 2048,
      dtable | default = 256,
    },
    buildEnv.EXTRA_CFLAGS = [
      "-DDL_SYMBOL_TABLE_LIBRARY_COUNT=%{options.stable}",
      "-DDL_LIBRARY_TABLE_LIBRARY_COUNT=%{options.dtable}",
    ],
  },
  libdlFactoryBig =
    libdlFactory
    & {
      options.stable = 5 * 2048,
    },
}
