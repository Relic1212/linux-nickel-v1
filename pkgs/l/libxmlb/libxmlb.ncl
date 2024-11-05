{
    lib,
    drvs,
    libxmlb|lib.MesonPackage={
        singleSource={
            uri="https://github.com/hughsie/libxmlb/releases/download/0.3.21/libxmlb-0.3.21.tar.xz",
            sha256sum="642343c9b3eca5c234ef83d3d5f6307c78d024f2545f3cc2fa252c9e14e4efd1",
        },
          biDrvs = [
        drvs.glib,
        drvs.pcre2,
        drvs.libffi,
        drvs.zlibNg,
        # drvs.curl,
        # drvs.openssl,
        # drvs.libpsl,
        # drvs.libxml2,
        # drvs.libyaml,
      ],

      extraMesonArgs=[
        "-Dgtkdoc=false",
        "-Dintrospection=false",
        "-Dtests=false",
        "-Dcli=false",
      ],
    }
}