{
  lib,
  drvs,
  brightnessctl | lib.AutotoolsPackage
    = {
      singleSource = {
        uri = "https://github.com/Hummer12007/brightnessctl/archive/7586bd231433325077adf32dfcd3e5382fb465e9.zip",
        sha256sum = "9a7ffef3a42ed7a38eab4268243b783c11c12bb62d57b54a2a2fd22fd47222ce",
      },
      configureFlags = [
        "--prefix=/usr",
        "--udev-dir=/usr/lib/udev/rules.d"
      ],
      biDrvs = [
        drvs.basu,
      ],
      separateBuildDir = false,
    }
}
