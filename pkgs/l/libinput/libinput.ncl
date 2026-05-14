{
  lib,
  drvs,
  libinput | lib.MesonPackage = {
    name = "libinput",
    singleSource = {
      # uri = "https://gitlab.freedesktop.org/libinput/libinput/-/archive/1.26.2/libinput-1.26.2.tar.gz",
      # sha256sum = "5c1c4150f217fea1db2d1fd88e2607b2f1928cfde65c34da65a9f24dcfd69464",
      uri = "https://gitlab.freedesktop.org/libinput/libinput/-/archive/1.29.0/libinput-1.29.0.tar.gz",
      sha256sum = "ec71f6ec6632108a62756f49d86e864494108e70cf670e85f8b7579e970e152c",
    },
    preConfigurePhase = [
      m%"sed -i "s/shared_library/library/" ${SRC}/meson.build"%
    ],
    extraMesonArgs = ["-Dtests=false", "-Dlibwacom=false", "-Ddebug-gui=false"],
    biDrvs = [
      # drvs.libudevZero,
      drvs.linuxHeaders,
    ],
    pDrvs = [
      drvs.eudev,
      drvs.mtdev,
      drvs.libevdev,
    ],
  },

  libinputFixedSyms | lib.MesonPackage =
    libinput
    & {
      preConfigurePhase | priority 1 =
        libinput.preConfigurePhase
        @ [
          m%"
            fix_symbol(){
                echo    sed -i "s@${1}(@${1}_libinput_private(@g"
                for f in $(find ${SRC} -type f -name '*.h' |grep -v subprojects);do
                    sed -i "s@${1}(@${1}_libinput_private(@g" $f
                    sed -i "s@_${1}_libinput_private(@_${1}(@g" $f
                done
                for f in $(find ${SRC} -type f -name '*.c' |grep -v subprojects);do
                    sed -i "s@${1}(@${1}_libinput_private(@g" $f
                    sed -i "s@_${1}_libinput_private(@_${1}(@g" $f
                done
            }
            "%,
          "fix_symbol \"list_insert\"",
          "fix_symbol \"list_empty\"",
          "fix_symbol \"list_init\"",
          "fix_symbol \"list_append\"",
          "fix_symbol \"list_remove\"",
        ]
    }
}
