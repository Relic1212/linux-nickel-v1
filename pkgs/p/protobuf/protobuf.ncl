{
    lib,
    drvs,
    protobuf | lib.CmakePackage = {
        generator = "Ninja",
        singleSource = {
            uri ="https://github.com/protocolbuffers/protobuf/archive/refs/tags/v28.3.tar.gz",
            sha256sum ="7c3ebd7aaedd86fa5dc479a0fda803f602caaf78d8aff7ce83b89e1b8ae7442a"
        },
        cmakeArgsRecord = {
            "-Dprotobuf_BUILD_TESTS"="OFF",
            "-Dprotobuf_ABSL_PROVIDER" = "package",
        },
        biDrvs = [
            drvs.linuxHeaders,
            drvs.abseilCpp,
        ]
    }
}

&

{
    lib,
    drvs,
    protobufC|lib.AutotoolsPackage = {
        singleSource = {
            uri ="https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.0/protobuf-c-1.5.0.tar.gz",
            sha256sum = "7b404c63361ed35b3667aec75cc37b54298d56dd2bcf369de3373212cc06fd98"
                  }
    }
}

&
{
    lib,
    drvs,
    abseilCpp | lib.CmakePackage = {
        generator = "Ninja",
        singleSource = {
            uri ="https://github.com/abseil/abseil-cpp/releases/download/20240722.0/abseil-cpp-20240722.0.tar.gz",
            sha256sum = "f50e5ac311a81382da7fa75b97310e4b9006474f9560ac46f54a9967f07d4ae3"
        },
        biDrvs = [
            drvs.linuxHeaders,
        ]
    }
}