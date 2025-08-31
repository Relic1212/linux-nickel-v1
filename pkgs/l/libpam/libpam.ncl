{
  lib,
  drvs,
  libpam | lib.AutotoolsPackage = {
    name = "libpam",
    singleSource = {
      uri = "https://github.com/linux-pam/linux-pam/releases/download/v1.6.1/Linux-PAM-1.6.1.tar.xz",
      sha256sum = "f8923c740159052d719dbfc2a2f81942d68dd34fcaf61c706a02c9b80feeef8e",
    },
    biDrvs = [
      drvs.linuxHeaders,
    ],
    configureFlags = std.array.filter (fun flag => (flag != "--includedir=/usr/include")) lib.AutotoolsPackage.configureFlags,
  }
}
& {
  lib,
  drvs,
  libpam2016 | lib.AutomakePackage = {
    # https://github.com/linux-pam/linux-pam/commit/a684595c0bbd88df71285f43fb27630e3829121e
    singleSource = {
      # uri = "https://github.com/linux-pam/linux-pam/archive/8bb171506fc2579669fd86bd29885f256e26ccb0.tar.gz",
      # sha256sum = "b656d44dbc738a6c4792355a321c9f2ce5dbfcc2c1547808a36db778faadffc1"

      uri = "https://github.com/linux-pam/linux-pam/archive/refs/tags/Linux-PAM-1.3.0.tar.gz",
      sha256sum = "5dfd41d0e80158ef324b853569aefc2cc1a62e1e63268b1ee95752c946ccedc5"
    },
    separateBuildDir = false,
    preConfigurePhase = [
      "echo 'hello' > ChangeLog"
    ],
    extraConfigureFlags = [
      "--disable-regenerate-docu",
      "--disable-docu",
      "--enable-static-modules",
      "--disable-econf",
    ],
    biDrvs = [
      drvs.gettext,
      drvs.libxml2,
      drvs.libxslt,
      drvs.docbookXslNons,
      drvs.docbookXml,
      drvs.links,
      drvs.xmlto,
    ]
  }
}
& {
  lib,
  drvs,
  libpam131 | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/linux-pam/linux-pam/releases/download/v1.3.1/Linux-PAM-1.3.1.tar.xz",
      sha256sum = "eff47a4ecd833fbf18de9686632a70ee8d0794b79aecb217ebd0ce11db4cd0db"
    },

    sourceInputs = [
      {
        src = singleSource
      },
      {
        src = {
          uri = "https://git.openembedded.org/openembedded-core/plain/meta/recipes-extended/pam/libpam/0001-Add-support-for-defining-missing-funcitonality.patch?h=gatesgarth",
          sha256sum = "d14c6c69c850e0c3de9fe9ca5fe936f8327cb7b5b62156d5f959d3f64db1ffba"
        }
      },
      {
        src = {
          uri = "https://git.openembedded.org/openembedded-core/plain/meta/recipes-extended/pam/libpam/include_paths_header.patch?h=gatesgarth",
          sha256sum = "225dfb17aa3daae23aa4d513c33ec9f73bafe5d101473de4912fb52105a2dc94"
        }
      }
    ],
    separateBuildDir = false,
    preConfigurePhase = [
      # "sed -i 's|strndupa|strndup|g' ${SRC}/modules/pam_exec/pam_exec.c",
      "patch -p1 < '0001-Add-support-for-defining-missing-funcitonality.patch?h=gatesgarth'",
      "patch -p1 < 'include_paths_header.patch?h=gatesgarth'",
      "sed -i 's|#include <errno.h>|#include <errno.h>\\n#include <sys/time.h>|g' ${SRC}/modules/pam_lastlog/pam_lastlog.c",
    ],
    # buildEnv.EXTRA_CPPFLAGS=[
    #   m%"-D_PATH_LASTLOG=\"\\\"/usr/adm/lastlog\\\"\""%,
    # ],
    extraConfigureFlags = [
      "--disable-regenerate-docu",
      "--disable-docu",
      "--enable-static-modules",
      "--disable-econf",
      "--includedir=/usr/include/security",
    ],
    biDrvs = [
      drvs.gettext,
      drvs.libxml2,
      drvs.libxslt,
      drvs.docbookXslNons,
      drvs.docbookXml,
      drvs.links,
      drvs.xmlto,
    ]
  }
}
