{
  lib,
  drvs,
  libfdt | lib.MesonPackage = {
    singleSource = {
      uri = "https://mirrors.edge.kernel.org/pub/software/utils/dtc/dtc-1.8.1.tar.xz",
      sha256sum = "23526015a6f1550e0541a53fe7acea1b5a11e3697cdf3a3bdc076abc38f6045d"
    },

    preConfigurePhase = [
      m%"sed -i "s|'-Wsuggest-attribute=format',||g" ${SRC}/meson.build"%,
      m%"sed -i "s|-Wsuggest-attribute=format||g" ${SRC}/Makefile"%,
      m%"for f in $(find ${SRC} -name meson.build); do sed -i 's@both_libraries@library@g' ${f};done"%,
      m%"for f in $(find ${SRC} -name meson.build); do sed -i 's@.get_static_lib()@@g' ${f};done"%,
      m%"for f in $(find ${SRC} -name meson.build); do sed -i 's@.get_shared_lib()@@g' ${f};done"%,
    ],

    biDrvs = [
      drvs.flex,
      drvs.bison,
      drvs.m4,
    ]
  }
}
