{
  lib,
  drvs,
  lavalauncher | lib.MesonPackage
    = {
      singleSource = {
        # uri = m%"https://git.sr.ht/~leon_plickat/lavalauncher/archive/1050f33b0a3315bcd226f648392532c52467c9d7.tar.gz"%,
        # sha256sum = "c044786afbde54a524cb9bce49f4a90fbbe7f860f441f6229ef1f56b75ba6392"
        uri = m%"https://git.sr.ht/~leon_plickat/lavalauncher/archive/da17d8a29bfc6b78280242b8fdbcb1b6df4f8aff.tar.gz"%,
        sha256sum = "137f1726e61871b62d12d60528c8a73ac0a3c6dbd53193e4f7795a8f953a031e"
      },

      biDrvs = [
        drvs.fontconfig,
        drvs.freetype,
        drvs.zlibNg,
        drvs.gperf,
        drvs.pixman,
        drvs.wayland,
        drvs.waylandProtocols,
        drvs.libffi,
        drvs.libxkbcommon,
        drvs.expat,
        drvs.linuxHeaders,
        drvs.ncurses,
        drvs.readline,
        drvs.pcre2,
        drvs.pango,
        drvs.cairo,
        drvs.libpng,
        drvs.harfbuzz,
        drvs.scdoc,
      ],
      preConfigurePhase = [
        m%"sed -i 's@werror=true@werror=false@g' ${SRC}/meson.build"%
      ],
    }
}
& {
  lib,
  drvs,
  scdoc | lib.MakePackage
    = {
      singleSource = {
        uri = "https://git.sr.ht/~sircmpwn/scdoc/archive/1.11.3.tar.gz",
        sha256sum = "4c5c6136540384e5455b250f768e7ca11b03fdba1a8efc2341ee0f1111e57612",
      },
      extraMakeInstallArgs = [
        "PREFIX=/usr"
      ],
    }
}
