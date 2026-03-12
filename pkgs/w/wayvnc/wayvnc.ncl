{
  lib,
  drvs,
  wayvnc | lib.MesonPackage = {
    singleSource = {
      #   uri = "https://github.com/any1/wayvnc/archive/refs/tags/v0.9.1.tar.gz",
      #   sha256sum = "aaaca02d36e54ec6ecf457dc266251946d895ac91521fbabb3470c3c09b3753c",

      uri = "https://github.com/any1/wayvnc/archive/223e4e9175df88dc87df3f08778b5e2b2acfb318.tar.gz",
      sha256sum = "0e56c8fa835b943e44d3deb83dd664b3b72555503c730bc211e9d2da66acfa32",
    },
    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lc++",
      ],
    },

    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.libdrm,
      drvs.libelf,
      drvs.libffi,
      drvs.libpciaccess,
      drvs.linuxHeaders,
      drvs.llvmConfigStatic,
      drvs.mesa2,
      drvs.spirvHeaders,
      drvs.spirvLlvmTranslator,
      drvs.spirvTools,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.zlibNg,
      drvs.pixman,
      drvs.libxkbcommon,
      drvs.aml,
      drvs.jansson,
      drvs.neatvnc,
    ],
  }
}
