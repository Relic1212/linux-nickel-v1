{
  configureFlags = [
    "--prefix=/usr",
    "--exec_prefix=/usr",
    "--bindir=/usr/bin",
    "--sbindir=/usr/bin",
    "--libexecdir=/usr/libexec",
    "--datadir=/usr/share",
    "--sysconfdir=/etc",
    "--sharedstatedir=/com",
    "--localstatedir=/var",
    "--libdir=/usr/lib",
    "--includedir=/usr/include",
    "--oldincludedir=/usr/include",
    "--infodir=/usr/share/info",
    "--mandir=/usr/share/man"
  ],

  configureFlagsByField = {
    "--prefix" = "/usr",
    "--exec_prefix" = "/usr",
    "--bindir" = "/usr/bin",
    "--sbindir" = "/usr/bin",
    "--libexecdir" = "/usr/libexec",
    "--datadir" = "/usr/share",
    "--sysconfdir" = "/etc",
    "--sharedstatedir" = "/com",
    "--localstatedir" = "/var",
    "--libdir" = "/usr/lib",
    "--includedir" = "/usr/include",
    "--oldincludedir" = "/usr/include",
    "--infodir" = "/usr/share/info",
    "--mandir" = "/usr/share/man"
  },

  configureFlagsStatic = [
    "--enable-static",
    "--disable-shared"
  ],
  configureFlagsStaticByField = {
    "--enable-static",
    "--disable-shared"
  },
  mesonArgs = [
    "--prefix=/usr",
    "--buildtype=release",
    "--bindir=bin",
    "--sbindir=bin",
    "--datadir=share",
    "--libdir=lib",
    "--libexecdir=libexec",
    "--includedir=include",
    "--mandir=share/man",
    "--infodir=share/info",
    "--sysconfdir=/etc",
    "--localstatedir=/var",
    "--sharedstatedir=/com",
    "--wrap-mode=nodownload",
  ],
  mesonArgsDebug = [
    "--prefix=/usr",
    "--buildtype=debug",
    "--bindir=bin",
    "--sbindir=bin",
    "--datadir=share",
    "--libdir=lib",
    "--libexecdir=libexec",
    "--includedir=include",
    "--mandir=share/man",
    "--infodir=share/info",
    "--sysconfdir=/etc",
    "--localstatedir=/var",
    "--sharedstatedir=/com",
    "--wrap-mode=nodownload",
  ],
  mesonArgsByField = {
    "--prefix" = "/usr",
    "--buildtype" = "release",
    "--bindir" = "bin",
    "--sbindir" = "bin",
    "--datadir" = "share",
    "--libdir" = "lib",
    "--libexecdir" = "libexec",
    "--includedir" = "include",
    "--mandir" = "share/man",
    "--infodir" = "share/info",
    "--sysconfdir" = "/etc",
    "--localstatedir" = "/var",
    "--sharedstatedir" = "/com",
    "--wrap-mode" = "nodownload",
  },
  mesonArgsStatic = [
    "--prefer-static",
    "-Ddefault_library=static",
  ],
  mesonArgsStaticByField = {
    "--prefer-static",
    "-Ddefault_library=static",
  },
  cmakeArgs = [
    "-DCMAKE_INSTALL_BINDIR:PATH=bin",
    "-DCMAKE_INSTALL_SBINDIR:PATH=bin",
    "-DCMAKE_INSTALL_LIBEXECDIR:PATH=libexec",
    "-DCMAKE_INSTALL_SYSCONFDIR:PATH=/etc",
    "-DCMAKE_INSTALL_SHAREDSTATEDIR:PATH=../com",
    "-DCMAKE_INSTALL_LOCALSTATEDIR:PATH=/var",
    "-DCMAKE_INSTALL_LIBDIR:PATH=lib",
    "-DCMAKE_INSTALL_INCLUDEDIR:PATH=include",
    "-DCMAKE_INSTALL_DATAROOTDIR:PATH=share",
    "-DCMAKE_BUILD_TYPE=Release",
    "-DCMAKE_INSTALL_PREFIX=/usr"
  ],
  cmakeArgsByField = {
    "-DCMAKE_INSTALL_BINDIR:PATH" = "bin",
    "-DCMAKE_INSTALL_SBINDIR:PATH" = "bin",
    "-DCMAKE_INSTALL_LIBEXECDIR:PATH" = "libexec",
    "-DCMAKE_INSTALL_SYSCONFDIR:PATH" = "/etc",
    "-DCMAKE_INSTALL_SHAREDSTATEDIR:PATH" = "../com",
    "-DCMAKE_INSTALL_LOCALSTATEDIR:PATH" = "/var",
    "-DCMAKE_INSTALL_LIBDIR:PATH" = "lib",
    "-DCMAKE_INSTALL_INCLUDEDIR:PATH" = "include",
    "-DCMAKE_INSTALL_DATAROOTDIR:PATH" = "share",
    # "-DCMAKE_BUILD_TYPE" = "Release",
    "-DCMAKE_INSTALL_PREFIX" = "/usr"
  },

  # cmakeArgsRecord = {
  #   CMAKE_INSTALL_BINDIR = "bin",
  #   CMAKE_INSTALL_SBINDIR = "bin",
  #   CMAKE_INSTALL_LIBEXECDIR = "libexec",
  #   CMAKE_INSTALL_SYSCONFDIR = "/etc",
  #   CMAKE_INSTALL_SHAREDSTATEDIR = "../com",
  #   CMAKE_INSTALL_LOCALSTATEDIR = "/var",
  #   DCMAKE_INSTALL_LIBDIR = "lib",
  #   CMAKE_INSTALL_INCLUDEDIR = "include",
  #   CMAKE_INSTALL_DATAROOTDIR = "share",
  #   CMAKE_BUILD_TYPE = "Release",
  #   CMAKE_INSTALL_PREFIX = "/usr"
  # },

  cmakeArgsStatic = [
    "-DBUILD_SHARED_LIBS:BOOL=OFF",
    "-DBUILD_STATIC_LIBS:BOOL=ON",
    "-DCMAKE_LINK_SEARCH_START_STATIC:BOOL=ON",
    "-DCMAKE_SKIP_INSTALL_RPATH:BOOL=ON",
  ],

  cmakeArgsStaticByField = {
    "-DBUILD_SHARED_LIBS" = false,
    "-DBUILD_STATIC_LIBS" = true,
    "-DCMAKE_LINK_SEARCH_START_STATIC" = false,
    "-DCMAKE_SKIP_INSTALL_RPATH" = true,
  },

  staticFlags = ["-static", "--static"],
  stage0Flags = {
    CPPFLAGS = [
      "--sysroot=/tmp/workdir/sysroot/",
      "-L/tmp/workdir/sysroot/usr/lib",
      "-I/tmp/workdir/sysroot/usr/include",
      "-isystem/tmp/workdir/sysroot"
    ],

    LDFLAGS = ["-L/tmp/workdir/sysroot/usr/lib", ],
  },
  buildFlagSep = " \\\n\t",
}
