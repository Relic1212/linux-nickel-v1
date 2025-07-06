{
  lib,
  wayland,
  waylandProtocols,
  libdrm,
  libpciaccess,
  linuxHeaders,
  fontconfig,
  freetype,
  pixman,
  pkgconf,
  zlibNg,
  expat,
  libffi,

  wld | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/michaelforney/wld/archive/8990a83a8bb7558a4545a78356d91c19b065011f.tar.gz",
      sha256sum = "8ba3cdd60d1a738bc309583e93303e91bd98a4818dfc5e6451a7bde436331b0d"
    },
    biDrvs =
      lib.biMap [
        wayland,
        waylandProtocols,
        libdrm,
        libpciaccess,
        linuxHeaders,
        fontconfig,
        freetype,
        pixman,
        pkgconf,
        zlibNg,
        expat,
        libffi,
      ],
    buildEnv,
    extraMakeArgs = [
      "ENABLE_SHARED=0",
      "CC=\"clang -static --static\"",
      "DRM_DRIVERS=\"intel\"",
      "PREFIX=/usr",
    ],
    extraMakeInstallArgs = extraMakeArgs,
  }
}
& {
  lib,
  wayland,
  waylandProtocols,
  libdrm,
  libpciaccess,
  linuxHeaders,
  fontconfig,
  freetype,
  pixman,
  pkgconf,
  zlibNg,
  expat,
  libffi,
  wld,
  libxkbcommon,
  libinput,
  eudev,
  mtdev,
  libevdev,

  swc | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/michaelforney/swc/archive/19893a5ca3239082b904a04fdb9ac7c3a1fb62e2.tar.gz",
      sha256sum = "d359df126b40296f6f90d680987f7757c6f50ddd1e7b94f7f5fb21a85a73815d"
    },
    biDrvs =
      lib.biMap [
        wayland,
        waylandProtocols,
        libdrm,
        libpciaccess,
        linuxHeaders,
        fontconfig,
        freetype,
        pixman,
        pkgconf,
        zlibNg,
        expat,
        libffi,
        wld,
        libxkbcommon,
        libinput,
        eudev,
        mtdev,
        libevdev,
      ],
    buildEnv,
    extraMakeArgs = [
      "ENABLE_SHARED=0",
      "CC=\"clang -static --static\"",
      # "DRM_DRIVERS=\"intel\"",
      "ENABLE_XWAYLAND=0",
      "PREFIX=/usr",
    ],
    extraMakeInstallArgs = extraMakeArgs,
  }
}
& {
  lib,
  wayland,
  waylandProtocols,
  libdrm,
  libpciaccess,
  linuxHeaders,
  fontconfig,
  freetype,
  pixman,
  pkgconf,
  zlibNg,
  expat,
  libffi,
  wld,
  libxkbcommon,
  libinput,
  eudev,
  mtdev,
  libevdev,
  swc,
  pkgconfStatic,

  velox | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/michaelforney/velox/archive/fcc041265539befd907a64ee3a536cb2489ffb99.tar.gz",
      sha256sum = "ab1400693473ebae727690898b4a19e88cb447f4516e5ec6ed9ce05e63dd31aa"
    },
    biDrvs =
      lib.biMap [
        wayland,
        waylandProtocols,
        libdrm,
        libpciaccess,
        linuxHeaders,
        fontconfig,
        freetype,
        pixman,
        pkgconf,
        (pkgconfStatic & { priority = 1 }),
        zlibNg,
        expat,
        libffi,
        wld,
        libxkbcommon,
        libinput,
        eudev,
        mtdev,
        libevdev,
        swc,
      ],
    buildEnv,
    extraMakeArgs = [
      "ENABLE_SHARED=0",
      "CC=\"clang -static --static\"",
      # "DRM_DRIVERS=\"intel\"",
      "ENABLE_XWAYLAND=0",
      "PREFIX=/usr",
    ],
    extraMakeInstallArgs = extraMakeArgs,

    postInstallPhase = [
      "install -d -m0755 ${DEST}/etc",
      "install -m0755 velox.conf.sample ${DEST}/etc/velox.conf",
    ]
  }
}
& {
  lib,
  wayland,
  waylandProtocols,
  libdrm,
  libpciaccess,
  linuxHeaders,
  fontconfig,
  freetype,
  pixman,
  pkgconf,
  zlibNg,
  expat,
  libffi,
  wld,
  libxkbcommon,
  libinput,
  eudev,
  mtdev,
  libevdev,
  swc,
  ncurses,
  pkgconfStatic,

  stWayland | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/michaelforney/st/archive/83d6bc6e0efccff6905374c1a5fb550f7c08bd4a.tar.gz",
      sha256sum = "53acc01e3a735ef69d6418d594c6717f6f4826b7ff2f89e3473ce099c29a01cf"
    },
    biDrvs =
      lib.biMap [
        wayland,
        waylandProtocols,
        libdrm,
        libpciaccess,
        linuxHeaders,
        fontconfig,
        freetype,
        pixman,
        pkgconf,
        (pkgconfStatic & { priority = 1 }),
        zlibNg,
        expat,
        libffi,
        wld,
        libxkbcommon,
        libinput,
        eudev,
        mtdev,
        libevdev,
        swc,
        ncurses,
      ],
    buildEnv,
    extraMakeArgs = [
      "ENABLE_SHARED=0",
      "CC=\"clang -static --static\"",
      # "DRM_DRIVERS=\"intel\"",
      "ENABLE_XWAYLAND=0",
      "PREFIX=/usr",
    ],
    extraMakeInstallArgs = extraMakeArgs,

    preConfigurePhase = [
      "sed -i 's@tic -sx st.info@true@g' ${SRC}/Makefile",
    ],
  }
}
& {
  lib,

  pkgconfStatic | lib.Package = {
    installPhase = [
      "install -d -m0755 ${DEST}/usr/bin",
      m%"printf "#!/bin/sh\nexec /usr/bin/pkgconf --static \$@\n" > ${DEST}/usr/bin/pkg-config"%,
      "chmod +x ${DEST}/usr/bin/pkg-config"
    ]
  }
}
