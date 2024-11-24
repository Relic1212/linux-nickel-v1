{
  lib,
  drvs,

  opendoas | lib.AutotoolsPackage
    = {
      singleSource = {
        uri = "https://github.com/Duncaen/OpenDoas/archive/v6.8.2.tar.gz",
        sha256sum = "6da058a0e70b7543bc60624389b0b00b686189ec933828c522bf8b2600495a67"
      },
      separateBuildDir = false,
      biDrvs = [
        drvs.bison,
        drvs.m4,
        drvs.basefiles,
      ],
      configureFlags = [
        "--prefix=/usr",
        "--enable-static",
        "--without-pam",
      ],
      installPhase =
        (lib.AutotoolsPackage.installPhase)
        @ [
          "install -d -m0755 ${DEST}/etc",
          m%"
            echo "permit persist :wheel" >> ${DEST}/etc/doas.conf
            "%,
          "chmod u+s ${DEST}/usr/bin/doas"
        ]
    }
}
