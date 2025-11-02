{
  lib,
  drvs,
  zsh | lib.AutomakePackage = {
    singleSource = {
      # uri = "https://ftp.funet.fi/pub/unix/shells/zsh/zsh-5.9.tar.xz",
      # sha256sum = "9b8d1ecedd5b5e81fbf1918e876752a7dd948e05c1a0dba10ab863842d45acd5",
      # uri = "https://github.com/zsh-users/zsh/archive/435cb1b748ce1f2f5c38edc1d64f4ee2424f9b3a.tar.gz",
      # sha256sum = "1b8d95ce7bcb9eb03cbfa5c57c28639f24563283e528988c7509f515d93d935d",

      uri = "https://github.com/zsh-users/zsh/archive/fb4e83852daaee30d24f3c220a444c537fd4bb1a.tar.gz",
      sha256sum = "21bc12d5e9d0964a1f6b5f48e0383f1660475c5f8149b052523b930cf6b47b2f",
    },

    debug = true,
    biDrvs = [
      drvs.ncurses2,
      drvs.readline,
      drvs.pcre2,
      drvs.libcap,
      drvs.linuxHeaders,
      drvs.bison,
      # drvs.pkgconf,
      (drvs.diffutils & { priority = 1 }),
      (drvs.utilLinux & { priority = 1 }),
      drvs.mandoc,
      drvs.groff,
    ],

    # copied from OE
    extraConfigureFlags = [
      "--with-term-lib='ncurses ncursesw'",
      "--with-tcsetpgrp",
      "--enable-cap",
      "--enable-multibyte",
      "--enable-libc-musl",
      "--disable-dynamic-nss",
      "--disable-dynamic",
      # "--enable-dynamic",
      "--disable-function-subdirs",
      "--disable-site-fndir",
      "--enable-pcre",
      "--disable-zsh-secure-free",
      "--disable-zshenv",
      "ac_cv_func_fpurge=no",
      # "ac_cv_header_sys_capability_h='yes'",
    ],

    preConfigurePhase =
      if (!true) then
        []
      else
        [
          #	m%"sed -i 's@@@g' ${SRC}/Src/utils.c"%
          # "sed -i 's@link=dynamic@link=static@g' ${SRC}/Src/Modules/zpty.mdd",
          # "sed -i 's@load=no@load=yes@g' ${SRC}/Src/Modules/zpty.mdd",
          m%"
      for f in $(find  ${SRC}/Src/Modules -name '*.mdd'); do
        sed -i 's@link=dynamic@link=static@g' "${f}"
        sed -i 's@link=no@link=static@g' "${f}"

        #grep "link=static" "${f}" &&
        sed -i 's@load=no@load=yes@g' "${f}"
      done
    "%,
        ],

    # preBuildPhase = [
    #   m%"
    #   printf "all:\n\techo hello\n" > /tmp/workdir/build/Doc/Makefile
    #   "%
    # ],

    # makeTargets =[
    #   "bin", "modules", "fns",
    #   #  "man",
    #     "runhelp"
    # ],

    # buildPhase =[

    # ],

    #     makeInstallTargets =[
    #       "install.bin", "install.modules", "install.fns",
    #       #  "install.man",
    #         "install.runhelp"
    #     ],
  },
}
