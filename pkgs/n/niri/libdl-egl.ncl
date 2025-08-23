{
  lib,
  drvs,
  libdlEgl | lib.Package = {

    extraFiles = [
      {

        sha256sum = "9798c2226e0da713789b3260dc9bcc75699a8a02ed407ba3986da908bb12cb6b",
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
