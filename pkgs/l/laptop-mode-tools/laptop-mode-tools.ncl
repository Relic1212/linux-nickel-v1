{
  lib,
  basefiles,

  laptopModeTools | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/rickysarraf/laptop-mode-tools/archive/af33e93e79743bc49b2fe3a13ede1ee3b6f20c1a.zip",
      sha256sum = "e2288037a68290775bfa8fb5c5e6cecf3b6acdda310f87a7e154c42dd1fd9797"
    },
    preConfigurePhase = [
      m%"
            for f in $(find "${SRC}" -type f);do
                sed -i 's@\/sbin@\/bin@g' "${f}"
                sed -i 's@\/bin\/true@\/usr\/bin\/true@g' "${f}"
                sed -i 's@\/bin\/false@\/usr\/bin\/false@g' "${f}"
                sed -i 's@\/bin\/ip@\/usr\/bin\/ip@g' "${f}"
                sed -i 's@\/bin\/modprobe@\/usr\/bin\/modprobe@g' "${f}"
                sed -i 's@\/bin\/blockdev@\/usr\/bin\/blockdev@g' "${f}"

            done
            "%,
      "mv ${SRC}/usr/sbin ${SRC}/usr/bin"
    ],

    buildPhase = [],
    extraMakeInstallArgs = [
      "PREFIX=/usr",
      "LIB_D=/usr/lib",
    ],
    biDrvs =
      lib.biMap [
        basefiles,
      ]
  }
}
