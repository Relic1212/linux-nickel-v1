{
  lib,
  drvs,
  iproute2 | lib.AutotoolsPackage = {
    # singleSource={
    #     uri="https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/snapshot/iproute2-6.11.0.tar.gz",
    #     sha256sum="e5ad1c86aa788a979ba1b68cd6ee948b37983d99efabf6a0bf556b061569cc4d",
    # },

    singleSource = {
      uri = "https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/snapshot/iproute2-6.10.0.tar.gz",
      sha256sum = "060ee42dfcdf8b9daf9f986eee26d16ac5bdf39c8784702957b13bebec538541",
    },
    preConfigurePhase = [
      # https://github.com/alpinelinux/aports/blob/3d6d332cfd241099d4bbb90f8ad955692ac09120/main/iproute2/0001-libnetlink-fix-build-with-musl-and-gcc-14.patch#L9
      m%"sed -i 's@#include <stdio.h>@#include <endian.h>\n#include <stdio.h>@g' ${SRC}/include/libnetlink.h"%
    ],
    separateBuildDir = false,
    extraEnv = {
      CBUILD_CFLAGS = "\"-static --static\"",
      HOSTCC = ["clang"],
    },
    configureFlags = [
      "--prefix /usr",
    ],
    extraMakeArgs = [
      "CBUILD_CFLAGS=\"-static --static\"",
      "SBINDIR=/usr/bin",
    ],
    extraMakeInstallArgs = [
      "SBINDIR=/usr/bin",
    ],
    biDrvs = [
      drvs.linuxHeaders,
      drvs.pkgconf,
      drvs.m4,
      drvs.flex,
      drvs.bison,
    ]
  }
}
