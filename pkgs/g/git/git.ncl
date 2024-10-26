{
  lib,
  pkgs,
  git | lib.AutotoolsPackage
    = {
      name = "git",
      singleSource = {
        uri = "https://www.kernel.org/pub/software/scm/git/git-2.39.0.tar.xz",
        sha256sum = "ba199b13fb5a99ca3dec917b0bd736bc0eb5a9df87737d435eddfdf10d69265b",
      },
      buildDir = "${SRC}",
      # extraConfigureFlags=[
      #     "--without-iconv",
      #     "--without-tcltk",
      #     "--disable-nls",
      #   "NO_TCLTK=YesPlease" ,"NO_GETTEXT=YesPlease", "MSGFMT=/usr/bin/true",

      # ],
      extraMakeArgs = [
        "NO_TCLTK=YesPlease",
        "NO_GETTEXT=YesPlease" #, "MSGFMT=/usr/bin/true",
      ],
      extraMakeInstallArgs = extraMakeArgs,
      biPkgs = [
        pkgs.zlibNg,
      ]
    }
}
