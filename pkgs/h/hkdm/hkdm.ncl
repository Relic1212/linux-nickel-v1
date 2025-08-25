{
  lib,
  drvs,
  hkdm | lib.CargoPackage = {
    singleSource = {
      uri = "https://gitlab.postmarketos.org/postmarketOS/hkdm/-/archive/0.2.1/hkdm-0.2.1.tar.gz",
      sha256sum = "0ae19ee83be1d843958dd2bcba07c17359abdf1e63f1862ca9ee8e979bafd9eb"
    },
    crates = lib.functions.filterCrates (import "hkdm-crates.json"),

    biDrvs = [
      drvs.libevdev,
      drvs.linuxHeaders,
    ]
  }
}
& {
  lib,
  drvs,
  buffybox | lib.MesonPackage = {
    singleSource = {
      # uri = "https://gitlab.com/-/project/52322952/uploads/88ff83972a3c19d16d9d2560bfae8a7e/buffybox-3.2.0.tar.gz",
      #uri = "https://gitlab.com/-/project/52322952/uploads/88ff83972a3c19d16d9d2560bfae8a7e/buffybox-3.2.0.tar.gz",
      #sha256sum = "532da56ecaf67f90ca4570c708a7318e9312bf7d9c68fc45a00f67e762c1ca50"

      uri = "https://gitlab.postmarketos.org/postmarketOS/buffybox/-/archive/6bf7a8406f3a3fa79831d2d151e519b703b9e135/buffybox-6bf7a8406f3a3fa79831d2d151e519b703b9e135.tar.gz",
      sha256sum = "8a304f234b4059116c4b4d90ca1b4b7cdea9cd0721d7076e6295b3fe79671d44"
    },
    sourceInputs = [
      {
        src =
          singleSource
      },
      {

        src = {
          uri = "https://github.com/lvgl/lvgl/archive/ceadda8a468b7d5fa6ba973bd82cf610166278d8.zip",
          sha256sum = "776d0e29e9aac3dbe60ca1d549a1d7f0d7cd5e5378bb635ec97e5153fa3a7ae2"
        },
        dest = "lvgl"
      }
    ],
    biDrvs = [
      drvs.inih,
      drvs.scdoc,
      drvs.linuxHeaders,
      drvs.expat,
      drvs.libffi,
      drvs.libpciaccess,
      drvs.libxkbcommon,
      drvs.libdrm,
      drvs.mtdev,
      drvs.libevdev,
      drvs.eudev,
      drvs.libinput,
    ],
    extraMesonArgs = [
      "-Dwith-drm=enabled"
    ]
  }
}
& {
  lib,
  drvs,
  ttyescape | lib.Package = {
    singleSource = {
      uri = "https://gitlab.postmarketos.org/postmarketOS/ttyescape/-/archive/810a195f19f68e817d95da5169b1fc4f22242630/ttyescape-810a195f19f68e817d95da5169b1fc4f22242630.tar.gz",
      sha256sum = "82ef7181d030e695a82182a561aefabc2bac687ee0117b8080d3a0b34d0a44e6"
    },
    separateBuildDir = false,
    installPhase = [
      "install -d -m0755 ${DEST}/usr/bin",
      "install -m0755 togglevt.sh ${DEST}/usr/bin",
      "install -d -m0755 ${DEST}/etc/hkdm/config.d",
      "install -m0755 ttyescape-hkdm.toml ${DEST}/etc/hkdm/config.d",
      # "install -Dm0755 etc-conf-d-ttyescape.conf ${DEST}/etc/conf.d/",
    ]
  }
}
& {
  lib,
  drvs,
  iioSensorProxy | lib.MesonPackage = {
    singleSource = {
      #uri = "https://gitlab.freedesktop.org/hadess/iio-sensor-proxy/-/archive/3.6/iio-sensor-proxy-3.6.tar.gz",
      #sha256sum = "387cffea8b55d3087b199975cf3e00f2405d4dfe4a9bfb311b396e6473c67a96",

      # 3.3 is the last one that does not need polkit
      uri = "https://gitlab.freedesktop.org/-/project/5287/uploads/83c63a8dd585ef6d1568791369dc8877/iio-sensor-proxy-3.3.tar.xz",
      sha256sum = "ddb9ac0678f69fdd89f2012348428b705b03b146528ff68d93c8b284be1ab9a8",
    },
    biDrvs = [
      drvs.inih,
      drvs.scdoc,
      drvs.linuxHeaders,
      drvs.expat,
      drvs.libffi,
      drvs.libpciaccess,
      drvs.libxkbcommon,
      drvs.libdrm,
      drvs.mtdev,
      drvs.libevdev,
      drvs.eudev,
      drvs.libinput,
      drvs.glib,
      drvs.gudev,
      drvs.pcre2,
      drvs.zlibNg,
    ],
    extraMesonArgs = [
      "-Dsystemdsystemunitdir=/no"
    ]
  }
}
