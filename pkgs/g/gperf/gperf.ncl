{
  lib,
  gperf | lib.AutotoolsPackage = {
    #name = "gperf",
    singleSource = {
      uri = "http://ftp.gnu.org/pub/gnu/gperf/gperf-3.1.tar.gz",
      sha256sum = "588546b945bba4b70b6a3a616e80b4ab466e3f33024a352fc2198112cdbb3ae2",
    },
    preConfigurePhase = [
      # https://patchwork.yoctoproject.org/project/oe-core/patch/20230114154921.3757493-5-raj.khem@gmail.com/
      "sed -i 's@register int c = getc (stream);@int c = getc (stream);@g' ${SRC}/lib/getline.cc"
    ]
    # buildEnv.CXXFLAGS=lib.AutotoolsPackage.buildEnv.CXXFLAGS @[ "-Wno-deprecated-register" ],
  }
}
