{
  lib,
  drvs,
  pythonDlFunc | lib.Package = {
    options = {
      script | default = import "dl_func.py" as 'Text,
    },
    buildPhase = [
      lib.functions.writeFile "dl-func" options.script,
    ],
    installPhase = [
      "install -Dm0755 dl-func ${DEST}/usr/bin/dl-func",
      "chmod +x ${DEST}/usr/bin/dl-func",
    ],
    ###
  }
}
