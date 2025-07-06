{
  lib,
  fontconfig,
  freetype,
  zlibNg,
  gperf,
  pixman,
  wayland,
  waylandProtocols,
  libffi,
  libxkbcommon,
  expat,
  linuxHeaders,
  ncurses,
  readline,
  pcre2,
  pango,
  cairo,
  libpng,
  harfbuzz,
  scdoc,

  lavalauncher | lib.MesonPackage = {
    singleSource = {
      # uri = m%"https://git.sr.ht/~leon_plickat/lavalauncher/archive/1050f33b0a3315bcd226f648392532c52467c9d7.tar.gz"%,
      # sha256sum = "c044786afbde54a524cb9bce49f4a90fbbe7f860f441f6229ef1f56b75ba6392"
      uri = m%"https://git.sr.ht/~leon_plickat/lavalauncher/archive/da17d8a29bfc6b78280242b8fdbcb1b6df4f8aff.tar.gz"%,
      sha256sum = "137f1726e61871b62d12d60528c8a73ac0a3c6dbd53193e4f7795a8f953a031e"
    },

    biDrvs =
      lib.biMap [
        fontconfig,
        freetype,
        zlibNg,
        gperf,
        pixman,
        wayland,
        waylandProtocols,
        libffi,
        libxkbcommon,
        expat,
        linuxHeaders,
        ncurses,
        readline,
        pcre2,
        pango,
        cairo,
        libpng,
        harfbuzz,
        scdoc,
      ],
    preConfigurePhase = [
      m%"sed -i 's@werror=true@werror=false@g' ${SRC}/meson.build"%
    ],
  }
}
& {
  lib,

  scdoc | lib.MakePackage = {
    singleSource = {
      uri = "https://git.sr.ht/~sircmpwn/scdoc/archive/1.11.3.tar.gz",
      sha256sum = "4c5c6136540384e5455b250f768e7ca11b03fdba1a8efc2341ee0f1111e57612",
    },
    extraMakeInstallArgs = [
      "PREFIX=/usr"
    ],
  }
}
