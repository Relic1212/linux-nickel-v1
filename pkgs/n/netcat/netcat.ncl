{
  lib,
  drvs,
  netcatGnu | lib.AutotoolsPackage = {
    singleSource = {
      uri = "http://sourceforge.net/projects/netcat/files/netcat/0.7.1/netcat-0.7.1.tar.gz",
      sha256sum = "30719c9a4ffbcf15676b8f528233ccc54ee6cba96cb4590975f5fd60c68a066f",
    },
  },
  nc110 | lib.MakePackage = {
    singleSource = {
      uri = "https://downloads.sourceforge.net/project/nc110/community%20releases/nc110.20180111.tar.xz",
      sha256sum = "9c223f2472fc5b0d77c29a88536913e6573217cbc028dd276c30e689feeb182d",
    },
    buildEnv = {
      EXTRA_CFLAGS = [
        "-Wno-int-conversion"
      ],
    },
    makeTargets = [
      "nc",
    ],
    extraMakeArgs = [
      "CC=\"${CC} ${CFLAGS}\"",
      "CFLAGS=\"${CFLAGS}\"",
      "LDFLAGS=\"${LDFLAGS}\"",
    ],
    installPhase = [
      "install -Dm0755 nc ${DEST}/usr/bin/nc",
      "install -Dm0755 nc.1 ${DEST}/usr/share/man/man1/nc.1",
    ],
  }
}
