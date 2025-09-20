{
  lib,
  drvs,
  libfdt | lib.MesonPackage = {
    singleSource = {
      uri = "https://mirrors.edge.kernel.org/pub/software/utils/dtc/dtc-1.7.2.tar.xz",
      sha256sum = "92d8ca769805ae1f176204230438fe52808f4e1c7944053c9eec0e649b237539"
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
