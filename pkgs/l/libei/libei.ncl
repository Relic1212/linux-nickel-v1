{
  lib,
  drvs,
  libei | lib.MesonPackage = {
    singleSource = {

      uri = "https://gitlab.freedesktop.org/libinput/libei/-/archive/1.5.0/libei-1.5.0.tar.bz2",
      sha256sum = "da1fba92daccd0667bc46c3ee952d4ae8cfc6bdb4c0bb4d34df26528fb240618"
    },
    sourceInputs = [
      {
        src = singleSource,
      },
      {
        src = {
          uri = "https://github.com/nemequ/munit/archive/fbbdf1467eb0d04a6ee465def2e529e4c87f2118.tar.gz",
          sha256sum = "d0c8bf80b9804d4df5301bd428702352fe7e14f84f22027c3a2c084a0d9f69a7"
        }
      },
    ],
    biDrvs = [
      drvs.attr,
      drvs.acl,
      drvs.dbus,
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.glib,
      drvs.libxslt,
      drvs.gudev,
      drvs.eudev,
      drvs.linuxHeaders,
      drvs.gperf,
      drvs.pythonJinja2,
      #   (drvs.coreutils & { priority = 1 }),
      drvs.muslGetent,
      drvs.utilLinux,
      drvs.bash,
      drvs.pythonMarkupsafe,
      drvs.pythonFlitCore,
      drvs.docbookXslNons,
    ],
    propagatedBuildInputs = [
      drvs.elogindWithPolkit,
    ]
  }
}
