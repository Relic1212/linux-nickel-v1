{
  lib,
  drvs,
  ddcutil | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/rockowitz/ddcutil/archive/refs/tags/v2.2.1.tar.gz",
      sha256sum = "ff8eb39b4559fcbc83de7b16834a010262dfa825938625272212fcaeefaef692"
    },

    separateBuildDir = false,

    biDrvs = [
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.glib,
      drvs.jansson,
      drvs.gperf,
      drvs.kmod,
      drvs.xz,
      drvs.openssl,
      drvs.zstd,
      drvs.utilLinux,
      drvs.linuxHeaders,
      drvs.eudev,
      drvs.libusb,
      drvs.libdrm,
      drvs.libpciaccess,
    ],

    preConfigurePhase = [
      m%"
            fix_symbol(){
                echo    sed -i "s@${1}(@${1}_ddcutil_private(@g"
                for f in $(find ${SRC} -type f -name '*.h' |grep -v subprojects);do
                    sed -i "s@${1}(@${1}_ddcutil_private(@g" $f
                    sed -i "s@_${1}_ddcutil_private(@_${1}(@g" $f
                done
                for f in $(find ${SRC} -type f -name '*.c' |grep -v subprojects);do
                    sed -i "s@${1}(@${1}_ddcutil_private(@g" $f
                    sed -i "s@_${1}_ddcutil_private(@_${1}(@g" $f
                done
            }
            "%,
      "fix_symbol \"strjoin\"",
    ],

    extraConfigureFlags = [
      "--enable-x11=no"
    ]
  }
}
