{
  lib,
  drvs,
  uutilsUtilLinux | lib.CargoPackage =
    let j = import "./uutils-util-linux-crates.json"
    in
    let _crates = lib.functions.filterCrates j
    in
    {

      singleSource = {
        # uri = "https://github.com/uutils/util-linux/archive/261332d6a5b9ada13a30462db4ed37435956c30a.tar.gz",
        # sha256sum = "3598e70f258935d50a66e8db114fc83b3719744ac5dfe2111349f0f1b0206312",
        uri = "https://github.com/uutils/util-linux/archive/5a97d50cb56da0b683ae95d6283f5061fd0ebcfb.tar.gz",
        sha256sum = "251fced180358baaea6dad7d7863cf7f697137f949aca37c37a8cc193ecad676",
      },
      crates = _crates,
      # lockfileImport | priority 1 = (import "./Cargo.lock" as 'Toml),
      # crates = lib.functions.importCargoLock (import "./Cargo.lock" as 'Toml),
      # extraCargoFlags =[
      #   "--no-default-features",
      #   "--features mountpoint,lscpu,lsmem,ctrlaltdel,rev,setsid",
      # ],

      # patches = [
      #   {
      #     sha256sum = "3d23e5dd54b08d7cee6a84d5c2d88eb2fc46796dac184e5bdc9c6dce4dcf988b",
      #     file = "0001-no-last.patch"
      #   },
      # ],
      configurePhase = [
        m%"sed -i 's@"last",@@g' ${SRC}/Cargo.toml"%,
        m%"sed -i 's@"fsfreeze",@@g' ${SRC}/Cargo.toml"%,
        m%"sed -i 's@"blockdev",@@g' ${SRC}/Cargo.toml"%,
        m%"sed -i 's@"dmesg",@@g' ${SRC}/Cargo.toml"%,
        m%"sed -i 's@"lsipc",@@g' ${SRC}/Cargo.toml"%,

        # # m%"sed -i 's@\["utmpx"\]@\[\]@g' ${SRC}/src/uu/last/Cargo.toml"%,
        m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/bindgen-*/Cargo.toml"%,
        # m%"sed -i 's@"logging",@@g' ${SRC}/vendor/bindgen-*/Cargo.toml"%,
        # m%"sed -i 's@"which-rustfmt",@@g' ${SRC}/vendor/bindgen-*/Cargo.toml"%,
        # m%"sed -i 's@runtime = @# runtime = @g' ${SRC}/vendor/bindgen-*/Cargo.toml"%,
        m%"sed -i 's@"runtime"@"static","libcpp"@g' ${SRC}/vendor/clang-sys*/Cargo.toml"%,
        # m%"sed -i 's|target_env = "musl", target_os = "emscripten"|target_os = "emscripten"|g' ${SRC}/vendor/libc-0.2.141/src/unix/linux_like/mod.rs"%,
        # m%"sed -i 's|open64|open|g' ${SRC}/vendor/libc-0.2.141/src/unix/linux_like/mod.rs"%,
        # m%"sed -i 's|open64|open|g' ${SRC}/vendor/getrandom-0.2.8/src/util_libc.rs"%,
      ],
      llvmProvider = drvs.llvmFull,
      biDrvs = [
        drvs.utilLinux,
        drvs.llvmConfigStatic,
        drvs.zlibNg,
        drvs.libffi,
        drvs.ncurses,
        drvs.libstdcppCompat,
      ],
      extraEnv = {
        "LIBMOUNT_STATIC" = "1",
        EXTRA_RUSTFLAGS = [
          "-C link-arg=-lblkid",
        ],
      },
    }
}
& (import "../uutils-procps/uutils-procps.ncl")
& (import "../uutils-diffutils/uutils-diffutils.ncl")
& (import "../uutils-findutils/uutils-findutils.ncl")
& (import "../uutils-login/uutils-login.ncl")
