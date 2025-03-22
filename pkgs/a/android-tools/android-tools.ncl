{
    lib,
    drvs,
    androidTools | lib.CmakePackage = {
        generator= "Ninja",
        singleSource={
            uri = "https://github.com/nmeum/android-tools/archive/refs/tags/35.0.2.tar.gz",
            sha256sum = "048bd42b75166fa4b66989b25ba1abb2b773aa7b7d012d52d84010b127db8801"
        }
    }
}