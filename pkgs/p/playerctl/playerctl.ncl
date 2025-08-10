{
    lib,
    drvs,
    playerctl  | lib.MesonPackage = {
        singleSource = {
            uri = "https://github.com/altdesktop/playerctl/archive/refs/tags/v2.4.1.tar.gz",
            sha256sum = "75957ad5071956f563542c7557af16a57e40b4a7f66bc9b6373d022ec5eef548"
        },
        extraMesonArgs = [
            "-Dintrospection=false",
            "-Dgtk-doc=false",
        ],
        biDrvs = [
            drvs.glib,

      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,

        ]
    }
}