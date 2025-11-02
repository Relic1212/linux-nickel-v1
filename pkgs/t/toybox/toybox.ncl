{
  lib,
  drvs,
  toybox | lib.MakePackage = {
    makeArgs,
    buildEnv,
    singleSource = {
      # uri = "https://landley.net/toybox/downloads/toybox-0.8.11.tar.gz",
      # sha256sum = "15aa3f832f4ec1874db761b9950617f99e1e38144c22da39a71311093bfe67dc",
      uri = "https://github.com/landley/toybox/archive/refs/tags/0.8.13.tar.gz",
      sha256sum = "fa84ca399c2a88c3d841db943052911355b817f8151cd6bfb9e0b12541e4828c",
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

    patches = [
      {
        sha256sum = "b70304b53411cbfee89c95fa35f3b14a4d2636aef671f15aaa0c3937f0ec2ad2",
        file = "toybix-usrbin.patch",
      }
    ],

    # extraMakeInstallArgs = [
    #   "PREFIX=${DEST}/usr",
    # ],

    installPhase = [
      "install -dm0755 ${DEST}/usr/bin",
      "install -m0755 toybox ${DEST}/usr/bin",
      "cd ${DEST}/usr/bin",
      "for i in $(./toybox); do ln -s toybox $i; done",
    ],

    # postInstallPhase = [
    #   "touch /fail"
    # ],
    biDrvs = [
      drvs.bash,
      drvs.linuxHeaders,
      drvs.attr,
    ]
  }
}
