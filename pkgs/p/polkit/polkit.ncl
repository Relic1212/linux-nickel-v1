{
  lib,
  drvs,
  distro,
  polkit | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/polkit-org/polkit/archive/refs/tags/126.tar.gz",
      sha256sum = "2814a7281989f6baa9e57bd33bbc5e148827e2721ccef22aaf28ab2b376068e8"
    },
    sourceInputs = [
      {
        src = singleSource
      },
      {
        src = {
          uri = "https://github.com/polkit-org/polkit/commit/55ee1b70456eca8281dda9612c485c619122f202.patch",
          sha256sum = "48849214d98bf9012cada55419b6b457952e318229aeff38d1041a93cbdae106"
        }
      }
    ],

    options = {
      elogind | Bool | default = true,
      # pam | Bool |default = false ,
      pam | Bool | default = distro.pam,
    },
    buildEnv.EXTRA_LDFLAGS = if options.pam then ["-lcap", "-lpam_misc"] else [],
    extraMesonArgs = [
      "-Dintrospection=false",
      "-Dauthfw=%{if options.pam then "pam" else "shadow"}",
      "-Dsession_tracking=%{ if options.elogind then  "elogind" else "no" }",
      "-Dman=true",
    ],
    preConfigurePhase = [
      "(cd ${SRC} && patch -p1 < 55ee1b70456eca8281dda9612c485c619122f202.patch)",
      "sed -i 's@shared_library@library@g' ${SRC}/src/polkitagent/meson.build",
      "sed -i 's@shared_library@library@g' ${SRC}/src/polkit/meson.build",
      m%"sed -i 's@http://docbook.sourceforge.net/release/xsl/current@/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2@g' ${SRC}/docs/man/meson.build"%,
    ],
    biDrvs = [
      drvs.inih,
      drvs.scdoc,
      drvs.linuxHeaders,
      drvs.gettext,
      drvs.perl,
      drvs.libxslt,
      drvs.docbookXslNons,
      drvs.docbookXml,
    ],
    neverInclude = [
      # could maybe also add wayland & wayland-protocols
      drvs.libpam,
    ],
    pDrvs =
      [
        drvs.expat,
        # drvs.libffi,
        # drvs.libpciaccess,
        drvs.libxkbcommon,
        drvs.libdrm,
        # drvs.mtdev,
        # drvs.libevdev,
        # drvs.eudev,
        drvs.libinput,
        drvs.glib,
        drvs.gudev,
        # drvs.pcre2,
        # drvs.zlibNg,
        drvs.dbus,
        drvs.duktape,
        drvs.attr,
        drvs.acl,
        # drvs.libcap,
      ]
      @ (
        if options.elogind then
          [
            drvs.elogindWithPolkit,
          ]
        else
          []
      )
      @ (
        if options.pam then
          [
            drvs.libpamFinal,
          ]
        else
          []
      )
  }
}
& {
  lib,
  drvs,
  duktape | lib.MakePackage = {
    singleSource = {
      uri = "https://duktape.org/duktape-2.7.0.tar.xz",
      sha256sum = "90f8d2fa8b5567c6899830ddef2c03f3c27960b11aca222fa17aa7ac613c2890"
    },

    # patches = [
    #     {
    #        sha256sum =  "24e1864b47cbf9ed71c63d719a76cdc771a8fd0164baf73a554f7ef03368f503",
    #        file =  "duktape.patch"
    #     }
    # ],
    preConfigurePhase = [
      # m%"sed -i 's@-shared@@g' Makefile.sharedlibrary"%,
      # m%"sed -i 's@\.so@.a@g' Makefile.sharedlibrary"%,
    ],
    buildPhase = [
      "make -f Makefile.cmdline LIBDIR=/lib INSTALL_PREFIX=/usr PREFIX=/usr",
      "make -f Makefile.sharedlibrary LIBDIR=/lib INSTALL_PREFIX=/usr PREFIX=/usr duktape.pc",
      "make -f Makefile.sharedlibrary LIBDIR=/lib INSTALL_PREFIX=/usr PREFIX=/usr",
      "clang -c src/duktape.c -o duktape_static.o",
      "llvm-ar rcs libduktape.a duktape_static.o",
    ],
    installPhase = [
      #  "install -dm0755 ${DEST}/usr/lib/",
      "make -f Makefile.sharedlibrary LIBDIR=/lib INSTALL_PREFIX=/usr DESTDIR=${DEST} install",
      "rm -rf ${DEST}/usr/lib/*.so",
      "install -m0755 libduktape.a ${DEST}/usr/lib/",
    ]
  }
}
