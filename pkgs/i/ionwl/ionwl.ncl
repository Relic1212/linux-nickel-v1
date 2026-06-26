{
  lib,
  drvs,
  ionwl | lib.CargoPackage =
    let
      lock = (import "Cargo.lock" as 'Toml),
      _smithay | lib.Crate = {
        name = "smithay",
        version = "0.1.0",
        sha256sum = "429549b2cb6b24b95c125c204ed2fb3c5c129970d481e3ba53ab06e0626aa0f4",

        sourceInput = {
          uri = "https://github.com/Smithay/smithay/archive/66fc28b98e03c6530e886e6e6e4836ae98cbabf4.tar.gz",
          sha256sum = "429549b2cb6b24b95c125c204ed2fb3c5c129970d481e3ba53ab06e0626aa0f4",
        }
      }
    in
    {
      singleSource = {

        # uri = "https://codeberg.org/ideasman42/IonWL/archive/9cadb2d7f43fbe62a161ad3c0c0c5503395c8980.tar.gz",
        # sha256sum = "",

        uri = "https://codeberg.org/ideasman42/IonWL.git",
        sha256sum = "9cadb2d7f43fbe62a161ad3c0c0c5503395c8980",
        fetchMethod = "git",
      },
      nonCrateSourceInputs = [
        { src = singleSource },
        {
          src = _smithay.sourceInput,
          dest = "vendor/%{_smithay.name}-%{_smithay.version}"
        },
      ],
      crates = (lib.functions.filterCrates lock.package),

      extraEnv = {
        EXTRA_RUSTFLAGS = [
          "-C link-arg=-L/usr/lib/python3.12/libpython/",
          "-C link-arg=-lexpat",
          "-C link-arg=-lc++",
          "-C link-arg=-lmpdec",
          "-C link-arg=/usr/lib/python3.12/libpython/libHacl_Hash_SHA2.a",
          # "-C link-arg=/usr/lib/python3.12/libpython/libexpat.a",
          m%"$(for l in $(pkg-config --libs --static libevdev mtdev ncurses bz2 openssl libcap readline history panel libcrypto);do printf " -C link-arg=$l ";done)"%,
        ],
      },

      configurePhase = [
        lib.functions.writeFile "Cargo.lock" (import "Cargo.lock" as 'Text),
        # "tar -xf ${SRC}/vendor/smithay-0.1.0/*.tar.gz --strip-components=1 -C ${SRC}/vendor/smithay-0.1.0/",
        m%"echo '{"package":%{"\""}%{_smithay.sourceInput.sha256sum}","files":{}}' > ${SRC}/vendor/smithay-0.1.0/.cargo-checksum.json"%,
        "mv ${SRC}/vendor/smithay-0.1.0/smithay-drm-extras ${SRC}/vendor/smithay-drm-extras",
        m%"echo '{"files":{},"package":null}' > ${SRC}/vendor/smithay-drm-extras/.cargo-checksum.json"%,
        "mv ${SRC}/vendor/smithay-0.1.0 ${SRC}/vendor/smithay",
        m%"cat >>${SRC}/.cargo/config.toml << 'EOF'
[source."git+https://github.com/Smithay/smithay.git?rev=66fc28b98e03c6530e886e6e6e4836ae98cbabf4"]
git = "https://github.com/Smithay/smithay.git"
rev = "66fc28b98e03c6530e886e6e6e4836ae98cbabf4"
replace-with = "vendored-sources"

EOF

"%,
        m%"sed -i 's|"auto-initialize",||g' ${SRC}/Cargo.toml"%,
      ],

      llvmProvider = drvs.llvmFull,
      biDrvs = [
        drvs.pythonInteractive,
        #     drvs.gnumake,
      ],
      pDrvs = [
        # drvs.eudev,
        drvs.seatd,
        drvs.fontconfig,
        drvs.libdisplayinfo,
        drvs.mesa2,
        drvs.libinput,
        drvs.libxkbcommon,
        drvs.mpdecimal,
        # drvs.ncurses,
        drvs.readline,
        drvs.bzip2,
        drvs.openssl,
      ],
    }
}
