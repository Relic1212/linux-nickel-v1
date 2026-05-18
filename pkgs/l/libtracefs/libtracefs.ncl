{
  lib,
  drvs,
  libtracefs | lib.MesonPackage = {
    singleSource = {
      uri = "https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/snapshot/libtracefs-1.8.2.tar.gz",
      sha256sum = "255980e1da5648fbbc32777ed8457b485b2b96f3449674610b46d9c437271209"
    },
    extraMesonArgs = [
      "-Ddoc=false"
    ],
    preConfigurePhase =
      let patchShebangs = (fun s =>
        m%"sed -i 's@\/bin\/bash@\/usr\/bin\/bash@g' ${SRC}/%{s}"%
      )
      in
      std.array.map
        patchShebangs
        [
          "samples/extract-example.sh",
          "Documentation/install-docs.sh.in",
          "check-manpages.sh",
        ],
    biDrvs = [
      drvs.linuxHeaders,
      drvs.libtraceevent,
      drvs.flex,
      drvs.bison,
      drvs.m4,
      drvs.bash,
    ]
  }
}
