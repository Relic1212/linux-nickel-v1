{
  lib,
  drvs,
  neatvnc | lib.MesonPackage = {
    singleSource = {
      # uri = "https://github.com/any1/neatvnc/archive/refs/tags/v0.9.5.tar.gz",
      # sha256sum = "8150a30bfbd350b046680650b52afcce5ae44d328cb396fb571c6f9b99811357",
      uri = "https://github.com/any1/neatvnc/archive/3cfedc0bef8d09a01690f0e462991c7d4cb40c9e.tar.gz",
      sha256sum = "6fa0b223475d43a69571830dac964ba2e15cc929e2757cbcda110f53079aa438",
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
    ],
  }
}
