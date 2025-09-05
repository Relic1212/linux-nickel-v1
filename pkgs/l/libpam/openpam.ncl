{
  lib,
  drvs,
  openpam | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://www.openpam.org/downloads/openpam-20250531.tar.gz",
      sha256sum = "c1eb2f3698b0125820d98ddbe569aa6d478d796b8b42590b11ae00f3e7201595"
    },
    buildEnv.EXTRA_CFLAGS = ["-DOPENPAM_STATIC_MODULES"],
    buildEnv.EXTRA_CPPFLAGS = buildEnv.EXTRA_CFLAGS,

    preConfigurePhase = [
      m%"sed -i 's@# include <sys/cdefs.h>@@g' ${SRC}/include/security/openpam.h"%,
      m%"sed -i 's@# include <linker_set.h>@@g' ${SRC}/include/security/openpam.h"%,
      # m%"sed -i 's@# include <linker_set.h>@# include "linker_set.h"@g' ${SRC}/include/security/openpam.h"%,
      # m%"echo "
      # #define SET_DECLARE(set, ptype)					\\
      # extern ptype __weak_symbol *__CONCAT(__start_set_,set);	\\
      # extern ptype __weak_symbol *__CONCAT(__stop_set_,set)
      # " > ${SRC}/include/security/linker_set.h
      # "%,

      # m%"sed -i 's@SET_DECLARE(openpam_static_modules, pam_module_t)@extern pam_module_t __attribute__((__weak__)) *__start_set_openpam_static_modules;\nextern pam_module_t __attribute__((__weak__)) *__stop_set_openpam_static_modules@g' ${SRC}/lib/libpam/openpam_static.c"%,

      # m%"sed -i 's@SET_FOREACH(module, openpam_static_modules)@for (module = (&__start_set_openpam_static_modules); module < (&__stop_set_openpam_static_modules); module++)@g' ${SRC}/lib/libpam/openpam_static.c"%,
    ],
    extraConfigureFlags = [
      "--with-pam-unix",
      "--disable-pic",
      "--verbose",
      "--enable-debug",
      "--enable-debugging-symbols",
      "ac_cv_func_fpurge='no'",
    ],
    extraMakeArgs = ["VERBOSE=1"],
    debug = true,

    patches = [
      {
        sha256sum = "dc8b5fc640c7980646a3d912bb07f2384950551b5e03ab1da7b4f5c8fa18b800",
        file = "openpam.patch"
      }
    ],

    enableParallel = false,

    biDrvs = [
      drvs.linuxHeaders,
      drvs.pkgconf251,
    ],
  }
}
