{
  lib,
  pkgs,
  readline | lib.AutotoolsPackage
    = {
      name = "readline",
      singleSource = {
        uri = "https://ftp.gnu.org/gnu/readline/readline-8.2.tar.gz",
        sha256sum = "3feb7171f16a84ee82ca18a36d7b9be109a52c04f492a053331d7d1095007c35",
      },
      isStatic,
      isLlvm,
      buildEnv= let b=
        (((lib.AutotoolsPackage & { isStatic, isLlvm }).buildEnv)  &{
        _isStatic=isStatic,_isLlvm=true,})
      

        in (b& {
            LDFLAGS|priority 10= b.LDFLAGS @ ["-lncursesw"]
        }),

      extraConfigureFlags = [
        "--with-curses",
        "ac_cv_header_termcap_h=no",
        "--without-ada",
        "--without-tests",
        "--disable-termcap",
        "--disable-rpath-hack",
        "--enable-pc-files",
        "--enable-widec",
        "--disable-root-access",
        "bash_cv_termcap_lib=ncurses",
        "--with-shared-termcap-library",
        "--with-ticlib",
        "--with-terminfo=ticlib",
      ],
      biPkgs = [
        pkgs.ncurses,
      ]
    }
}
