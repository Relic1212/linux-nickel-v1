{

  drvs,
  lib,

  autoconf | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://ftp.gnu.org/gnu/autoconf/autoconf-2.72.tar.gz",
      sha256sum = "afb181a76e1ee72832f6581c0eddf8df032b83e2e0239ef79ebedc4467d92d6e",
    },
    biDrvs = [
      drvs.perl,
      drvs.m4
    ]
  },
  autoconf269 | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz",
      sha256sum = "954bd69b391edc12d6a4a51a2dd1476543da5c6bbf05a95b59dc0dd6fd4c2969",
    },
    biDrvs = [
      drvs.perl,
      drvs.m4
    ]
  },
}
