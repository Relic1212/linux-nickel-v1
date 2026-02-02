{
  lib,
  drvs,
  lua | lib.MakePackage = {
    singleSource = {
      uri = "https://www.lua.org/ftp/lua-5.4.7.tar.gz",
      sha256sum = "9fbf5e28ef86c69858f6d3d34eccc32e911c1a28b4120ff3e84aaa70cfbf1e30",
    },
    extraMakeArgs = [
      "CC=\"${CC}\"",
      "CFLAGS=\"${CFLAGS}\"",
      "LDFLAGS=\"${LDFLAGS}\"",
    ],
    extraMakeInstallArgs = [
      "PREFIX=/usr",
      "INSTALL_TOP=${DEST}/usr",
    ],
    postInstallPhase = [
      "install -d -m0755 ${DEST}/usr/lib/pkgconfig",
      # "make PREFIX=/usr INSTALL_TOP=${DEST}/usr pc > ${DEST}/usr/lib/pkgconfig/lua.pc",
      # https://www.linuxfromscratch.org/~ken/fontconfig-systemd/general/lua.html
      m%"
      cat > ${DEST}/usr/lib/pkgconfig/lua.pc << "EOF"
      V=5.4
      R=5.4.7

      prefix=/usr
      INSTALL_BIN=${prefix}/bin
      INSTALL_INC=${prefix}/include
      INSTALL_LIB=${prefix}/lib
      INSTALL_MAN=${prefix}/share/man/man1
      INSTALL_LMOD=${prefix}/share/lua/${V}
      INSTALL_CMOD=${prefix}/lib/lua/${V}
      exec_prefix=${prefix}
      libdir=${exec_prefix}/lib
      includedir=${prefix}/include

      Name: Lua
      Description: An Extensible Extension Language
      Version: ${R}
      Requires:
      Libs: -L${libdir} -llua -lm 
      Cflags: -I${includedir}
      EOF
      "%
    ],
  },

  lua51 | lib.MakePackage =
    lua
    & {
      singleSource | priority 1 = {
        uri = "https://www.lua.org/ftp/lua-5.1.5.tar.gz",
        sha256sum = "2640fc56a795f29d28ef15e13c34a47e223960b0240e8cb0a82d9b0738695333"
      },
      makeTargets = [
        "linux",
      ],
      extraMakeArgs | priority 1 =
        lua.extraMakeArgs
        @ [
          "MYLDFLAGS=-static"
        ],
      postInstallPhase | priority 1 = [],
      biDrvs = [
        drvs.ncurses,
        drvs.readline,
      ]
    }
}
