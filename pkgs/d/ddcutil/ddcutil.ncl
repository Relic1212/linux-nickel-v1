{
  lib,
  drvs,
  ddcutil | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/rockowitz/ddcutil/archive/refs/tags/v3.0.1.tar.gz",
      sha256sum = "561e26f8ebcdb07e182092b9a0d27477842879b1a5338b52505ad49780cc824b"
    },

    buildEnv = {
      EXTRA_CFLAGS = [
        "-Wno-error=unused-but-set-global",
      ],
    },

    separateBuildDir = false,

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
    ],
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
      drvs.acl,
      drvs.attr,
    ],
  }
}
& {
  lib,
  drvs,
  ddcui | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/rockowitz/ddcui/archive/refs/tags/v0.6.0.tar.gz",
      sha256sum = "89a0e33314c7bf046ab09b0e68aa3c758b8eba69f06973987522c75843237c39"
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
      drvs.ddcutil,
    ],
  }
}
