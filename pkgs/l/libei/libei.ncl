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
        },
        dest = "subprojects/munit"
      },
    ],

    buildEnv = {
      EXTRA_CPPFLAGS =
        std.array.map
          (fun s => "-D%{s}=libei__%{s}")
          [
            "strv_len",
            "strv_append_take",
            "strv_append_strdup",
            "strv_from_string",
            "strv_join",
            "strv_find",
            "strv_find_substring",
            "list_init",
            "list_insert",
            "list_empty",
            "list_append",
            "list_remove",
          ],
    },

    biDrvs = [
      drvs.linuxHeaders,
      drvs.gperf,
      drvs.pythonJinja2,
      # (drvs.coreutils & { priority = 1 }),
      drvs.muslGetent,
      drvs.bash,
      drvs.pythonMarkupsafe,
      drvs.pythonFlitCore,
      drvs.docbookXslNons,
      drvs.libxslt,
    ],
    pDrvs = [
      drvs.elogindWithPolkit,
      drvs.utilLinux,
      drvs.gudev,
      drvs.attr,
      drvs.acl,
      drvs.dbus,
    ]
  }
}
