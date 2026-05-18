{
  lib,
  drvs,
  bubblejail | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/igo95862/bubblejail/archive/refs/tags/0.10.2.tar.gz",
      sha256sum = "0a1b00019b67a1f650a99df1dbf1626705bb979f98bc65bcd6ef5c8b3cd5c046",
    },

    sourceInputs = [
      {
        src = singleSource
      },
      {
        src = {
          uri = "https://github.com/igo95862/python-lxns/archive/80d84583e196e3320ea487f43783c16cc4abd261.tar.gz",
          sha256sum = "a14a053656e0abc3059faff274495a4bdaa6aa70a26f12512ee79b4a69d8ea7a"
        },
        dest = "subprojects/lxns"
      }
    ],
    biDrvs = [
      drvs.pythonJinja2,
      drvs.pythonMarkupsafe,
    ],
  }
}
