{
  lib,
  drvs,
  ncurses | lib.AutotoolsPackage = {
    name = "ncurses",
    singleSource = {
      uri = "https://invisible-island.net/archives/ncurses/ncurses-6.6.tar.gz",
      sha256sum = "355b4cbbed880b0381a04c46617b7656e362585d52e9cf84a67e2009b749ff11",
    },
    extraConfigureFlags = [
      "--without-ada",
      "--without-tests",
      "--disable-termcap",
      "--disable-rpath-hack",
      "--enable-pc-files",
      "--enable-widec",
      "--disable-root-access",
      "bash_cv_termcap_lib=ncurses",
      # "--with-shared-termcap-library",
      # "--with-ticlib",
      # "--with-terminfo=ticlib",
    ],
    postInstallPhase = [
      "cd ${DEST}/usr/lib",
      "ln -s ibformw.a ibform.a",
      "ln -s libformw_g.a libform_g.a",
      "ln -s libmenuw.a libmenu.a",
      "ln -s libmenuw_g.a libmenu_g.a",
      "ln -s libncurses++w.a libncurses++.a",
      "ln -s libncurses++w_g.a libncurses++_g.a",
      "ln -s libncursesw.a libncurses.a",
      "ln -s libncursesw_g.a libncurses_g.a",
      "ln -s libpanelw.a libpanel.a",
      "ln -s libpanelw_g.a libpanel_g.a",
      "cd pkgconfig",
      "ln -s formw.pc form.pc",
      "ln -s menuw.pc menu.pc",
      "ln -s ncurses++w.pc ncurses++.pc",
      "ln -s ncursesw.pc ncurses.pc",
      "ln -s panelw.pc panel.pc",
    ],
    biDrvs = [
      drvs.pkgconf,
    ]
  },
  ncursesPic =
    ncurses
    & {
      buildEnv = {
        EXTRA_CFLAGS = ["-fPIC"],
        EXTRA_CXXFLAGS = ["-fPIC"],
        EXTRA_LDFLAGS = ["-fPIC"],
      }
    }
}
& {
  lib,
  drvs,
  ncurses,
  ncurses2 | lib.AutotoolsPackage = {
    singleSource = ncurses.singleSource,

    extraConfigureFlags = [
      "--without-shared",
      "--enable-pc-files",
    ],

    biDrvs = [
      drvs.pkgconf
    ]
  }
}
