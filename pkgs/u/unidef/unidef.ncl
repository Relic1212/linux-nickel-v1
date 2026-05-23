{
  lib,
  drvs,
  unidef | lib.MakePackage = {
    singleSource = {
      uri = "https://dotat.at/prog/unifdef/unifdef-2.12.tar.xz",
      sha256sum = "43ce0f02ecdcdc723b2475575563ddb192e988c886d368260bc0a63aee3ac400",
    },
    extraMakeArgs = [
      "prefix=/usr",
    ],
    extraMakeInstallArgs = extraMakeArgs,
  }
}
