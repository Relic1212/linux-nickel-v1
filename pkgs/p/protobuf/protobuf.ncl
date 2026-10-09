{
  lib,
  drvs,
  protobuf | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      # uri = "https://github.com/protocolbuffers/protobuf/archive/refs/tags/v28.3.tar.gz",
      # sha256sum = "7c3ebd7aaedd86fa5dc479a0fda803f602caaf78d8aff7ce83b89e1b8ae7442a",
      uri = "https://github.com/protocolbuffers/protobuf/archive/refs/tags/v36.2.tar.gz",
      sha256sum = "7e7eaf580ec77f1a392ff1ab1013c13d3b04a6716f002f697f67f3c1113f0530",
    },
    cmakeArgsRecord = {
      "-Dprotobuf_BUILD_TESTS" = "OFF",
      "-Dprotobuf_ABSL_PROVIDER" = "package",
    },

    preConfigurePhase = [
      # https://github.com/protocolbuffers/protobuf/pull/25667
      m%"sed -i 's@class ABSL_ATTRIBUTE_VIEW RepeatedPtrIterator@class RepeatedPtrIterator@g' ${SRC}/src/google/protobuf/repeated_ptr_field.h"%,
    ],
    biDrvs = [
      drvs.linuxHeaders,
      drvs.abseilCpp,
    ]
  },
  protobuf361 =
    protobuf
    & {
      singleSource | priority 1 = {
        uri = "https://github.com/protocolbuffers/protobuf/archive/refs/tags/v36.1.tar.gz",
        sha256sum = "7a7baff8207a57f3fe5c233d432a09eba67bdfb55a3145839d0817cae8e807a4",
      },
    }
}
& {
  lib,
  drvs,
  protobufC | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.0/protobuf-c-1.5.0.tar.gz",
      sha256sum = "7b404c63361ed35b3667aec75cc37b54298d56dd2bcf369de3373212cc06fd98"
    }
  }
}
