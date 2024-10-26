{
  lib,
  pkgs,
  ncurses | lib.AutotoolsPackage
    = {
      name = "ncurses",
      singleSource = {
        uri = "https://invisible-mirror.net/archives/ncurses/current/ncurses-6.5-20240914.tgz",
        sha256sum = "fe1c20f231c5a769ca6b1dbd5f367f6921082ce73417eb7d30db258d86822164",
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
      biPkgs = [
        pkgs.pkgconf,
      ]
    }
}
