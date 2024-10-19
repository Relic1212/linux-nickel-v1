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
  configureFlagsStatic = [
    "--enable-static",
    "--disable-shared"
  ],
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
  mesonArgsStatic = [
    "--prefer-static",
    "-Ddefault_library=static",
  ],

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
  cmakeArgsStatic = [
    "-DBUILD_SHARED_LIBS:BOOL=OFF",
    "-DBUILD_STATIC_LIBS:BOOL=ON",
    "-DCMAKE_LINK_SEARCH_START_STATIC:BOOL=ON",
    "-DCMAKE_SKIP_INSTALL_RPATH:BOOL=ON",
  ],
  staticFlags = ["-static", "--static"],
}
