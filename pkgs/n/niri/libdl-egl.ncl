{
  lib,
  drvs,
  libdlEgl | lib.Package = {
    # singleSource = {
    #   uri = "%{path_to}/libdl_egl.a",
    #   sha256sum = "f5a0c94bca5de6b4a4141cf1950e614c26855b6397a70bebc81acac1f1fb5af2",

    # },

    extraFiles = [
      {

        sha256sum = "31140462f1e5db7b11ba9c7658f1123045aa59c76d512d4926329d1ecec8ec97",
        file = "libdl_egl.c",
      }
    ],
    buildPhase = [
      "clang -c /tmp/workdir/files/libdl_egl.c -o libdl_egl.c.o",
      "llvm-ar rcs libdl_egl.a libdl_egl.c.o",
      "ranlib libdl_egl.a",
    ],
    installPhase = [
      "install -d -m0755 ${DEST}/usr/lib",
      "install -m0755 libdl_egl.a ${DEST}/usr/lib",
    ],
    enableCcache = false,
    biDrvs = [
      drvs.llvm,
      drvs.mesa2,
      drvs.musl,
    ]
  }
}
