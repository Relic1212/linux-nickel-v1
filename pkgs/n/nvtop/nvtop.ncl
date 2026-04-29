{
  lib,
  drvs,
  nvtop | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/Syllo/nvtop/archive/refs/tags/3.3.2.tar.gz",
      sha256sum = "48a295f3b3a917cc851d1aa8b185c09fde3a1b1e741fc57d7fa96b3671271630",
    },

    buildEnv = {
      EXTRA_LDFLAGS = [
        "/tmp/workdir/src/dlopen.o",
        "$(pkg-config --libs --static libdrm libdrm_amdgpu)",
      ],
    },

    preConfigurePhase = [
      "echo '%{import "nvtop_dlopen.c" as 'Text}' > ${SRC}/dlopen.c",
      "${CC} ${CFLAGS} -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
    ],

    muslProvider = drvs.muslBothRenamedDl,

    biDrvs = [
      drvs.eudev,
      drvs.gperf,
      drvs.kmod,
      drvs.libdrm,
      drvs.libpciaccess,
      drvs.linuxHeaders,
      drvs.ncurses,
      drvs.openssl,
      drvs.utilLinux,
      drvs.xz,
      drvs.zlibNg,
      drvs.zstd,
    ],
  }
}
