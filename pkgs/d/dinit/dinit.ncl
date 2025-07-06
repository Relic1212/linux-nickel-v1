{
  lib,
  m4,

  dinit | lib.MesonPackage = {
    singleSource = {

      uri = "https://github.com/davmac314/dinit/archive/refs/tags/v0.19.1.tar.gz",
      sha256sum = "e4ef40844ce64ca7476b9acba2adabdca49a2b59c97641a99e7d47904701a5f5"
    },
    #   mesonArgs =
    #     lib.MesonPackage.mesonArgs
    #     @ [
    #       "-Ddinit-sbindir=/usr/bin"
    #     ],
    extraMesonArgs = [
      "-Ddinit-sbindir=/usr/bin"
    ],
    biDrvs =
      lib.biMap [
        m4
      ],
    preConfigurePhase = [
      m%"sed -i 's@\/sbin\/swapoff@\/usr\/bin/swapoff@g' ${SRC}/src/shutdown.cc"%,
      m%"sed -i 's@\/bin\/umount@\/usr\/bin/umount@g' ${SRC}/src/shutdown.cc"%,
    ]
  }
}
