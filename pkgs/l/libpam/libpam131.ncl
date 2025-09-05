{
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
    buildEnv.EXTRA_CFLAGS = ["--verbose"],
    buildEnv.EXTRA_LDFLAGS = ["-Wl,--verbose"],
    enableParallel = false,
    extraConfigureFlags = [
      # "--disable-regenerate-docu",
      # "--disable-docu",
      "--enable-static-modules",
      # "--disable-econf",
      "--disable-pie",
      "--includedir=/usr/include/security",
    ],
    extraMakeArgs = [
      "VERBOSE=1"
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
