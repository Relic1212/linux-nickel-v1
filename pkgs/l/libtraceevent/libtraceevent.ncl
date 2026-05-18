{
  lib,
  drvs,
  libtraceevent | lib.MesonPackage = {
    singleSource = {
      uri = "https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/snapshot/libtraceevent-1.8.4.tar.gz",
      sha256sum = "dc456d4d2bf4b4cd4d0c737d3374a8093f9e5ca18c1d7fc2279a4bf41e613121"
    },
    extraMesonArgs = [
      "-Ddoc=false"
    ],
    biDrvs = [
      drvs.linuxHeaders
    ]
  }
}
