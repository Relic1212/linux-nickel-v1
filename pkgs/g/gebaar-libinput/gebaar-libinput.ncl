{lib,
drvs,
gebaarLibinput | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
        uri = "https://github.com/Coffee2CodeNL/gebaar-libinput/archive/5cf60f525eb7c248c45aaa20b1747b8ba6518694.zip",
        sha256sum = "213e01766683a4bba86d34f515b8ca939668bc2c3bdf4c469d159f450790940d"
    },
    biDrvs = [
        drvs.libinput, 
        drvs.mtdev,
        drvs.libevdev,
        drvs.eudev,
        drvs.linuxHeaders,
        drvs.cxxopts,
        drvs.zlibNg,
        drvs.cpptoml,
    ],
    preConfigurePhase = [
        "sed -i 's@stdc++fs@@g' ${SRC}/CMakeLists.txt"
    ]
}
}

&

{
    lib,
    drvs,
    cxxopts | lib.CmakePackage = {
        generator = "Ninja",
        singleSource = {
            uri = "https://github.com/jarro2783/cxxopts/archive/refs/tags/v3.2.0.tar.gz",
            sha256sum = "9f43fa972532e5df6c5fd5ad0f5bac606cdec541ccaf1732463d8070bbb7f03b"
        },
        cmakeExtraArgsRecord = {
            "-DCXXOPTS_BUILD_TESTS" = "OFF",
        }
    }
}

&

{
    lib,
    drvs,
    cpptoml | lib.CmakePackage = {
        generator = "Ninja",
        singleSource = {
            uri = "https://github.com/skystrife/cpptoml/archive/refs/tags/v0.1.1.tar.gz",
            sha256sum = "23af72468cfd4040984d46a0dd2a609538579c78ddc429d6b8fd7a10a6e24403"
        },
        llvmProvider = drvs.llvmFull,
        cmakeExtraArgsRecord = {
            "-DLIBCXX_DIR"="/usr/lib/cmake/llvm",
            "-DENABLE_LIBCXX" = false,
            "-DCPPTOML_BUILD_EXAMPLES" = false,
        }
    }
}