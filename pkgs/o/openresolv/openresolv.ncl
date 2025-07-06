{
  lib,
  pkgconf,

  openresolv | lib.AutotoolsPackage = {
    name = "openresolv",
    singleSource = {
      uri = "https://github.com/NetworkConfiguration/openresolv/releases/download/v3.13.2/openresolv-3.13.2.tar.xz",
      sha256sum = "36b5bcbe257a940c884f0d74321a47407baabab9e265e38859851c8311f6f0b0",
    },
    buildDir = "${SRC}",
    postInstallPhase = [

      # like so: https://wiki.alpinelinux.org/wiki/Immutable_root_with_atomic_upgrades
      "sed -i 's@etc@run@g' ${DEST}/etc/resolvconf.conf",
      "cd ${DEST}",
      # install -d -m0755 /run
      "install -d -m0755 etc",

      # touch /run/resolv.conf
      "ln -s /run/resolv.conf etc/resolv.conf",
    ],
    biDrvs =
      lib.biMap [
        pkgconf,
      ],
    extraConfigureFlags = [
      "--rundir=/run",
      "--libexecdir=/usr/libexec/openresolv",
    ]
  }
}
