{
  lib,
  drvs,
  pythonPyudev | lib.gpepPackage = {
    singleSource = {
      uri = "https://github.com/pyudev/pyudev/archive/refs/tags/v0.24.5.tar.gz",
      sha256sum = "2a5de2783e4b875d663494489aa4d251f10ec8057a70fd574a9ef2dba12edc06",
    },

    preConfigurePhase = [
      m%"sed -i 's@find_library(name)@f"lib{name}.so" # find_library(name)@g' ${SRC}/src/pyudev/_ctypeslib/utils.py"%
    ],
  }
}
