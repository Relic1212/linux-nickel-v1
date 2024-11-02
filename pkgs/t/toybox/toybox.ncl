{
  lib,
  drvs,
  toybox | lib.MakePackage
    = {
      makeArgs,
      buildEnv,
      singleSource = {
        uri = "https://landley.net/toybox/downloads/toybox-0.8.11.tar.gz",
        sha256sum = "15aa3f832f4ec1874db761b9950617f99e1e38144c22da39a71311093bfe67dc",
      },
      extraEnv = {
        HOSTCFLAGS = buildEnv.STATIC_CFLAGS,
        HOSTLDFLAGS = buildEnv.STATIC_LDFLAGS,
        HOSTCC = ["clang", "-static"],
      },

      configurePhase = [
        m%"
            fix() {
                sed -i 's@\/bin\/bash@\/usr\/bin\/bash@g' ${1}
            }
            for f in $(find ./scripts -type f);do
                fix ${f}
            done
            "%,
        "./scripts/genconfig.sh",
        "make %{std.string.join " " makeArgs } defconfig"
      ],
      biDrvs = [
        drvs.bash,
        drvs.linuxHeaders,
      ]
    }
}
