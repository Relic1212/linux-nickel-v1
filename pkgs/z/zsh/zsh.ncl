{
  lib,
  ncurses,
  readline,
  pcre2,
  libcap,
  linuxHeaders,
  bison,
  pkgconf,
  diffutils,

  zsh | lib.AutomakePackage = {
    singleSource = {
      uri = "https://ftp.funet.fi/pub/unix/shells/zsh/zsh-5.9.tar.xz",
      sha256sum = "9b8d1ecedd5b5e81fbf1918e876752a7dd948e05c1a0dba10ab863842d45acd5",
      # uri = "https://github.com/zsh-users/zsh/archive/435cb1b748ce1f2f5c38edc1d64f4ee2424f9b3a.tar.gz",
      # sha256sum = "1b8d95ce7bcb9eb03cbfa5c57c28639f24563283e528988c7509f515d93d935d",
    },
    biDrvs =
      lib.biMap [
        ncurses,
        readline,
        pcre2,
        libcap,
        linuxHeaders,
        bison,
        # pkgconf,
        (diffutils & { priority = 1 }),
      ],

    # copied from OE
    extraConfigureFlags = [
      #"--with-term-lib='ncurses ncursesw'",
      "--with-tcsetpgrp",
      "--enable-cap",
      "--enable-multibyte",
      "--enable-libc-musl",
      "--disable-dynamic-nss",
      "--disable-dynamic",
      # "--enable-dynamic",
      "--enable-function-subdirs",
      "--enable-pcre",
      "  --enable-zsh-secure-free",
      "ac_cv_func_fpurge=no",
      "ac_cv_header_sys_capability_h='yes'",
    ],

    preConfigurePhase = [
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
  },
}
