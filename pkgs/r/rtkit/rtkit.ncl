{

  lib,
  drvs,
  rtkit | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/heftig/rtkit/archive/refs/tags/v0.13.tar.gz",
      sha256sum = "0f9508530868109f0348e044cc1b20893672875467ace6d847ba6364274de003"
    },

    sourceInputs = [
      { src = singleSource },
      {
        src = {
          uri = "https://raw.githubusercontent.com/alpinelinux/aports/refs/heads/master/community/rtkit/sched_getscheduler_sched_setscheduler.patch",
          sha256sum = "29b36c2cc2fed390da60e8ad96b42af258b4767ed37eaf1198c6562cb8703efe"
        }
      }
    ],
    extraMesonArgs = [
      "-Dinstalled_tests=false",
    ],
    preConfigurePhase = [
      "(cd ${SRC} && patch -p1 < sched_getscheduler_sched_setscheduler.patch)",
      m%"sed -i 's|,0x00|0x00|g' ${SRC}/rtkit-daemon.c"%,
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
      drvs.glib,
      drvs.gudev,
      drvs.pcre2,
      drvs.zlibNg,
      drvs.dbus,
      drvs.duktape,
      drvs.attr,
      drvs.acl,
      drvs.libcap,
      drvs.gettext,
      # drvs.perl,
      drvs.libxslt,
      drvs.docbookXslNons,
      drvs.docbookXml,
      drvs.elogindWithPolkit,
      drvs.libpamFinal,
    ]
  }
}
